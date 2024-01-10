%% initialize variables

clc;
clear;

states=[{'Alabama'} {'Arizona'} {'Arkansas'} {'California'} {'Colorado'} {'Connecticut'} ...
    {'Delaware'} {'Florida'} {'Georgia'} {'Idaho'} {'Illinois'} {'Indiana'} {'Iowa'} ... 
    {'Kansas'} {'Kentucky'} {'Louisiana'} {'Maine'} {'Maryland'} {'Massachusetts'} {'Michigan'} ... 
    {'Minnesota'} {'Mississippi'} {'Missouri'} {'Montana'} {'Nebraska'} {'Nevada'} {'New Hampshire'} ...
    {'New Jersey'} {'New Mexico'} {'New York'} {'North Carolina'} {'North Dakota'} {'Ohio'} {'Oklahoma'} ...
    {'Oregon'} {'Pennsylvania'} {'Rhode Island'} {'South Carolina'} {'South Dakota'} {'Tennessee'} {'Texas'} ...
    {'Utah'} {'Vermont'} {'Virginia'} {'Washington'} {'West Virginia'} {'Wisconsin'} {'Wyoming'}];
    
    % note that Alaska, Hawaii and District of Columbia are removed from the
    % analysis as there are no records of background checks in those states

regions = [{'Northeast'} {'Midwest'} {'South'} {'West'}];
northeast = [{'Connecticut'} {'Maine'} {'Massachusetts'} {'New Hampshire'} {'Rhode Island'} {'Vermont'} {'New Jersey'} {'New York'} {'Pennsylvania'}];
midwest = [{'Indiana'} {'Illinois'} {'Michigan'} {'Ohio'} {'Wisconsin'} {'Iowa'} {'Kansas'} {'Minnesota'} {'Missouri'} {'Nebraska'} {'North Dakota'} {'South Dakota'}];
south = [{'Delaware'} {'Florida'} {'Georgia'} {'Maryland'} {'North Carolina'} {'South Carolina'} {'Virginia'} {'West Virginia'} {'Alabama'} {'Kentucky'} {'Mississippi'} {'Tennessee'} {'Arkansas'} {'Louisiana'} {'Oklahoma'} {'Texas'}];
west = [{'Arizona'} {'Colorado'} {'Idaho'} {'New Mexico'} {'Montana'} {'Utah'} {'Nevada'} {'Wyoming'} {'California'} {'Hawaii'} {'Oregon'} {'Washington'}];

divisions =  [{'New England'} {'Middle Atlantic'} {'East North Central'} {'West North Central'} {'South Atlantic'} {'East South Central'} {'West South Central'} {'Mountain'} {'Pacific'}];
new_england = [{'Connecticut'} {'Maine'} {'Massachusetts'} {'New Hampshire'} {'Rhode Island'} {'Vermont'}];
middle_atlantic = [{'New Jersey'} {'New York'} {'Pennsylvania'}];
east_north_central = [{'Indiana'} {'Illinois'} {'Michigan'} {'Ohio'} {'Wisconsin'}];
west_north_central = [{'Iowa'} {'Kansas'} {'Minnesota'} {'Missouri'} {'Nebraska'} {'North Dakota'} {'South Dakota'}];
south_atlantic = [{'Delaware'} {'Florida'} {'Georgia'} {'Maryland'} {'North Carolina'} {'South Carolina'} {'Virginia'} {'West Virginia'}];
east_south_central = [{'Alabama'} {'Kentucky'} {'Mississippi'} {'Tennessee'}];
west_south_central = [{'Arkansas'} {'Louisiana'} {'Oklahoma'} {'Texas'}];
mountain = [{'Arizona'} {'Colorado'} {'Idaho'} {'New Mexico'} {'Montana'} {'Utah'} {'Nevada'} {'Wyoming'}];
pacific = [{'California'} {'Hawaii'} {'Oregon'} {'Washington'}];

% Regions and Divisions are based on census definitions: https://www2.census.gov/geo/pdfs/maps-data/maps/reference/us_regdiv.pdf

years_1999_2020=[1999:2020];
months=[1:12];

% define directories
cd(fileparts(matlab.desktop.editor.getActiveFilename)) % change directory to the one containing this m-file
current_dir = pwd;
raw_datasets_directory = strcat(current_dir,'/raw-data/'); % folder with raw data
processed_datasets_directory = strcat(current_dir,'/processed-data/'); % folder to save processed data in

cd(raw_datasets_directory);


%% process data about population

population = readtable("Population.csv"); % load dataset
population.Alaska=[]; % remove Alaska from the dataset
population = array2table(repelem(population{:,:},12,1)); % reshape dataset
population.Properties.VariableNames = [{'Year'} states]; % standrdize column names
population.USA = sum(population{:,2:end},2); % compute USA total
population.northeast = sum(population{:,ismember(population.Properties.VariableNames,northeast)},2);
population.midwest = sum(population{:,ismember(population.Properties.VariableNames,midwest)},2);
population.south = sum(population{:,ismember(population.Properties.VariableNames,south)},2);
population.west = sum(population{:,ismember(population.Properties.VariableNames,west)},2);
population.new_england = sum(population{:,ismember(population.Properties.VariableNames,new_england)},2);
population.middle_atlantic = sum(population{:,ismember(population.Properties.VariableNames,middle_atlantic)},2);
population.east_north_central = sum(population{:,ismember(population.Properties.VariableNames,east_north_central)},2);
population.west_north_central = sum(population{:,ismember(population.Properties.VariableNames,west_north_central)},2);
population.south_atlantic = sum(population{:,ismember(population.Properties.VariableNames,south_atlantic)},2);
population.east_south_central = sum(population{:,ismember(population.Properties.VariableNames,east_south_central)},2);
population.west_south_central = sum(population{:,ismember(population.Properties.VariableNames,west_south_central)},2);
population.mountain = sum(population{:,ismember(population.Properties.VariableNames,mountain)},2);
population.pacific = sum(population{:,ismember(population.Properties.VariableNames,pacific)},2);

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
% population = population(find(population.Year==2000):(find(population.Year==2020)-3),:);

% save the processed data
writetable(population,strcat(processed_datasets_directory,'population.csv'))
save(strcat(processed_datasets_directory,'population.mat'),'population')


%% process data about background checks

background_checks = readtable("Background Checks.csv"); % load dataset
background_checks.Hawaii = []; % remove Hawaii from the dataset
background_checks.Alaska = []; % remove Alaska from the dataset
background_checks.Properties.VariableNames = [{'Year'} {'Month'} states]; % standrdize column names
background_checks.USA = sum(background_checks{:,3:end},2); % compute USA total
background_checks.northeast = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,northeast)},2);
background_checks.midwest = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,midwest)},2);
background_checks.south = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,south)},2);
background_checks.west = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,west)},2);
background_checks.new_england = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,new_england)},2);
background_checks.middle_atlantic = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,middle_atlantic)},2);
background_checks.east_north_central = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,east_north_central)},2);
background_checks.west_north_central = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,west_north_central)},2);
background_checks.south_atlantic = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,south_atlantic)},2);
background_checks.east_south_central = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,east_south_central)},2);
background_checks.west_south_central = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,west_south_central)},2);
background_checks.mountain = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,mountain)},2);
background_checks.pacific = sum(background_checks{:,ismember(background_checks.Properties.VariableNames,pacific)},2);

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
background_checks = background_checks(find((background_checks.Year==2000).*(background_checks.Month==1)):find((background_checks.Year==2019).*(background_checks.Month==10)),:);

