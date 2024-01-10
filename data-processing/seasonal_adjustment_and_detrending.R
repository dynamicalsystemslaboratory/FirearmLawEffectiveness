############################ load relevant libraries ###########################
library(readxl)
library(forecast)
library(ggplot2)
library(dplyr)
library(stats)


################################ define functions ##############################

# a function to seasonally adjust and detrend daily time series
daily_sa_dt <- function(ts) {
  ts_sa_dt <- mstl(msts(ts, seasonal.periods=c(7, 365.25/12, 365.25))) # Decompose the time series along several seasonal periods
  ts_sa_dt <- ts_sa_dt[,ncol(ts_sa_dt)] # Select only the last column (seasonally adjusted and detrended time series)
  # ts_sa_dt %>% autoplot() # plot each of the decompositions
  # ts_sa_dt %>% seasadj() %>% autoplot() # plot the seasonally-adjusted time series, but keep the trend
  return(ts_sa_dt)
}

# a function to seasonally adjust and detrend monthly time series
monthly_sa_dt <- function(ts) {
  ts_sa_dt <- mstl(msts(ts, seasonal.periods=c(3,4,6,12))) # Decompose the time series along several seasonal periods
  ts_sa_dt <- ts_sa_dt[,ncol(ts_sa_dt)] # Select only the last column (seasonally adjusted and detrended time series)
  # ts_sa_dt %>% autoplot() # plot each of the decompositions
  # ts_sa_dt %>% seasadj() %>% autoplot() # plot the seasonally-adjusted time series, but keep the trend
  return(ts_sa_dt)
}


################################### read data ##################################
setwd(paste(dirname(rstudioapi::getActiveDocumentContext()$path),"/processed-data",sep=""))
accidents_per_firearm <- read.csv("accidents_per_firearm.csv") # monthly firearm accidents per firearms (inferred from firearm ownership) on a state level
background_checks <- read.csv("background_checks.csv") # monthly background checks on a state level
deaths_per_bc <- read.csv("deaths_per_bc.csv") # monthly violence per firearm on a state level
deaths_per_ffs_firearm <- read.csv("deaths_per_ffs_firearm.csv") # monthly violence per firearm on a state level
deaths_per_firearm <- read.csv("deaths_per_firearm.csv") # monthly violence per firearm on a state level
deaths_per_int_bc <- read.csv("deaths_per_int_bc.csv") # monthly violence per firearm on a state level
firearm_accidents <- read.csv("firearm_accidents.csv") # monthly firearm accidents on a state level
firearm_deaths <- read.csv("firearm_deaths.csv") # monthly firearm deaths on a state level
firearm_homicides <- read.csv("firearm_homicides.csv") # monthly firearm homicides on a state level
firearm_law_counts <- read.csv("firearm_law_counts.csv") # monthly firearm law counts on a state, region, and division level
firearm_law_fractions <- read.csv("firearm_law_fractions.csv") # monthly fraction of population affected by firearm laws on a state, region, and division level
firearm_suicides <- read.csv("firearm_suicides.csv") # monthly firearm suicides on a state level
firearms_ffs <- read.csv("firearms_ffs.csv") # monthly firearm homicides per capita on a state level
firearms_fo <- read.csv("firearms_fo.csv") # monthly firearm homicides per capita on a state level
fraction_of_firearm_suicides <- read.csv("fraction_of_firearm_suicides.csv") # monthly fraction of firearm suicides on a state level
homicides_per_firearm <- read.csv("homicides_per_firearm.csv") # monthly suicides per firearm ownership on a national level
int_background_checks <- read.csv("int_background_checks.csv") # integral of monthly background checks on a state level
suicides_per_firearm <- read.csv("suicides_per_firearm.csv") # monthly suicides per firearm ownership on a national level


################## replace NaN and inf with 0 ###################
accidents_per_firearm <- accidents_per_firearm %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
background_checks <- background_checks %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
deaths_per_bc <- deaths_per_bc %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
deaths_per_int_bc <- deaths_per_int_bc %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
deaths_per_ffs_firearm <- deaths_per_ffs_firearm %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
deaths_per_firearm <- deaths_per_firearm %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
firearm_accidents <- firearm_accidents %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
firearm_deaths <- firearm_deaths %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
firearm_homicides <- firearm_homicides %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
firearm_law_counts <- firearm_law_counts %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
firearm_law_fractions <- firearm_law_fractions %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
firearm_suicides <- firearm_suicides %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
firearms_ffs <- firearms_ffs %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
firearms_fo <- firearms_fo %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
fraction_of_firearm_suicides <- fraction_of_firearm_suicides %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
homicides_per_firearm <- homicides_per_firearm %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
int_background_checks <- int_background_checks %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))
suicides_per_firearm <- suicides_per_firearm %>% mutate_if(is.numeric, function(x) ifelse(is.infinite(x), 0, x))


