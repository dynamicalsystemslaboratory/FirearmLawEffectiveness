  clc; clear;

% define directories
main_dir = fileparts(matlab.desktop.editor.getActiveFilename); % record directory to the one containing this m-file
datasets_directory = strcat(main_dir,'/processed-data/'); % folder with datasets
results_directory = strcat(main_dir,'/results/'); % folder with datasets
cd(datasets_directory);

% load datasets
cd(datasets_directory); % note that Hawaii is excluded from the data sets because there is no BC for this state
load('accidents_per_firearm.mat')
load('accidents_per_firearm_sa_dt.mat')
load('background_checks.mat');
load('background_checks_sa_dt.mat');
load('deaths_per_bc.mat');
load('deaths_per_bc_sa_dt.mat');
load('deaths_per_ffs_firearm.mat');
load('deaths_per_ffs_firearm_sa_dt.mat');
load('deaths_per_firearm.mat');
load('deaths_per_firearm_sa_dt.mat');
load('deaths_per_int_bc.mat');
load('deaths_per_int_bc_sa_dt.mat');
load('firearm_accidents.mat');
load('firearm_accidents_sa_dt.mat');
load('firearm_deaths.mat');
load('firearm_deaths_sa_dt.mat');
load('firearm_homicides.mat');
load('firearm_homicides_sa_dt.mat');
load('firearm_law_counts.mat');
load('firearm_law_counts_sa_dt.mat');
load('firearm_law_fractions.mat');
load('firearm_law_fractions_sa_dt.mat');
load('firearm_suicides.mat');
load('firearm_suicides_sa_dt.mat');
load('firearms_ffs.mat');
load('firearms_ffs_sa_dt.mat');
load('firearms_fo.mat');
load('firearms_fo_sa_dt.mat');
load('fraction_of_firearm_suicides.mat');
load('fraction_of_firearm_suicides_sa_dt.mat');
load('homicides_per_firearm.mat');
load('homicides_per_firearm_sa_dt.mat');
load('int_background_checks.mat');
load('int_background_checks_sa_dt.mat');
load('suicides_per_firearm.mat');
load('suicides_per_firearm_sa_dt.mat');
cd(main_dir);

% initialize variables
states=[{'Alabama'} {'Alaska'} {'Arizona'} {'Arkansas'} {'California'} {'Colorado'} {'Connecticut'} ...
    {'Delaware'} {'Florida'} {'Georgia'} {'Idaho'} {'Illinois'} {'Indiana'} {'Iowa'} ... 
    {'Kansas'} {'Kentucky'} {'Louisiana'} {'Maine'} {'Maryland'} {'Massachusetts'} {'Michigan'} ... 
    {'Minnesota'} {'Mississippi'} {'Missouri'} {'Montana'} {'Nebraska'} {'Nevada'} {'New Hampshire'} ...
    {'New Jersey'} {'New Mexico'} {'New York'} {'North Carolina'} {'North Dakota'} {'Ohio'} {'Oklahoma'} ...
    {'Oregon'} {'Pennsylvania'} {'Rhode Island'} {'South Carolina'} {'South Dakota'} {'Tennessee'} {'Texas'} ...
    {'Utah'} {'Vermont'} {'Virginia'} {'Washington'} {'West Virginia'} {'Wisconsin'} {'Wyoming'}];

regions = [{'Northeast'} {'Midwest'} {'South'} {'West'}];
northeast = [{'Connecticut'} {'Maine'} {'Massachusetts'} {'New Hampshire'} {'Rhode Island'} {'Vermont'} {'New Jersey'} {'New York'} {'Pennsylvania'}];
midwest = [{'Indiana'} {'Illinois'} {'Michigan'} {'Ohio'} {'Wisconsin'} {'Iowa'} {'Kansas'} {'Minnesota'} {'Missouri'} {'Nebraska'} {'North Dakota'} {'South Dakota'}];
south = [{'Delaware'} {'Florida'} {'Georgia'} {'Maryland'} {'North Carolina'} {'South Carolina'} {'Virginia'} {'West Virginia'} {'Alabama'} {'Kentucky'} {'Mississippi'} {'Tennessee'} {'Arkansas'} {'Louisiana'} {'Oklahoma'} {'Texas'}];
west = [{'Arizona'} {'Colorado'} {'Idaho'} {'New Mexico'} {'Montana'} {'Utah'} {'Nevada'} {'Wyoming'} {'Alaska'} {'California'} {'Hawaii'} {'Oregon'} {'Washington'}];