% save the processed data
writetable(background_checks,strcat(processed_datasets_directory,'background_checks.csv'));
save(strcat(processed_datasets_directory,'background_checks.mat'),'background_checks');


%% process data about the integral of background checks

int_background_checks = readtable("Background Checks.csv"); % load dataset
int_background_checks.Hawaii = []; % remove Hawaii from the dataset
int_background_checks.Alaska = []; % remove Alaska from the dataset
int_background_checks.Properties.VariableNames = [{'Year'} {'Month'} states]; % standrdize column names
int_background_checks.USA = sum(int_background_checks{:,3:end},2); % compute USA total
int_background_checks.northeast = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,northeast)},2);
int_background_checks.midwest = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,midwest)},2);
int_background_checks.south = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,south)},2);
int_background_checks.west = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,west)},2);
int_background_checks.new_england = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,new_england)},2);
int_background_checks.middle_atlantic = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,middle_atlantic)},2);
int_background_checks.east_north_central = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,east_north_central)},2);
int_background_checks.west_north_central = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,west_north_central)},2);
int_background_checks.south_atlantic = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,south_atlantic)},2);
int_background_checks.east_south_central = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,east_south_central)},2);
int_background_checks.west_south_central = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,west_south_central)},2);
int_background_checks.mountain = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,mountain)},2);
int_background_checks.pacific = sum(int_background_checks{:,ismember(int_background_checks.Properties.VariableNames,pacific)},2);

% sum the background checks
int_background_checks{:,3:end} = cumsum(int_background_checks{:,3:end}); 

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
int_background_checks = int_background_checks(find((int_background_checks.Year==2000).*(int_background_checks.Month==1)):find((int_background_checks.Year==2019).*(int_background_checks.Month==10)),:);

% save the processed data
writetable(int_background_checks,strcat(processed_datasets_directory,'int_background_checks.csv'));
save(strcat(processed_datasets_directory,'int_background_checks.mat'),'int_background_checks');


%% process data about firearm accidents

firearm_accidents = readtable("Firearm Accidents.csv");
firearm_accidents = firearm_accidents(ismember(firearm_accidents.State,states),:); % remove Alaska, Hawaii and District of Columbia
firearm_accidents = array2table([repelem(unique(firearm_accidents.Year),12) repmat(months',size(unique(firearm_accidents.Year),1),1) reshape(firearm_accidents.Accidents,size(firearm_accidents,1)/size(states,2),size(states,2))],'VariableNames',[{'Year'} {'Month'} states]); % reshape dataset
firearm_accidents.USA = sum(firearm_accidents{:,3:end},2); % compute USA total
firearm_accidents.northeast = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,northeast)},2);
firearm_accidents.midwest = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,midwest)},2);
firearm_accidents.south = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,south)},2);
firearm_accidents.west = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,west)},2);
firearm_accidents.new_england = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,new_england)},2);
firearm_accidents.middle_atlantic = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,middle_atlantic)},2);
firearm_accidents.east_north_central = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,east_north_central)},2);
firearm_accidents.west_north_central = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,west_north_central)},2);
firearm_accidents.south_atlantic = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,south_atlantic)},2);
firearm_accidents.east_south_central = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,east_south_central)},2);
firearm_accidents.west_south_central = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,west_south_central)},2);
firearm_accidents.mountain = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,mountain)},2);
firearm_accidents.pacific = sum(firearm_accidents{:,ismember(firearm_accidents.Properties.VariableNames,pacific)},2);

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
firearm_accidents = firearm_accidents(find((firearm_accidents.Year==2000).*(firearm_accidents.Month==1)):find((firearm_accidents.Year==2019).*(firearm_accidents.Month==10)),:);

% save the processed data
writetable(firearm_accidents,strcat(processed_datasets_directory,'firearm_accidents.csv'));
save(strcat(processed_datasets_directory,'firearm_accidents.mat'),'firearm_accidents');


%% process data about suicides (used to compute fraction of suicides with firearms out of all suicides)

suicides = readtable("Suicides.csv");
suicides = suicides(ismember(suicides.State,states),:); % remove Alaska, Hawaii and District of Columbia
suicides = array2table([repelem(unique(suicides.Year),12) repmat(months',size(unique(suicides.Year),1),1) reshape(suicides.Suicides,size(suicides,1)/size(states,2),size(states,2))],'VariableNames',[{'Year'} {'Month'} states]); % reshape dataset
suicides.USA = sum(suicides{:,3:end},2); % compute USA total
suicides.northeast = sum(suicides{:,ismember(suicides.Properties.VariableNames,northeast)},2);
suicides.midwest = sum(suicides{:,ismember(suicides.Properties.VariableNames,midwest)},2);
suicides.south = sum(suicides{:,ismember(suicides.Properties.VariableNames,south)},2);
suicides.west = sum(suicides{:,ismember(suicides.Properties.VariableNames,west)},2);
suicides.new_england = sum(suicides{:,ismember(suicides.Properties.VariableNames,new_england)},2);
suicides.middle_atlantic = sum(suicides{:,ismember(suicides.Properties.VariableNames,middle_atlantic)},2);
suicides.east_north_central = sum(suicides{:,ismember(suicides.Properties.VariableNames,east_north_central)},2);
suicides.west_north_central = sum(suicides{:,ismember(suicides.Properties.VariableNames,west_north_central)},2);
suicides.south_atlantic = sum(suicides{:,ismember(suicides.Properties.VariableNames,south_atlantic)},2);
suicides.east_south_central = sum(suicides{:,ismember(suicides.Properties.VariableNames,east_south_central)},2);
suicides.west_south_central = sum(suicides{:,ismember(suicides.Properties.VariableNames,west_south_central)},2);
suicides.mountain = sum(suicides{:,ismember(suicides.Properties.VariableNames,mountain)},2);
suicides.pacific = sum(suicides{:,ismember(suicides.Properties.VariableNames,pacific)},2);

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
suicides = suicides(find((suicides.Year==2000).*(suicides.Month==1)):find((suicides.Year==2019).*(suicides.Month==10)),:);


%% process data about firearm suicides

firearm_suicides = readtable("Firearm Suicides.csv");
firearm_suicides = firearm_suicides(ismember(firearm_suicides.State,states),:); % remove Hawaii and District of Columbia
firearm_suicides = array2table([repelem(unique(firearm_suicides.Year),12) repmat(months',size(unique(firearm_suicides.Year),1),1) reshape(firearm_suicides.GunSuicides,size(firearm_suicides,1)/size(states,2),size(states,2))],'VariableNames',[{'Year'} {'Month'} states]); % reshape dataset
firearm_suicides.USA = sum(firearm_suicides{:,3:end},2); % compute USA total
firearm_suicides.northeast = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,northeast)},2);
firearm_suicides.midwest = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,midwest)},2);
firearm_suicides.south = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,south)},2);
firearm_suicides.west = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,west)},2);
firearm_suicides.new_england = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,new_england)},2);
firearm_suicides.middle_atlantic = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,middle_atlantic)},2);
firearm_suicides.east_north_central = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,east_north_central)},2);
firearm_suicides.west_north_central = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,west_north_central)},2);
firearm_suicides.south_atlantic = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,south_atlantic)},2);
firearm_suicides.east_south_central = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,east_south_central)},2);
firearm_suicides.west_south_central = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,west_south_central)},2);
firearm_suicides.mountain = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,mountain)},2);
firearm_suicides.pacific = sum(firearm_suicides{:,ismember(firearm_suicides.Properties.VariableNames,pacific)},2);

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
firearm_suicides = firearm_suicides(find((firearm_suicides.Year==2000).*(firearm_suicides.Month==1)):find((firearm_suicides.Year==2019).*(firearm_suicides.Month==10)),:);

