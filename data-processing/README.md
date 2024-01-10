This folder contain the datasets and scripts for replication of the study.


## raw-data

- Background Checks.csv: A table containing the raw counts of background checks in each state between January 1999 and December 2021. (source: FBI NICS)
- Firearm Accidents.csv: A table containing the number of accidents with firearms in each state between November 1999 and December 2020. (source: CDC Wonder)
- Firearm Homicides.csv: A table containing the number of homicides committed with firearms in each state between November 1999 and December 2020. (source: CDC Wonder)
- Firearm Suiicides.csv: A table containing the number of suicides committed with firearms in each state between November 1999 and December 2020. (source: CDC Wonder)
- Homicides.csv: A table containing the number of homicides in each state between November 1999 and December 2020. (source: CDC Wonder)
- Population.csv: A table containing the population size in each state between 1999 and 2022. (source: FBI NICS and US Census Bureau)
- Suicides.csv: A table containing the number of suicides in each state between November 1999 and December 2020. (source: CDC Wonder)
- State Firearm Law Database 4.xlsx: An excel file containing data about all state firearm laws. The sheet titled "Laws 2000-2019" contains the subset of laws used in this study. The sheet titled "Pivot" contains the counts of laws in each class, divided by region and effect. (source: RAND)


## scripts
- process_data.m: reads the raw data and computed relevant variables (such as firearm restrictiveness, number of firearms, and deaths per firearm) to create time series on national and regional levels.
- seasonal_adjustment_and_detrending.R: reads processed time series and seasonally-adjusts and retreads them.
- save_mat.m: reads seasonally-adjusted and defended time series, removes an extra column that is introduced by R, and saves them in .m format for analysis in Matlab.


To process the raw data, run the scripts in the following sequence: 
1) process_data.m
2) seasonal_adjustment_and_detrending.R
3) save_mat.m