divisions =  [{'New England'} {'Middle Atlantic'} {'East North Central'} {'West North Central'} {'South Atlantic'} {'East South Central'} {'West South Central'} {'Mountain'} {'Pacific'}];
new_england = [{'Connecticut'} {'Maine'} {'Massachusetts'} {'New Hampshire'} {'Rhode Island'} {'Vermont'}];
middle_atlantic = [{'New Jersey'} {'New York'} {'Pennsylvania'}];
east_north_central = [{'Indiana'} {'Illinois'} {'Michigan'} {'Ohio'} {'Wisconsin'}];
west_north_central = [{'Iowa'} {'Kansas'} {'Minnesota'} {'Missouri'} {'Nebraska'} {'North Dakota'} {'South Dakota'}];
south_atlantic = [{'Delaware'} {'Florida'} {'Georgia'} {'Maryland'} {'North Carolina'} {'South Carolina'} {'Virginia'} {'West Virginia'}];
east_south_central = [{'Alabama'} {'Kentucky'} {'Mississippi'} {'Tennessee'}];
west_south_central = [{'Arkansas'} {'Louisiana'} {'Oklahoma'} {'Texas'}];
mountain = [{'Arizona'} {'Colorado'} {'Idaho'} {'New Mexico'} {'Montana'} {'Utah'} {'Nevada'} {'Wyoming'}];
pacific = [{'Alaska'} {'California'} {'Hawaii'} {'Oregon'} {'Washington'}];

fips=[{'01'} {'02'} {'04'} {'05'} {'06'} {'08'} {'09'} ...
    {'10'} {'12'} {'13'} {'16'} {'17'} {'18'} {'19'} ... 
    {'20'} {'21'} {'22'} {'23'} {'24'} {'25'} {'26'} ... 
    {'27'} {'28'} {'29'} {'30'} {'31'} {'32'} {'33'} ...
    {'34'} {'35'} {'36'} {'37'} {'38'} {'39'} {'40'} ...
    {'41'} {'42'} {'44'} {'45'} {'46'} {'47'} {'48'} ...
    {'49'} {'50'} {'51'} {'53'} {'54'} {'55'} {'56'}];

restrictive_states=[{'California'} {'Connecticut'} {'Illinois'} {'Maryland'} {'Massachusetts'} ... 
    {'New Jersey'} {'New York'} {'Rhode Island'}];

permissive_states=[{'Alabama'} {'Alaska'} {'Arizona'} {'Arkansas'} {'Colorado'} ...
    {'Delaware'} {'Florida'} {'Georgia'} {'Idaho'} {'Indiana'} {'Iowa'} {'Kansas'} ...
    {'Kentucky'} {'Louisiana'} {'Maine'} {'Michigan'} {'Minnesota'} {'Mississippi'} ... 
    {'Missouri'} {'Montana'} {'Nebraska'} {'Nevada'} {'New Hampshire'} {'New Mexico'} ...
    {'North Carolina'} {'North Dakota'} {'Ohio'} {'Oklahoma'} {'Oregon'} {'Pennsylvania'} ...
    {'South Carolina'} {'South Dakota'} {'Tennessee'} {'Texas'} {'Utah'} {'Vermont'} ... 
    {'Virginia'} {'Washington'} {'West Virginia'} {'Wisconsin'} {'Wyoming'}];

months=[1:12];
months_2000_2019 = datetime(2000,1,1):calmonths(1):datetime(2019,10,31);
years_2000_2019=[2000:2019];

num_iterations = 50000;

%%             deaths per firearm -> firearm restrictiveness             %%

x = deaths_per_firearm_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_DeathsPerFirearm-Restrictiveness.csv'))


%%           accidents per firearm -> firearm restrictiveness            %%

x = accidents_per_firearm_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_AccidentsPerFirearm-Restrictiveness.csv'))


%%           homicides per firearm -> firearm restrictiveness            %%

x = homicides_per_firearm_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_HomicidesPerFirearm-Restrictiveness.csv'))


%%           suicides per firearm -> firearm restrictiveness             %%

x = suicides_per_firearm_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_SuicidesPerFirearm-Restrictiveness.csv'))

%%             firearm ownership -> firearm restrictiveness              %%