% save the processed data
writetable(firearm_suicides,strcat(processed_datasets_directory,'firearm_suicides.csv'));
save(strcat(processed_datasets_directory,'firearm_suicides.mat'),'firearm_suicides');

%% compute fraction of suicides with firearms

fraction_of_firearm_suicides = firearm_suicides;
fraction_of_firearm_suicides{:,3:end} = fraction_of_firearm_suicides{:,3:end}./suicides{:,3:end};

% save the processed data
writetable(fraction_of_firearm_suicides,strcat(processed_datasets_directory,'fraction_of_firearm_suicides.csv'));
save(strcat(processed_datasets_directory,'fraction_of_firearm_suicides.mat'),'fraction_of_firearm_suicides');


%% process data about homicides (used to compute fraction of homicides with firearms out of all homicides)

homicides = readtable("Homicides.csv");
homicides = homicides(ismember(homicides.State,states),:); % remove Hawaii and District of Columbia
homicides = array2table([repelem(unique(homicides.Year),12) repmat(months',size(unique(homicides.Year),1),1) reshape(homicides.Homicides,size(homicides,1)/size(states,2),size(states,2))],'VariableNames',[{'Year'} {'Month'} states]); % reshape dataset
homicides.USA = sum(homicides{:,3:end},2); % compute USA total
homicides.northeast = sum(homicides{:,ismember(homicides.Properties.VariableNames,northeast)},2);
homicides.midwest = sum(homicides{:,ismember(homicides.Properties.VariableNames,midwest)},2);
homicides.south = sum(homicides{:,ismember(homicides.Properties.VariableNames,south)},2);
homicides.west = sum(homicides{:,ismember(homicides.Properties.VariableNames,west)},2);
homicides.new_england = sum(homicides{:,ismember(homicides.Properties.VariableNames,new_england)},2);
homicides.middle_atlantic = sum(homicides{:,ismember(homicides.Properties.VariableNames,middle_atlantic)},2);
homicides.east_north_central = sum(homicides{:,ismember(homicides.Properties.VariableNames,east_north_central)},2);
homicides.west_north_central = sum(homicides{:,ismember(homicides.Properties.VariableNames,west_north_central)},2);
homicides.south_atlantic = sum(homicides{:,ismember(homicides.Properties.VariableNames,south_atlantic)},2);
homicides.east_south_central = sum(homicides{:,ismember(homicides.Properties.VariableNames,east_south_central)},2);
homicides.west_south_central = sum(homicides{:,ismember(homicides.Properties.VariableNames,west_south_central)},2);
homicides.mountain = sum(homicides{:,ismember(homicides.Properties.VariableNames,mountain)},2);
homicides.pacific = sum(homicides{:,ismember(homicides.Properties.VariableNames,pacific)},2);

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
homicides = homicides(find((homicides.Year==2000).*(homicides.Month==1)):find((homicides.Year==2019).*(homicides.Month==10)),:);


%% process data about firearm homicides

firearm_homicides = readtable("Firearm Homicides.csv");
firearm_homicides = firearm_homicides(ismember(firearm_homicides.State,states),:); % remove Hawaii and District of Columbia
firearm_homicides = array2table([repelem(unique(firearm_homicides.Year),12) repmat(months',size(unique(firearm_homicides.Year),1),1) reshape(firearm_homicides.GunHomicides,size(firearm_homicides,1)/size(states,2),size(states,2))],'VariableNames',[{'Year'} {'Month'} states]); % reshape dataset
firearm_homicides.USA = sum(firearm_homicides{:,3:end},2); % compute USA total
firearm_homicides.northeast = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,northeast)},2);
firearm_homicides.midwest = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,midwest)},2);
firearm_homicides.south = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,south)},2);
firearm_homicides.west = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,west)},2);
firearm_homicides.new_england = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,new_england)},2);
firearm_homicides.middle_atlantic = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,middle_atlantic)},2);
firearm_homicides.east_north_central = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,east_north_central)},2);
firearm_homicides.west_north_central = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,west_north_central)},2);
firearm_homicides.south_atlantic = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,south_atlantic)},2);
firearm_homicides.east_south_central = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,east_south_central)},2);
firearm_homicides.west_south_central = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,west_south_central)},2);
firearm_homicides.mountain = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,mountain)},2);
firearm_homicides.pacific = sum(firearm_homicides{:,ismember(firearm_homicides.Properties.VariableNames,pacific)},2);

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
firearm_homicides = firearm_homicides(find((firearm_homicides.Year==2000).*(firearm_homicides.Month==1)):find((firearm_homicides.Year==2019).*(firearm_homicides.Month==10)),:);

% save the processed data
writetable(firearm_homicides,strcat(processed_datasets_directory,'firearm_homicides.csv'));
save(strcat(processed_datasets_directory,'firearm_homicides.mat'),'firearm_homicides');


%% compute firearm deaths by adding firearm accidents with firearm homicides and firearm suicides

firearm_deaths = firearm_accidents;
firearm_deaths{:,3:end} = firearm_deaths{:,3:end}+firearm_homicides{:,3:end}+firearm_suicides{:,3:end};

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
firearm_deaths = firearm_deaths(find((firearm_deaths.Year==2000).*(firearm_deaths.Month==1)):find((firearm_deaths.Year==2019).*(firearm_deaths.Month==10)),:);

% save the processed data
writetable(firearm_deaths,strcat(processed_datasets_directory,'firearm_deaths.csv'));
save(strcat(processed_datasets_directory,'firearm_deaths.mat'),'firearm_deaths');


%% clean laws data set

firearm_laws = readtable("State Firearm Law Database 4.xlsx","Sheet","Database");