################## seasonally-adjust and detrend time series ###################
accidents_per_firearm_sa_dt <- cbind(accidents_per_firearm[,1:2], sapply(accidents_per_firearm[,3:dim(accidents_per_firearm)[2]], function(x) monthly_sa_dt(x)))
background_checks_sa_dt <- cbind(background_checks[,1:2], sapply(background_checks[,3:dim(background_checks)[2]], function(x) monthly_sa_dt(x)))
deaths_per_bc_sa_dt <- cbind(deaths_per_bc[,1:2], sapply(deaths_per_bc[,3:dim(deaths_per_bc)[2]], function(x) monthly_sa_dt(x)))
deaths_per_int_bc_sa_dt <- cbind(deaths_per_int_bc[,1:2], sapply(deaths_per_int_bc[,3:dim(deaths_per_int_bc)[2]], function(x) monthly_sa_dt(x)))
deaths_per_ffs_firearm_sa_dt <- cbind(deaths_per_ffs_firearm[,1:2], sapply(deaths_per_ffs_firearm[,3:dim(deaths_per_ffs_firearm)[2]], function(x) monthly_sa_dt(x)))
deaths_per_firearm_sa_dt <- cbind(deaths_per_firearm[,1:2], sapply(deaths_per_firearm[,3:dim(deaths_per_firearm)[2]], function(x) monthly_sa_dt(x)))
firearm_accidents_sa_dt <- cbind(firearm_accidents[,1:2], sapply(firearm_accidents[,3:dim(firearm_accidents)[2]], function(x) monthly_sa_dt(x)))
firearm_deaths_sa_dt <- cbind(firearm_deaths[,1:2], sapply(firearm_deaths[,3:dim(firearm_deaths)[2]], function(x) monthly_sa_dt(x)))
firearm_homicides_sa_dt <- cbind(firearm_homicides[,1:2], sapply(firearm_homicides[,3:dim(firearm_homicides)[2]], function(x) monthly_sa_dt(x)))
firearm_law_counts_sa_dt <- cbind(firearm_law_counts[,1:2], sapply(firearm_law_counts[,3:dim(firearm_law_counts)[2]], function(x) monthly_sa_dt(x)))
firearm_law_fractions_sa_dt <- cbind(firearm_law_fractions[,1:2], sapply(firearm_law_fractions[,3:dim(firearm_law_fractions)[2]], function(x) monthly_sa_dt(x)))
firearm_suicides_sa_dt <- cbind(firearm_suicides[,1:2], sapply(firearm_suicides[,3:dim(firearm_suicides)[2]], function(x) monthly_sa_dt(x)))
firearms_ffs_sa_dt <- cbind(firearms_ffs[,1:2], sapply(firearms_ffs[,3:dim(firearms_ffs)[2]], function(x) monthly_sa_dt(x)))
firearms_fo_sa_dt <- cbind(firearms_fo[,1:2], sapply(firearms_fo[,3:dim(firearms_fo)[2]], function(x) monthly_sa_dt(x)))
fraction_of_firearm_suicides_sa_dt <- cbind(fraction_of_firearm_suicides[,1:2], sapply(fraction_of_firearm_suicides[,3:dim(fraction_of_firearm_suicides)[2]], function(x) monthly_sa_dt(x)))
homicides_per_firearm_sa_dt <- cbind(homicides_per_firearm[,1:4], sapply(homicides_per_firearm[,5:dim(homicides_per_firearm)[2]], function(x) monthly_sa_dt(x)))
int_background_checks_sa_dt <- cbind(int_background_checks[,1:2], sapply(int_background_checks[,3:dim(int_background_checks)[2]], function(x) monthly_sa_dt(x)))
suicides_per_firearm_sa_dt <- cbind(suicides_per_firearm[,1:4], sapply(suicides_per_firearm[,5:dim(suicides_per_firearm)[2]], function(x) monthly_sa_dt(x)))


############# save the seasonally-adjust and detrended time series #############
write.csv(accidents_per_firearm_sa_dt, "accidents_per_firearm_sa_dt.csv")
write.csv(background_checks_sa_dt, "background_checks_sa_dt.csv")
write.csv(deaths_per_bc_sa_dt, "deaths_per_bc_sa_dt.csv")
write.csv(deaths_per_int_bc_sa_dt, "deaths_per_int_bc_sa_dt.csv")
write.csv(deaths_per_ffs_firearm_sa_dt, "deaths_per_ffs_firearm_sa_dt.csv")
write.csv(deaths_per_firearm_sa_dt, "deaths_per_firearm_sa_dt.csv")
write.csv(firearm_accidents_sa_dt, "firearm_accidents_sa_dt.csv")
write.csv(firearm_deaths_sa_dt, "firearm_deaths_sa_dt.csv")
write.csv(firearm_homicides_sa_dt, "firearm_homicides_sa_dt.csv")
write.csv(firearm_law_counts_sa_dt, "firearm_law_counts_sa_dt.csv")
write.csv(firearm_law_fractions_sa_dt, "firearm_law_fractions_sa_dt.csv")
write.csv(firearm_suicides_sa_dt, "firearm_suicides_sa_dt.csv")
write.csv(firearms_ffs_sa_dt, "firearms_ffs_sa_dt.csv")
write.csv(firearms_fo_sa_dt, "firearms_fo_sa_dt.csv")
write.csv(fraction_of_firearm_suicides_sa_dt, "fraction_of_firearm_suicides_sa_dt.csv")
write.csv(homicides_per_firearm_sa_dt, "homicides_per_firearm_sa_dt.csv")
write.csv(int_background_checks_sa_dt, "int_background_checks_sa_dt.csv")
write.csv(suicides_per_firearm_sa_dt, "suicides_per_firearm_sa_dt.csv")