x = firearms_fo_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_FirearmOwnership-Restrictiveness.csv'))

%%               firearm deaths -> firearm restrictiveness               %%

x = firearm_deaths_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_FirearmDeaths-Restrictiveness.csv'))


%%             firearm restrictiveness -> firearm accidents              %%

x = firearm_accidents_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_FirearmAccidents-Restrictiveness.csv'))


%%             firearm homicides -> firearm restrictiveness              %%

x = firearm_homicides_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_FirearmHomicides-Restrictiveness.csv'))


%%              firearm suicides -> firearm restrictiveness              %%

x = firearm_suicides_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_FirearmSuicides-Restrictiveness.csv'))



%%        deaths per background checks -> firearm restrictiveness        %%

x = deaths_per_bc_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_DeathsPerBackgoundChecks-Restrictiveness.csv'))


%%  deaths per integral of background checks -> firearm restrictiveness  %%

x = deaths_per_int_bc_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_DeathsPerIntegralBackgoundChecks-Restrictiveness.csv'))


%%  deaths per fraction of firearm suicides -> firearm restrictiveness   %%

x = deaths_per_ffs_firearm_sa_dt.USA;
y = firearm_law_fractions_sa_dt.sum;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(12,8),'VariableNames',[{'delay'} {'te'} {'p_value'} {'sig'} {'trd'} {'FDR_sig'} {'FDR_trd'} {'rho'}]);
results.delay = [0:11]';

% compute partial correlations
disp("-----------Partial Correlations-----------")
for d = 1:12
    [r] = partialcorr([x(1:end-d) y(1+d:end)],y(1:end-d),'Type','Spearman');
    results.rho(d) = r(2,1);
    disp(strcat("delay: ",string(d)," months; partial correlation: ",string(round(r(2,1),2))))
end

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropies
disp("------------Transfer Entropies------------")
for d = 0:11
    x = x(1:end-d);
    y = y(1+d:end);
    [TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);
    results.te(d+1) = TE;
    results.p_value(d+1) = PV;
    if PV<=0.05
        results.sig(d+1) = 1;
        results.trd(d+1) = 0;
    elseif PV<=0.1
        results.sig(d+1) = 0;
        results.trd(d+1) = 1;
    else
        results.sig(d+1) = 0;
        results.trd(d+1) = 0;
    end
    disp(strcat("delay: ",string(d)," months; transfer entropy: ",string(round(TE,3))," (",string(round(PV,3)),")"))
end

% determine significance and trends using False Discovery Rate
results = correct_pvals(results);

% save statistics
writetable(results,strcat(results_directory,'/National_DeathsPerFractionFirearmSuicides-Restrictiveness.csv'))

%%                                                                       %%
%% --- copmute transfer entropy and partial correlations (regional) ---- %%
%%                                                                       %%
%%             firearm restrictiveness -> deaths per firearm             %%

d = find(readtable(strcat(results_directory,'National_DeathsPerFirearm-Restrictiveness.csv')).te==max(readtable(strcat(results_directory,'National_DeathsPerFirearm-Restrictiveness.csv')).te))-1;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(4,5),'VariableNames',[{'te'} {'p_value'} {'sig'} {'trd'} {'rho'}],'RowNames',[{'Midest'} {'Northeast'} {'South'} {'West'}]);

% midwest
x = deaths_per_firearm_sa_dt.midwest;
y = firearm_law_fractions_sa_dt.midwest_sum;

[r] = partialcorr([x(1:end-(d+1)) y(1+(d+1):end)],y(1:end-(d+1)),'Type','Spearman');
results.rho(1) = r(2,1);

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropy
x = x(1:end-d);
y = y(1+d:end);
[TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);

% enter statistics to results table
results.te(1) = TE;
results.p_value(1) = PV;
results.sig(1) = PV<0.05;
results.trd(1) = (PV>0.05)&(PV<0.1);


% northeast
x = deaths_per_firearm_sa_dt.northeast;
y = firearm_law_fractions_sa_dt.northeast_sum;

[r] = partialcorr([x(1:end-(d+1)) y(1+(d+1):end)],y(1:end-(d+1)),'Type','Spearman');
results.rho(2) = r(2,1);

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropy
x = x(1:end-d);
y = y(1+d:end);
[TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);

% enter statistics to results table
results.te(2) = TE;
results.p_value(2) = PV;
results.sig(2) = PV<0.05;
results.trd(2) = (PV>0.05)&(PV<0.1);