% fix column types
firearm_laws.EffectiveDateMonth = str2double(firearm_laws.EffectiveDateMonth);
firearm_laws.EffectiveDateDay = str2double(firearm_laws.EffectiveDateDay);
firearm_laws.LawClass_num_ = str2double(firearm_laws.LawClass_num_);
firearm_laws.Effect = strcmp(firearm_laws.Effect,'Permissive');

% clean data
firearm_laws(~ismember(firearm_laws.State,states),:)=[]; % remove laws in Alaska, Hawaii and District of Columbia
firearm_laws = firearm_laws(datetime(firearm_laws.EffectiveDate)>datetime(1999,12,31),:); % remove laws before 2000
firearm_laws = firearm_laws(datetime(firearm_laws.EffectiveDate)<datetime(2021,1,1),:); % remove laws after 2020

for s = states
    state_laws = firearm_laws(strcmp(firearm_laws.State,s),:); % get all laws passed in the state
    [~,ind] = unique([state_laws.LawClass_num_ state_laws.Effect state_laws.EffectiveDateMonth state_laws.EffectiveDateYear],'rows'); % identify the laws that are redundant (of the same class and effect, and passed within the same month)
    if size(ind,1)~=size(state_laws,1) % if there are redundant laws
        firearm_laws(ismember(firearm_laws.LawID,state_laws.LawID(~ismember(1:size(state_laws,1),ind))),:)=[]; % remove the redundant laws from the list of firearm laws
    end
end


%% generate time series for counts of firearm laws on a national, regional, and divisional level

firearm_law_counts = array2table(zeros(size(years_1999_2020,2)*size(months,2),30),'VariableNames',[{'Year'} {'Month'} ...
    {'permissive'} {'restrictive'} ...    
    {'permissive_northeast'} {'restrictive_northeast'} {'permissive_midwest'} {'restrictive_midwest'} ...
    {'permissive_south'} {'restrictive_south'} {'permissive_west'} {'restrictive_west'} ...
    {'permissive_new_england'} {'restrictive_new_england'} {'permissive_middle_atlantic'} {'restrictive_middle_atlantic'} ...
    {'permissive_east_north_central'} {'restrictive_east_north_central'} {'permissive_west_north_central'} {'restrictive_west_north_central'} ...
    {'permissive_south_atlantic'} {'restrictive_south_atlantic'} {'permissive_east_south_central'} {'restrictive_east_south_central'} ...
    {'permissive_west_south_central'} {'restrictive_west_south_central'} {'permissive_mountain'} {'restrictive_mountain'} ...
    {'permissive_pacific'} {'restrictive_pacific'}]);
firearm_law_counts.Year = repelem(years_1999_2020',size(months,2),1);
firearm_law_counts.Month = repmat(months',size(years_1999_2020,2),1);

for ind = 1:size(firearm_laws,1)
    t_ind = find((firearm_law_counts.Year==firearm_laws.EffectiveDateYear(ind)).*(firearm_law_counts.Month==firearm_laws.EffectiveDateMonth(ind))); % find year/month time index
    if firearm_laws.Effect(ind)==0
        % add national count
        firearm_law_counts.restrictive(t_ind)=firearm_law_counts.restrictive(t_ind)+1;
        % add regional counts
        if ismember(firearm_laws.State(ind),northeast)
            firearm_law_counts.restrictive_northeast(t_ind)=firearm_law_counts.restrictive_northeast(t_ind)+ismember(firearm_laws.State(ind),northeast);
        elseif ismember(firearm_laws.State(ind),midwest)
            firearm_law_counts.restrictive_midwest(t_ind)=firearm_law_counts.restrictive_midwest(t_ind)+ismember(firearm_laws.State(ind),midwest);
        elseif ismember(firearm_laws.State(ind),south)
            firearm_law_counts.restrictive_south(t_ind)=firearm_law_counts.restrictive_south(t_ind)+ismember(firearm_laws.State(ind),south);
        elseif ismember(firearm_laws.State(ind),west)
            firearm_law_counts.restrictive_west(t_ind)=firearm_law_counts.restrictive_west(t_ind)+ismember(firearm_laws.State(ind),west);
        end
        % add division counts
        if ismember(firearm_laws.State(ind),new_england)
            firearm_law_counts.restrictive_new_england(t_ind)=firearm_law_counts.restrictive_new_england(t_ind)+ismember(firearm_laws.State(ind),new_england);
        elseif ismember(firearm_laws.State(ind),middle_atlantic)
            firearm_law_counts.restrictive_middle_atlantic(t_ind)=firearm_law_counts.restrictive_middle_atlantic(t_ind)+ismember(firearm_laws.State(ind),middle_atlantic);
        elseif ismember(firearm_laws.State(ind),east_north_central)
            firearm_law_counts.restrictive_east_north_central(t_ind)=firearm_law_counts.restrictive_east_north_central(t_ind)+ismember(firearm_laws.State(ind),east_north_central);
        elseif ismember(firearm_laws.State(ind),west_north_central)
            firearm_law_counts.restrictive_west_north_central(t_ind)=firearm_law_counts.restrictive_west_north_central(t_ind)+ismember(firearm_laws.State(ind),west_north_central);
        elseif ismember(firearm_laws.State(ind),south_atlantic)
            firearm_law_counts.restrictive_south_atlantic(t_ind)=firearm_law_counts.restrictive_south_atlantic(t_ind)+ismember(firearm_laws.State(ind),south_atlantic);
        elseif ismember(firearm_laws.State(ind),east_south_central)
            firearm_law_counts.restrictive_east_south_central(t_ind)=firearm_law_counts.restrictive_east_south_central(t_ind)+ismember(firearm_laws.State(ind),east_south_central);
        elseif ismember(firearm_laws.State(ind),west_south_central)
            firearm_law_counts.restrictive_west_south_central(t_ind)=firearm_law_counts.restrictive_west_south_central(t_ind)+ismember(firearm_laws.State(ind),west_south_central);
        elseif ismember(firearm_laws.State(ind),mountain)
            firearm_law_counts.restrictive_mountain(t_ind)=firearm_law_counts.restrictive_mountain(t_ind)+ismember(firearm_laws.State(ind),mountain);
        elseif ismember(firearm_laws.State(ind),pacific)
            firearm_law_counts.restrictive_pacific(t_ind)=firearm_law_counts.restrictive_pacific(t_ind)+ismember(firearm_laws.State(ind),pacific);
        end
    else
        % add national count
        firearm_law_counts.permissive(t_ind)=firearm_law_counts.permissive(t_ind)+1;
        % add regional counts
        if ismember(firearm_laws.State(ind),northeast)
            firearm_law_counts.permissive_northeast(t_ind)=firearm_law_counts.permissive_northeast(t_ind)+ismember(firearm_laws.State(ind),northeast);
        elseif ismember(firearm_laws.State(ind),midwest)
            firearm_law_counts.permissive_midwest(t_ind)=firearm_law_counts.permissive_midwest(t_ind)+ismember(firearm_laws.State(ind),midwest);
        elseif ismember(firearm_laws.State(ind),south)
            firearm_law_counts.permissive_south(t_ind)=firearm_law_counts.permissive_south(t_ind)+ismember(firearm_laws.State(ind),south);
        elseif ismember(firearm_laws.State(ind),west)
            firearm_law_counts.permissive_west(t_ind)=firearm_law_counts.permissive_west(t_ind)+ismember(firearm_laws.State(ind),west);
        end
        % add division counts
        if ismember(firearm_laws.State(ind),new_england)
            firearm_law_counts.permissive_new_england(t_ind)=firearm_law_counts.permissive_new_england(t_ind)+ismember(firearm_laws.State(ind),new_england);
        elseif ismember(firearm_laws.State(ind),middle_atlantic)
            firearm_law_counts.permissive_middle_atlantic(t_ind)=firearm_law_counts.permissive_middle_atlantic(t_ind)+ismember(firearm_laws.State(ind),middle_atlantic);
        elseif ismember(firearm_laws.State(ind),east_north_central)
            firearm_law_counts.permissive_east_north_central(t_ind)=firearm_law_counts.permissive_east_north_central(t_ind)+ismember(firearm_laws.State(ind),east_north_central);
        elseif ismember(firearm_laws.State(ind),west_north_central)
            firearm_law_counts.permissive_west_north_central(t_ind)=firearm_law_counts.permissive_west_north_central(t_ind)+ismember(firearm_laws.State(ind),west_north_central);
        elseif ismember(firearm_laws.State(ind),south_atlantic)
            firearm_law_counts.permissive_south_atlantic(t_ind)=firearm_law_counts.permissive_south_atlantic(t_ind)+ismember(firearm_laws.State(ind),south_atlantic);
        elseif ismember(firearm_laws.State(ind),east_south_central)
            firearm_law_counts.permissive_east_south_central(t_ind)=firearm_law_counts.permissive_east_south_central(t_ind)+ismember(firearm_laws.State(ind),east_south_central);
        elseif ismember(firearm_laws.State(ind),west_south_central)
            firearm_law_counts.permissive_west_south_central(t_ind)=firearm_law_counts.permissive_west_south_central(t_ind)+ismember(firearm_laws.State(ind),west_south_central);
        elseif ismember(firearm_laws.State(ind),mountain)
            firearm_law_counts.permissive_mountain(t_ind)=firearm_law_counts.permissive_mountain(t_ind)+ismember(firearm_laws.State(ind),mountain);
        elseif ismember(firearm_laws.State(ind),pacific)
            firearm_law_counts.permissive_pacific(t_ind)=firearm_law_counts.permissive_pacific(t_ind)+ismember(firearm_laws.State(ind),pacific);
        end
    end
end


% add the cumulative sum of each column to the table
firearm_law_counts = [firearm_law_counts array2table(cumsum(firearm_law_counts{:,3:end}),'VariableNames', [{'permissive_continuous'} {'restrictive_continuous'} ...
{'permissive_northeast_continuous'} {'restrictive_northeast_continuous'} {'permissive_midwest_continuous'} {'restrictive_midwest_continuous'} ...
{'permissive_south_continuous'} {'restrictive_south_continuous'} {'permissive_west_continuous'} {'restrictive_west_continuous'} ...
{'permissive_new_england_continuous'} {'restrictive_new_england_continuous'} {'permissive_middle_atlantic_continuous'} {'restrictive_middle_atlantic_continuous'} ...
{'permissive_east_north_central_continuous'} {'restrictive_east_north_central_continuous'} {'permissive_west_north_central_continuous'} {'restrictive_west_north_central_continuous'} ...
{'permissive_south_atlantic_continuous'} {'restrictive_south_atlantic_continuous'} {'permissive_east_south_central_continuous'} {'restrictive_east_south_central_continuous'} ...
{'permissive_west_south_central_continuous'} {'restrictive_west_south_central_continuous'} {'permissive_mountain_continuous'} {'restrictive_mountain_continuous'} ...
{'permissive_pacific_continuous'} {'restrictive_pacific_continuous'}])];


% add the ratio of each area to the table
firearm_law_counts.ratio = firearm_law_counts.restrictive_continuous./firearm_law_counts.permissive_continuous;
firearm_law_counts.northeast_ratio = firearm_law_counts.restrictive_northeast_continuous./firearm_law_counts.permissive_northeast_continuous;
firearm_law_counts.midwest_ratio = firearm_law_counts.restrictive_midwest_continuous./firearm_law_counts.permissive_midwest_continuous;
firearm_law_counts.south_ratio = firearm_law_counts.restrictive_south_continuous./firearm_law_counts.permissive_south_continuous;
firearm_law_counts.west_ratio = firearm_law_counts.restrictive_west_continuous./firearm_law_counts.permissive_west_continuous;
firearm_law_counts.new_england_ratio = firearm_law_counts.restrictive_new_england_continuous./firearm_law_counts.permissive_new_england_continuous;
firearm_law_counts.middle_atlantic_ratio = firearm_law_counts.restrictive_middle_atlantic_continuous./firearm_law_counts.permissive_middle_atlantic_continuous;
firearm_law_counts.east_north_central_ratio = firearm_law_counts.restrictive_east_north_central_continuous./firearm_law_counts.permissive_east_north_central_continuous;
firearm_law_counts.west_north_central_ratio = firearm_law_counts.restrictive_west_north_central_continuous./firearm_law_counts.permissive_west_north_central_continuous;
firearm_law_counts.south_atlantic_ratio = firearm_law_counts.restrictive_south_atlantic_continuous./firearm_law_counts.permissive_south_atlantic_continuous;
firearm_law_counts.east_south_central_ratio = firearm_law_counts.restrictive_east_south_central_continuous./firearm_law_counts.permissive_east_south_central_continuous;
firearm_law_counts.west_south_central_ratio = firearm_law_counts.restrictive_west_south_central_continuous./firearm_law_counts.permissive_west_south_central_continuous;
firearm_law_counts.mountain_ratio = firearm_law_counts.restrictive_mountain_continuous./firearm_law_counts.permissive_mountain_continuous;
firearm_law_counts.pacific_ratio = firearm_law_counts.restrictive_pacific_continuous./firearm_law_counts.permissive_pacific_continuous;

% add the sum of each area to the table
firearm_law_counts.sum = firearm_law_counts.restrictive_continuous-firearm_law_counts.permissive_continuous;
firearm_law_counts.northeast_sum = firearm_law_counts.restrictive_northeast_continuous-firearm_law_counts.permissive_northeast_continuous;
firearm_law_counts.midwest_sum = firearm_law_counts.restrictive_midwest_continuous-firearm_law_counts.permissive_midwest_continuous;
firearm_law_counts.south_sum = firearm_law_counts.restrictive_south_continuous-firearm_law_counts.permissive_south_continuous;
firearm_law_counts.west_sum = firearm_law_counts.restrictive_west_continuous-firearm_law_counts.permissive_west_continuous;
firearm_law_counts.new_england_sum = firearm_law_counts.restrictive_new_england_continuous-firearm_law_counts.permissive_new_england_continuous;
firearm_law_counts.middle_atlantic_sum = firearm_law_counts.restrictive_middle_atlantic_continuous-firearm_law_counts.permissive_middle_atlantic_continuous;
firearm_law_counts.east_north_central_sum = firearm_law_counts.restrictive_east_north_central_continuous-firearm_law_counts.permissive_east_north_central_continuous;
firearm_law_counts.west_north_central_sum = firearm_law_counts.restrictive_west_north_central_continuous-firearm_law_counts.permissive_west_north_central_continuous;
firearm_law_counts.south_atlantic_sum = firearm_law_counts.restrictive_south_atlantic_continuous-firearm_law_counts.permissive_south_atlantic_continuous;
firearm_law_counts.east_south_central_sum = firearm_law_counts.restrictive_east_south_central_continuous-firearm_law_counts.permissive_east_south_central_continuous;
firearm_law_counts.west_south_central_sum = firearm_law_counts.restrictive_west_south_central_continuous-firearm_law_counts.permissive_west_south_central_continuous;
firearm_law_counts.mountain_sum = firearm_law_counts.restrictive_mountain_continuous-firearm_law_counts.permissive_mountain_continuous;
firearm_law_counts.pacific_sum = firearm_law_counts.restrictive_pacific_continuous-firearm_law_counts.permissive_pacific_continuous;

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
firearm_law_counts = firearm_law_counts(find((firearm_law_counts.Year==2000).*(firearm_law_counts.Month==1)):find((firearm_law_counts.Year==2019).*(firearm_law_counts.Month==10)),:);

% save the processed data
writetable(firearm_law_counts,strcat(processed_datasets_directory,'firearm_law_counts.csv'));
save(strcat(processed_datasets_directory,'firearm_law_counts.mat'),'firearm_law_counts');


%% generate time series for fraction of population affected by firearm laws on a national, regional, and divisional level

firearm_law_fractions = array2table(zeros(size(years_1999_2020,2)*size(months,2),30),'VariableNames',[{'Year'} {'Month'} ...
    {'permissive'} {'restrictive'} ...
    {'permissive_northeast'} {'restrictive_northeast'} {'permissive_midwest'} {'restrictive_midwest'} ...
    {'permissive_south'} {'restrictive_south'} {'permissive_west'} {'restrictive_west'} ...
    {'permissive_new_england'} {'restrictive_new_england'} {'permissive_middle_atlantic'} {'restrictive_middle_atlantic'} ...
    {'permissive_east_north_central'} {'restrictive_east_north_central'} {'permissive_west_north_central'} {'restrictive_west_north_central'} ...
    {'permissive_south_atlantic'} {'restrictive_south_atlantic'} {'permissive_east_south_central'} {'restrictive_east_south_central'} ...
    {'permissive_west_south_central'} {'restrictive_west_south_central'} {'permissive_mountain'} {'restrictive_mountain'} ...
    {'permissive_pacific'} {'restrictive_pacific'}]);
firearm_law_fractions.Year = repelem(years_1999_2020',size(months,2),1);
firearm_law_fractions.Month = repmat(months',size(years_1999_2020,2),1);

for ind = 1:size(firearm_laws,1) % iterate through the laws
    t_ind = find((firearm_law_fractions.Year==firearm_laws.EffectiveDateYear(ind)).*(firearm_law_fractions.Month==firearm_laws.EffectiveDateMonth(ind))); % find year/month time index
    if firearm_laws.Effect(ind)==0 % if the law is restrictive
        % add national count
        f_pop_nat = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/population.USA(find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first')); % fraction of state's population out of the national population
        firearm_law_fractions.restrictive(t_ind)=firearm_law_fractions.restrictive(t_ind)+f_pop_nat;
        % add regional counts
        if ismember(firearm_laws.State(ind),northeast)
            f_pop_reg = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,northeast)}); % fraction of state's population out of the regional population
            firearm_law_fractions.restrictive_northeast(t_ind)=firearm_law_fractions.restrictive_northeast(t_ind)+f_pop_reg;
        elseif ismember(firearm_laws.State(ind),midwest)
            f_pop_reg = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,midwest)}); % fraction of state's population out of the regional population
            firearm_law_fractions.restrictive_midwest(t_ind)=firearm_law_fractions.restrictive_midwest(t_ind)+f_pop_reg;
        elseif ismember(firearm_laws.State(ind),south)
            f_pop_reg = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,south)}); % fraction of state's population out of the regional population
            firearm_law_fractions.restrictive_south(t_ind)=firearm_law_fractions.restrictive_south(t_ind)+f_pop_reg;
        elseif ismember(firearm_laws.State(ind),west)
            f_pop_reg = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,west)}); % fraction of state's population out of the regional population
            firearm_law_fractions.restrictive_west(t_ind)=firearm_law_fractions.restrictive_west(t_ind)+f_pop_reg;
        end
        % add division counts
        if ismember(firearm_laws.State(ind),new_england)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,new_england)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.restrictive_new_england(t_ind)=firearm_law_fractions.restrictive_new_england(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),middle_atlantic)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,middle_atlantic)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.restrictive_middle_atlantic(t_ind)=firearm_law_fractions.restrictive_middle_atlantic(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),east_north_central)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,east_north_central)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.restrictive_east_north_central(t_ind)=firearm_law_fractions.restrictive_east_north_central(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),west_north_central)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,west_north_central)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.restrictive_west_north_central(t_ind)=firearm_law_fractions.restrictive_west_north_central(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),south_atlantic)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,south_atlantic)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.restrictive_south_atlantic(t_ind)=firearm_law_fractions.restrictive_south_atlantic(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),east_south_central)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,east_south_central)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.restrictive_east_south_central(t_ind)=firearm_law_fractions.restrictive_east_south_central(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),west_south_central)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,west_south_central)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.restrictive_west_south_central(t_ind)=firearm_law_fractions.restrictive_west_south_central(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),mountain)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,mountain)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.restrictive_mountain(t_ind)=firearm_law_fractions.restrictive_mountain(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),pacific)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,pacific)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.restrictive_pacific(t_ind)=firearm_law_fractions.restrictive_pacific(t_ind)+f_pop_div;
        end
    else
        % add national count
        f_pop_nat = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/population.USA(find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first')); % fraction of state's population out of the national population
        firearm_law_fractions.permissive(t_ind)=firearm_law_fractions.permissive(t_ind)+f_pop_nat;
        % add regional counts
        if ismember(firearm_laws.State(ind),northeast)
            f_pop_reg = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,northeast)}); % fraction of state's population out of the regional population
            firearm_law_fractions.permissive_northeast(t_ind)=firearm_law_fractions.permissive_northeast(t_ind)+f_pop_reg;
        elseif ismember(firearm_laws.State(ind),midwest)
            f_pop_reg = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,midwest)}); % fraction of state's population out of the regional population
            firearm_law_fractions.permissive_midwest(t_ind)=firearm_law_fractions.permissive_midwest(t_ind)+f_pop_reg;
        elseif ismember(firearm_laws.State(ind),south)
            f_pop_reg = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,south)}); % fraction of state's population out of the regional population
            firearm_law_fractions.permissive_south(t_ind)=firearm_law_fractions.permissive_south(t_ind)+f_pop_reg;
        elseif ismember(firearm_laws.State(ind),west)
            f_pop_reg = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,west)}); % fraction of state's population out of the regional population
            firearm_law_fractions.permissive_west(t_ind)=firearm_law_fractions.permissive_west(t_ind)+f_pop_reg;
        end
        % add division counts
        if ismember(firearm_laws.State(ind),new_england)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,new_england)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.permissive_new_england(t_ind)=firearm_law_fractions.permissive_new_england(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),middle_atlantic)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,middle_atlantic)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.permissive_middle_atlantic(t_ind)=firearm_law_fractions.permissive_middle_atlantic(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),east_north_central)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,east_north_central)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.permissive_east_north_central(t_ind)=firearm_law_fractions.permissive_east_north_central(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),west_north_central)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,west_north_central)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.permissive_west_north_central(t_ind)=firearm_law_fractions.permissive_west_north_central(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),south_atlantic)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,south_atlantic)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.permissive_south_atlantic(t_ind)=firearm_law_fractions.permissive_south_atlantic(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),east_south_central)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,east_south_central)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.permissive_east_south_central(t_ind)=firearm_law_fractions.permissive_east_south_central(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),west_south_central)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,west_south_central)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.permissive_west_south_central(t_ind)=firearm_law_fractions.permissive_west_south_central(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),mountain)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,mountain)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.permissive_mountain(t_ind)=firearm_law_fractions.permissive_mountain(t_ind)+f_pop_div;
        elseif ismember(firearm_laws.State(ind),pacific)
            f_pop_div = population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),strcmp(population.Properties.VariableNames,firearm_laws.State(ind))}/sum(population{find(population.Year==firearm_laws.EffectiveDateYear(ind),1,'first'),ismember(population.Properties.VariableNames,pacific)}); % fraction of state's population out of the divisional population
            firearm_law_fractions.permissive_pacific(t_ind)=firearm_law_fractions.permissive_pacific(t_ind)+f_pop_div;
        end
    end