% south
x = deaths_per_firearm_sa_dt.south;
y = firearm_law_fractions_sa_dt.south_sum;

[r] = partialcorr([x(1:end-(d+1)) y(1+(d+1):end)],y(1:end-(d+1)),'Type','Spearman');
results.rho(3) = r(2,1);

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropy
x = x(1:end-d);
y = y(1+d:end);
[TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);

% enter statistics to results table
results.te(3) = TE;
results.p_value(3) = PV;
results.sig(3) = PV<0.05;
results.trd(3) = (PV>0.05)&(PV<0.1);


% west
x = deaths_per_firearm_sa_dt.west;
y = firearm_law_fractions_sa_dt.west_sum;

[r] = partialcorr([x(1:end-(d+1)) y(1+(d+1):end)],y(1:end-(d+1)),'Type','Spearman');
results.rho(4) = r(2,1);

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropy
x = x(1:end-d);
y = y(1+d:end);
[TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);

% enter statistics to results table
results.te(4) = TE;
results.p_value(4) = PV;
results.sig(4) = PV<0.05;
results.trd(4) = (PV>0.05)&(PV<0.1);

writetable(results,strcat(results_directory,'/Regional_DeathsPerFirearm-Restrictiveness.csv'))


%%                                                                       %%
%%             firearm restrictiveness -> firearm ownership              %%

d = find(readtable(strcat(results_directory,'National_FirearmOwnership-Restrictiveness.csv')).te==max(readtable(strcat(results_directory,'National_FirearmOwnership-Restrictiveness.csv')).te))-1;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(4,5),'VariableNames',[{'te'} {'p_value'} {'sig'} {'trd'} {'rho'}],'RowNames',[{'Midest'} {'Northeast'} {'South'} {'West'}]);

% midwest
x = firearms_fo_sa_dt.midwest;
y = firearm_law_fractions_sa_dt.midwest_sum;

[r] = partialcorr([x(1:end-(d+1)) y(1+(d+1):end)],y(1:end-(d+1)),'Type','Spearman');
results.rho(1) = r(2,1);

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropy
x = x(1:end-d);
y = y(1+d:end);
[TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);

% enter statistics to results table
results.te(1) = TE;
results.p_value(1) = PV;
results.sig(1) = PV<0.05;
results.trd(1) = (PV>0.05)&(PV<0.1);


% northeast
x = firearms_fo_sa_dt.northeast;
y = firearm_law_fractions_sa_dt.northeast_sum;

[r] = partialcorr([x(1:end-(d+1)) y(1+(d+1):end)],y(1:end-(d+1)),'Type','Spearman');
results.rho(2) = r(2,1);

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropy
x = x(1:end-d);
y = y(1+d:end);
[TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);

% enter statistics to results table
results.te(2) = TE;
results.p_value(2) = PV;
results.sig(2) = PV<0.05;
results.trd(2) = (PV>0.05)&(PV<0.1);


% south
x = firearms_fo_sa_dt.south;
y = firearm_law_fractions_sa_dt.south_sum;

[r] = partialcorr([x(1:end-(d+1)) y(1+(d+1):end)],y(1:end-(d+1)),'Type','Spearman');
results.rho(3) = r(2,1);

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropy
x = x(1:end-d);
y = y(1+d:end);
[TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);

% enter statistics to results table
results.te(3) = TE;
results.p_value(3) = PV;
results.sig(3) = PV<0.05;
results.trd(3) = (PV>0.05)&(PV<0.1);


% west
x = firearms_fo_sa_dt.west;
y = firearm_law_fractions_sa_dt.west_sum;

[r] = partialcorr([x(1:end-(d+1)) y(1+(d+1):end)],y(1:end-(d+1)),'Type','Spearman');
results.rho(4) = r(2,1);

% symbolize time series
x = x>median(x);
y = y>median(y);

% compute transfer entropy
x = x(1:end-d);
y = y(1+d:end);
[TE,SD,P,PV] = compute_transfer_entropy(x,y,num_iterations);

% enter statistics to results table
results.te(4) = TE;
results.p_value(4) = PV;
results.sig(4) = PV<0.05;
results.trd(4) = (PV>0.05)&(PV<0.1);

writetable(results,strcat(results_directory,'/Regional_FirearmOwnership-Restrictiveness.csv'))