end

% add the cumulative sum of each column to the table
firearm_law_fractions = [firearm_law_fractions array2table(cumsum(firearm_law_fractions{:,3:end}),'VariableNames', [{'permissive_continuous'} {'restrictive_continuous'} ...
{'permissive_northeast_continuous'} {'restrictive_northeast_continuous'} {'permissive_midwest_continuous'} {'restrictive_midwest_continuous'} ...
{'permissive_south_continuous'} {'restrictive_south_continuous'} {'permissive_west_continuous'} {'restrictive_west_continuous'} ...
{'permissive_new_england_continuous'} {'restrictive_new_england_continuous'} {'permissive_middle_atlantic_continuous'} {'restrictive_middle_atlantic_continuous'} ...
{'permissive_east_north_central_continuous'} {'restrictive_east_north_central_continuous'} {'permissive_west_north_central_continuous'} {'restrictive_west_north_central_continuous'} ...
{'permissive_south_atlantic_continuous'} {'restrictive_south_atlantic_continuous'} {'permissive_east_south_central_continuous'} {'restrictive_east_south_central_continuous'} ...
{'permissive_west_south_central_continuous'} {'restrictive_west_south_central_continuous'} {'permissive_mountain_continuous'} {'restrictive_mountain_continuous'} ...
{'permissive_pacific_continuous'} {'restrictive_pacific_continuous'}])];

% add the ratio of each area to the table
firearm_law_fractions.ratio = firearm_law_fractions.restrictive_continuous./firearm_law_fractions.permissive_continuous;
firearm_law_fractions.northeast_ratio = firearm_law_fractions.restrictive_northeast_continuous./firearm_law_fractions.permissive_northeast_continuous;
firearm_law_fractions.midwest_ratio = firearm_law_fractions.restrictive_midwest_continuous./firearm_law_fractions.permissive_midwest_continuous;
firearm_law_fractions.south_ratio = firearm_law_fractions.restrictive_south_continuous./firearm_law_fractions.permissive_south_continuous;
firearm_law_fractions.west_ratio = firearm_law_fractions.restrictive_west_continuous./firearm_law_fractions.permissive_west_continuous;
firearm_law_fractions.new_england_ratio = firearm_law_fractions.restrictive_new_england_continuous./firearm_law_fractions.permissive_new_england_continuous;
firearm_law_fractions.middle_atlantic_ratio = firearm_law_fractions.restrictive_middle_atlantic_continuous./firearm_law_fractions.permissive_middle_atlantic_continuous;
firearm_law_fractions.east_north_central_ratio = firearm_law_fractions.restrictive_east_north_central_continuous./firearm_law_fractions.permissive_east_north_central_continuous;
firearm_law_fractions.west_north_central_ratio = firearm_law_fractions.restrictive_west_north_central_continuous./firearm_law_fractions.permissive_west_north_central_continuous;
firearm_law_fractions.south_atlantic_ratio = firearm_law_fractions.restrictive_south_atlantic_continuous./firearm_law_fractions.permissive_south_atlantic_continuous;
firearm_law_fractions.east_south_central_ratio = firearm_law_fractions.restrictive_east_south_central_continuous./firearm_law_fractions.permissive_east_south_central_continuous;
firearm_law_fractions.west_south_central_ratio = firearm_law_fractions.restrictive_west_south_central_continuous./firearm_law_fractions.permissive_west_south_central_continuous;
firearm_law_fractions.mountain_ratio = firearm_law_fractions.restrictive_mountain_continuous./firearm_law_fractions.permissive_mountain_continuous;
firearm_law_fractions.pacific_ratio = firearm_law_fractions.restrictive_pacific_continuous./firearm_law_fractions.permissive_pacific_continuous;

% add the sum of each area to the table
firearm_law_fractions.sum = firearm_law_fractions.restrictive_continuous-firearm_law_fractions.permissive_continuous;
firearm_law_fractions.northeast_sum = firearm_law_fractions.restrictive_northeast_continuous-firearm_law_fractions.permissive_northeast_continuous;
firearm_law_fractions.midwest_sum = firearm_law_fractions.restrictive_midwest_continuous-firearm_law_fractions.permissive_midwest_continuous;
firearm_law_fractions.south_sum = firearm_law_fractions.restrictive_south_continuous-firearm_law_fractions.permissive_south_continuous;
firearm_law_fractions.west_sum = firearm_law_fractions.restrictive_west_continuous-firearm_law_fractions.permissive_west_continuous;
firearm_law_fractions.new_england_sum = firearm_law_fractions.restrictive_new_england_continuous-firearm_law_fractions.permissive_new_england_continuous;
firearm_law_fractions.middle_atlantic_sum = firearm_law_fractions.restrictive_middle_atlantic_continuous-firearm_law_fractions.permissive_middle_atlantic_continuous;
firearm_law_fractions.east_north_central_sum = firearm_law_fractions.restrictive_east_north_central_continuous-firearm_law_fractions.permissive_east_north_central_continuous;
firearm_law_fractions.west_north_central_sum = firearm_law_fractions.restrictive_west_north_central_continuous-firearm_law_fractions.permissive_west_north_central_continuous;
firearm_law_fractions.south_atlantic_sum = firearm_law_fractions.restrictive_south_atlantic_continuous-firearm_law_fractions.permissive_south_atlantic_continuous;
firearm_law_fractions.east_south_central_sum = firearm_law_fractions.restrictive_east_south_central_continuous-firearm_law_fractions.permissive_east_south_central_continuous;
firearm_law_fractions.west_south_central_sum = firearm_law_fractions.restrictive_west_south_central_continuous-firearm_law_fractions.permissive_west_south_central_continuous;
firearm_law_fractions.mountain_sum = firearm_law_fractions.restrictive_mountain_continuous-firearm_law_fractions.permissive_mountain_continuous;
firearm_law_fractions.pacific_sum = firearm_law_fractions.restrictive_pacific_continuous-firearm_law_fractions.permissive_pacific_continuous;

% truncate dates for January 2000 - October 2019 for analysis with firearm ownership data
firearm_law_fractions = firearm_law_fractions(find((firearm_law_fractions.Year==2000).*(firearm_law_fractions.Month==1)):find((firearm_law_fractions.Year==2019).*(firearm_law_fractions.Month==10)),:);

% save the processed data
writetable(firearm_law_fractions,strcat(processed_datasets_directory,'firearm_law_fractions.csv'));
save(strcat(processed_datasets_directory,'firearm_law_fractions.mat'),'firearm_law_fractions');


%% process data about firearm ownership

firearm_ownership = readtable("Firearm Ownership.csv");
firearm_ownership.Properties.VariableNames = [{'Year'} {'Month'} states(~ismember(states,{'Alaska'})) {'USA'}];


%% compute firearms from firearm ownership data

firearms_fo = firearm_ownership;
firearms_fo{:,3:end} = firearms_fo{:,3:end}.*population{(find(population.Year==2000,1,'first'):find(population.Year==2000,1,'first')+size(firearms_fo,1)-1),ismember(population.Properties.VariableNames,firearms_fo.Properties.VariableNames(3:end))};
firearms_fo.northeast = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,northeast)},2);
firearms_fo.midwest = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,midwest)},2);
firearms_fo.south = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,south)},2);
firearms_fo.west = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,west)},2);
firearms_fo.new_england = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,new_england)},2);
firearms_fo.middle_atlantic = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,middle_atlantic)},2);
firearms_fo.east_north_central = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,east_north_central)},2);
firearms_fo.west_north_central = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,west_north_central)},2);
firearms_fo.south_atlantic = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,south_atlantic)},2);
firearms_fo.east_south_central = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,east_south_central)},2);
firearms_fo.west_south_central = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,west_south_central)},2);
firearms_fo.mountain = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,mountain)},2);
firearms_fo.pacific = sum(firearms_fo{:,ismember(firearms_fo.Properties.VariableNames,pacific)},2);

% save the processed data
writetable(firearms_fo,strcat(processed_datasets_directory,'firearms_fo.csv'));
save(strcat(processed_datasets_directory,'firearms_fo.mat'),'firearms_fo');


%% compute firearms from fraction of suicides with firearms data

firearms_ffs = fraction_of_firearm_suicides;
firearms_ffs{:,3:end} = firearms_ffs{:,3:end}.*population{(find(population.Year==2000,1,'first'):find(population.Year==2000,1,'first')+size(firearms_ffs,1)-1),ismember(population.Properties.VariableNames,firearms_ffs.Properties.VariableNames(3:end))};

% save the processed data
writetable(firearms_ffs,strcat(processed_datasets_directory,'firearms_ffs.csv'));
save(strcat(processed_datasets_directory,'firearms_ffs.mat'),'firearms_ffs');


%% compute violence per firearm

% deaths per background checks
deaths_per_bc = firearm_deaths;
deaths_per_bc{:,3:end} = deaths_per_bc{:,3:end}./background_checks{1:size(deaths_per_bc,1),3:end};
writetable(deaths_per_bc,strcat(processed_datasets_directory,'deaths_per_bc.csv'));
save(strcat(processed_datasets_directory,'deaths_per_bc.mat'),'deaths_per_bc');

% deaths per integrated background checks
deaths_per_int_bc = firearm_deaths;
deaths_per_int_bc{:,3:end} = deaths_per_int_bc{:,3:end}./int_background_checks{1:size(deaths_per_int_bc,1),3:end};
writetable(deaths_per_int_bc,strcat(processed_datasets_directory,'deaths_per_int_bc.csv'));
save(strcat(processed_datasets_directory,'deaths_per_int_bc.mat'),'deaths_per_int_bc');

% deaths per ffs firearms
deaths_per_ffs_firearm = firearm_deaths;
deaths_per_ffs_firearm{:,3:end} = deaths_per_ffs_firearm{:,3:end}./firearms_ffs{:,3:end};
writetable(deaths_per_ffs_firearm,strcat(processed_datasets_directory,'deaths_per_ffs_firearm.csv'));
save(strcat(processed_datasets_directory,'deaths_per_ffs_firearm.mat'),'deaths_per_ffs_firearm');

% deaths per firearms
deaths_per_firearm = firearm_deaths;
deaths_per_firearm{:,3:end} = deaths_per_firearm{:,3:end}./firearms_fo{:,3:end};
writetable(deaths_per_firearm,strcat(processed_datasets_directory,'deaths_per_firearm.csv'));
save(strcat(processed_datasets_directory,'deaths_per_firearm.mat'),'deaths_per_firearm');

% accidents per firearms
accidents_per_firearm = firearm_accidents;
accidents_per_firearm{:,3:end} = accidents_per_firearm{:,3:end}./firearms_fo{:,3:end};
writetable(accidents_per_firearm,strcat(processed_datasets_directory,'accidents_per_firearm.csv'));
save(strcat(processed_datasets_directory,'accidents_per_firearm.mat'),'accidents_per_firearm');

% homicides per firearms
homicides_per_firearm = firearm_homicides;
homicides_per_firearm{:,3:end} = homicides_per_firearm{:,3:end}./firearms_fo{:,3:end};
writetable(homicides_per_firearm,strcat(processed_datasets_directory,'homicides_per_firearm.csv'));
save(strcat(processed_datasets_directory,'homicides_per_firearm.mat'),'homicides_per_firearm');

% suicides per firearms
suicides_per_firearm = firearm_suicides;
suicides_per_firearm{:,3:end} = suicides_per_firearm{:,3:end}./firearms_fo{:,3:end};
writetable(suicides_per_firearm,strcat(processed_datasets_directory,'suicides_per_firearm.csv'));
save(strcat(processed_datasets_directory,'suicides_per_firearm.mat'),'suicides_per_firearm');



