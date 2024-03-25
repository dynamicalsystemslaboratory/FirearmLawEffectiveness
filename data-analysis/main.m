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


%% ----------------- test stationarity of time series ------------------ %%

% non-stationarity of number of firearms
[h,pv,~,~] = adftest(firearms_fo.USA); % p = 0.2523
[h,pv,~,~] = adftest(firearms_fo_sa_dt.USA); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearms_fo.midwest); % p = 0.2127
[h,pv,~,~] = adftest(firearms_fo_sa_dt.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearms_fo.northeast); % p = 0.0381
[h,pv,~,~] = adftest(firearms_fo_sa_dt.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearms_fo.south); % p = 0.3459
[h,pv,~,~] = adftest(firearms_fo_sa_dt.south); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearms_fo.west); % p = 0.2029
[h,pv,~,~] = adftest(firearms_fo_sa_dt.west); % p = 1.0000e-03

% non-stationarity of firearms deaths
[h,pv,~,~] = adftest(firearm_deaths.USA); % p = 0.5584
[h,pv,~,~] = adftest(firearm_deaths_sa_dt.USA); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_deaths.midwest); % p = 0.5024
[h,pv,~,~] = adftest(firearm_deaths_sa_dt.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_deaths.northeast); % p = 0.3490
[h,pv,~,~] = adftest(firearm_deaths_sa_dt.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_deaths.south); % p = 0.5664
[h,pv,~,~] = adftest(firearm_deaths_sa_dt.south); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_deaths.west); % p = 0.4242
[h,pv,~,~] = adftest(firearm_deaths_sa_dt.west); % p = 1.0000e-03

% non-stationarity of firearms accidents
[h,pv,~,~] = adftest(firearm_accidents.USA); % p = 0.0313
[h,pv,~,~] = adftest(firearm_accidents_sa_dt.USA); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_accidents.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_accidents_sa_dt.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_accidents.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_accidents_sa_dt.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_accidents.south); % p = 0.0067
[h,pv,~,~] = adftest(firearm_accidents_sa_dt.south); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_accidents.west); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_accidents_sa_dt.west); % p = 1.0000e-03

% non-stationarity of firearms homicides
[h,pv,~,~] = adftest(firearm_homicides.USA); % p = 0.4451
[h,pv,~,~] = adftest(firearm_homicides_sa_dt.USA); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_homicides.midwest); % p = 0.3225
[h,pv,~,~] = adftest(firearm_homicides_sa_dt.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_homicides.northeast); % p = 0.1566
[h,pv,~,~] = adftest(firearm_homicides_sa_dt.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_homicides.south); % p = 0.4433
[h,pv,~,~] = adftest(firearm_homicides_sa_dt.south); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_homicides.west); % p = 0.2535
[h,pv,~,~] = adftest(firearm_homicides_sa_dt.west); % p = 1.0000e-03

% non-stationarity of firearms suicides
[h,pv,~,~] = adftest(firearm_suicides.USA); % p = 0.5689
[h,pv,~,~] = adftest(firearm_suicides_sa_dt.USA); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_suicides.midwest); % p = 0.4781
[h,pv,~,~] = adftest(firearm_suicides_sa_dt.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_suicides.northeast); % p = 0.3557
[h,pv,~,~] = adftest(firearm_suicides_sa_dt.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_suicides.south); % p = 0.5520
[h,pv,~,~] = adftest(firearm_suicides_sa_dt.south); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_suicides.west); % p = 0.4135
[h,pv,~,~] = adftest(firearm_suicides_sa_dt.west); % p = 1.0000e-03

% non-stationarity of firearm restrcitiveness
[h,pv,~,~] = adftest(firearm_law_fractions.sum); % p = 0.9990
[h,pv,~,~] = adftest(firearm_law_fractions_sa_dt.sum); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_law_fractions.midwest_sum); % p = 0.7627
[h,pv,~,~] = adftest(firearm_law_fractions_sa_dt.midwest_sum); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_law_fractions.northeast_sum); % p = 0.9990
[h,pv,~,~] = adftest(firearm_law_fractions_sa_dt.northeast_sum); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_law_fractions.south_sum); % p = 0.8585
[h,pv,~,~] = adftest(firearm_law_fractions_sa_dt.south_sum); % p = 1.0000e-03
[h,pv,~,~] = adftest(firearm_law_fractions.west_sum); % p = 0.9990
[h,pv,~,~] = adftest(firearm_law_fractions_sa_dt.west_sum); % p = 1.0000e-03

% non-stationarity of deaths per firearm
[h,pv,~,~] = adftest(deaths_per_firearm.USA); % p = 0.0312
[h,pv,~,~] = adftest(deaths_per_firearm_sa_dt.USA); % p = 1.0000e-03
[h,pv,~,~] = adftest(deaths_per_firearm.midwest); % p = 0.0189
[h,pv,~,~] = adftest(deaths_per_firearm_sa_dt.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(deaths_per_firearm.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(deaths_per_firearm_sa_dt.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(deaths_per_firearm.south); % p = 0.1057
[h,pv,~,~] = adftest(deaths_per_firearm_sa_dt.south); % p = 1.0000e-03
[h,pv,~,~] = adftest(deaths_per_firearm.west); % p = 0.0023
[h,pv,~,~] = adftest(deaths_per_firearm_sa_dt.west); % p = 1.0000e-03

% non-stationarity of accidents per firearm
[h,pv,~,~] = adftest(accidents_per_firearm.USA); % p = 0.0041
[h,pv,~,~] = adftest(accidents_per_firearm_sa_dt.USA); % p = 1.0000e-03
[h,pv,~,~] = adftest(accidents_per_firearm.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(accidents_per_firearm_sa_dt.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(accidents_per_firearm.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(accidents_per_firearm_sa_dt.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(accidents_per_firearm.south); % p = 0.0011
[h,pv,~,~] = adftest(accidents_per_firearm_sa_dt.south); % p = 1.0000e-03
[h,pv,~,~] = adftest(accidents_per_firearm.west); % p = 1.0000e-03
[h,pv,~,~] = adftest(accidents_per_firearm_sa_dt.west); % p = 1.0000e-03

% non-stationarity of homicides per firearm
[h,pv,~,~] = adftest(homicides_per_firearm.USA); % p = 0.0359
[h,pv,~,~] = adftest(homicides_per_firearm_sa_dt.USA); % p = 1.0000e-03
[h,pv,~,~] = adftest(homicides_per_firearm.midwest); % p = 0.0160
[h,pv,~,~] = adftest(homicides_per_firearm_sa_dt.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(homicides_per_firearm.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(homicides_per_firearm_sa_dt.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(homicides_per_firearm.south); % p = 0.0919
[h,pv,~,~] = adftest(homicides_per_firearm_sa_dt.south); % p = 1.0000e-03
[h,pv,~,~] = adftest(homicides_per_firearm.west); % p = 0.0038
[h,pv,~,~] = adftest(homicides_per_firearm_sa_dt.west); % p = 1.0000e-03

% non-stationarity of suicides per firearm
[h,pv,~,~] = adftest(suicides_per_firearm.USA); % p = 0.0262
[h,pv,~,~] = adftest(suicides_per_firearm_sa_dt.USA); % p = 1.0000e-03
[h,pv,~,~] = adftest(suicides_per_firearm.midwest); % p = 0.0158
[h,pv,~,~] = adftest(suicides_per_firearm_sa_dt.midwest); % p = 1.0000e-03
[h,pv,~,~] = adftest(suicides_per_firearm.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(suicides_per_firearm_sa_dt.northeast); % p = 1.0000e-03
[h,pv,~,~] = adftest(suicides_per_firearm.south); % p = 0.1014
[h,pv,~,~] = adftest(suicides_per_firearm_sa_dt.south); % p = 1.0000e-03
[h,pv,~,~] = adftest(suicides_per_firearm.west); % p = 0.0010
[h,pv,~,~] = adftest(suicides_per_firearm_sa_dt.west); % p = 1.0000e-03



%%
%% ------------------------- plot main figures ------------------------- %%

%%      Figure 1a: time series of national firearm restrictiveness       %%

figure
hold on
bar(months_2000_2019,firearm_law_counts.restrictive+firearm_law_counts.permissive,'FaceColor',[255 0 0]/255)
bar(months_2000_2019,firearm_law_counts.permissive,'FaceColor',[0 0 255]/255)
xlabel('Time','fontweight','bold','FontSize',13)
ylabel({'Number of firearm laws'},'fontweight','bold','FontSize',13)
xlim([datetime("2000-01-01") datetime("2020-01-01")])
ylim([0 15])
legend('Restrictive','Permissive','FontSize',13,'Position',[0.19 0.72 0.1 0.2])
hold off
set(gcf,'position',[10,10,600,200])
xticklabel_fs = get(gca,'XTickLabel');
set(gca, 'XTickLabel', xticklabel_fs, 'FontName', 'Helvetica', 'fontsize', 13);
yticklabel_fs = get(gca,'YTickLabel');
set(gca, 'YTickLabel', yticklabel_fs, 'FontName', 'Helvetica', 'fontsize', 13);


%%           Figure 1b: time series of national firearm deaths           %%

figure
hold on
plot(months_2000_2019,firearm_deaths.USA,'-','Color',[0,0,0]/255,'LineWidth',0.8)
plot(months_2000_2019,firearm_suicides.USA,'-.','Color',[0,0,0]/255,'LineWidth',0.8)
plot(months_2000_2019,firearm_homicides.USA,':','Color',[0,0,0]/255,'LineWidth',0.8)
plot(months_2000_2019,firearm_accidents.USA,'--','Color',[0,0,0]/255,'LineWidth',0.8)
xlabel('Time','fontweight','bold','FontSize',13)
ylabel({'Firearm deaths by intent'},'fontweight','bold','FontSize',13)
xlim([datetime("2000-01-01") datetime("2020-01-01")])
ylim([0 5000])
legend('Deaths','Suicides','Homicides','Accidents','FontSize',12,'Position',[0.18 0.66 0.1 0.2])
hold off
set(gcf,'position',[10,10,600,200])
xticklabel_fs = get(gca,'XTickLabel');
set(gca, 'XTickLabel', xticklabel_fs, 'FontName', 'Helvetica', 'fontsize', 13);
yticklabel_fs = get(gca,'YTickLabel');
set(gca, 'YTickLabel', yticklabel_fs, 'FontName', 'Helvetica', 'fontsize', 13);


%%         Figure 1c: time series of national number of firearms         %%

figure
hold on
plot(months_2000_2019,firearms_fo.USA,'Color',[0 0 0],'LineWidth',0.8)
xlabel('Time','fontweight','bold','FontSize',13)
ylabel({'Firearm ownership (millions)'},'fontweight','bold','FontSize',13)
xlim([datetime("2000-01-01") datetime("2020-01-01")])
ylim([0 300000000])
hold off
set(gcf,'position',[10,10,600,200])
xticklabel_fs = get(gca,'XTickLabel');
set(gca, 'XTickLabel', xticklabel_fs, 'FontName', 'Helvetica', 'fontsize', 13);
yticklabel_fs = get(gca,'YTickLabel');
set(gca, 'YTickLabel', yticklabel_fs, 'FontName', 'Helvetica', 'fontsize', 13);


%%      Figure 1d: time series of national firearm restrictiveness       %%

figure
hold on
plot(months_2000_2019,firearm_law_fractions.sum,'Color',[0 0 0]/255,'LineWidth',1)
xlabel('Time','fontweight','bold','FontSize',13)
ylabel({'Firearm restrictiveness'},'fontweight','bold','FontSize',13)
xlim([datetime("2000-01-01") datetime("2020-01-01")])
ylim([0 8])
% legend('Restrictive','Permissive','Restrictive-Permissive','Position',[0.22 0.725 0.1 0.2])
hold off
set(gcf,'position',[10,10,600,200])
xticklabel_fs = get(gca,'XTickLabel');
set(gca, 'XTickLabel', xticklabel_fs, 'FontName', 'Helvetica', 'fontsize', 13);
yticklabel_fs = get(gca,'YTickLabel');
set(gca, 'YTickLabel', yticklabel_fs, 'FontName', 'Helvetica', 'fontsize', 13);


%%              Figure 1e: time series of deaths per firearm             %%

figure
hold on
plot(months_2000_2019,deaths_per_firearm.USA,'-','Color',[0 0 0],'LineWidth',0.8)
plot(months_2000_2019,suicides_per_firearm.USA,'-.','Color',[0,0,0]/255,'LineWidth',0.8)
plot(months_2000_2019,homicides_per_firearm.USA,':','Color',[0,0,0]/255,'LineWidth',0.8)
plot(months_2000_2019,accidents_per_firearm.USA,'--','Color',[0,0,0]/255,'LineWidth',0.8)
xlabel('Time','fontweight','bold','FontSize',13)
ylabel({'Deaths per firearm'},'fontweight','bold','FontSize',13)
xlim([datetime("2000-01-01") datetime("2020-01-01")])
ylim([0 0.00005])
yticks([0:0.00001:0.00005])
legend('All deaths','Suicides','Homicides','Accidents','FontSize',12,'Position',[0.18 0.66 0.1 0.2])
hold off
set(gcf,'position',[10,10,600,200])
xticklabel_fs = get(gca,'XTickLabel');
set(gca, 'XTickLabel', xticklabel_fs, 'FontName', 'Helvetica', 'fontsize', 13);
yticklabel_fs = get(gca,'YTickLabel');
set(gca, 'YTickLabel', yticklabel_fs, 'FontName', 'Helvetica', 'fontsize', 13);



%%                                                                       %%
%% --- copmute transfer entropy and partial correlations (national) ---- %%
%%                                                                       %%
%%             firearm restrictiveness -> deaths per firearm             %%

x = firearm_law_fractions_sa_dt.sum;
y = deaths_per_firearm_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-DeathsPerFirearm.csv'))



%%                              (Figure 2a)                               %%

figure
hold on
plot([1:12],results.te,'Color',[0 0 0],'LineWidth',0.8)
scatter([1:12],results.te,120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[225 225 225]/255)
scatter(find((results.sig==1)&(results.rho<0)),results.te(find((results.sig==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[230 70 70]/255)
scatter(find((results.trd==1)&(results.rho<0)),results.te(find((results.trd==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[255 200 200]/255)
scatter(find((results.sig==1)&(results.rho>0)),results.te(find((results.sig==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[70 70 230]/255)
scatter(find((results.trd==1)&(results.rho>0)),results.te(find((results.trd==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[200 200 255]/255)
xlabel('Delay (months)','fontweight','bold','FontName','Helvetica')
ylabel({'Transfer entropy (bits)'},'fontweight','bold','FontName','Helvetica')
xlim([0 13])
xticks([0:13])
ylim([0 0.04])
yticks([0:0.01:0.04])
xticklabels({'','0','1','2','3','4','5','6','7','8','9','10','11',''})
hold off
set(gcf,'position',[10,10,600,150])


%%           firearm restrictiveness -> accidents per firearm            %%

x = firearm_law_fractions_sa_dt.sum;
y = accidents_per_firearm_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-AccidentsPerFirearm.csv'))


%%                              (Figure 2b)                              %%

figure
hold on
plot([1:12],results.te,'Color',[0 0 0],'LineWidth',0.8)
scatter([1:12],results.te,120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[225 225 225]/255)
scatter(find((results.sig==1)&(results.rho<0)),results.te(find((results.sig==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[230 70 70]/255)
scatter(find((results.trd==1)&(results.rho<0)),results.te(find((results.trd==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[255 200 200]/255)
scatter(find((results.sig==1)&(results.rho>0)),results.te(find((results.sig==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[70 70 230]/255)
scatter(find((results.trd==1)&(results.rho>0)),results.te(find((results.trd==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[200 200 255]/255)
xlabel('Delay (months)','fontweight','bold','FontName','Helvetica')
ylabel({'Transfer entropy (bits)'},'fontweight','bold','FontName','Helvetica')
xlim([0 13])
xticks([0:13])
ylim([0 0.04])
yticks([0:0.01:0.04])
xticklabels({'','0','1','2','3','4','5','6','7','8','9','10','11',''})
hold off
set(gcf,'position',[10,10,600,150])


%%           firearm restrictiveness -> homicides per firearm            %%

x = firearm_law_fractions_sa_dt.sum;
y = homicides_per_firearm_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-HomicidesPerFirearm.csv'))


%%                              (Figure 2c)                              %%

figure
hold on
plot([1:12],results.te,'Color',[0 0 0],'LineWidth',0.8)
scatter([1:12],results.te,120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[225 225 225]/255)
scatter(find((results.sig==1)&(results.rho<0)),results.te(find((results.sig==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[230 70 70]/255)
scatter(find((results.trd==1)&(results.rho<0)),results.te(find((results.trd==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[255 200 200]/255)
scatter(find((results.sig==1)&(results.rho>0)),results.te(find((results.sig==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[70 70 230]/255)
scatter(find((results.trd==1)&(results.rho>0)),results.te(find((results.trd==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[200 200 255]/255)
xlabel('Delay (months)','fontweight','bold','FontName','Helvetica')
ylabel({'Transfer entropy (bits)'},'fontweight','bold','FontName','Helvetica')
xlim([0 13])
xticks([0:13])
ylim([0 0.04])
yticks([0:0.01:0.04])
xticklabels({'','0','1','2','3','4','5','6','7','8','9','10','11',''})
hold off
set(gcf,'position',[10,10,600,150])


%%           firearm restrictiveness -> suicides per firearm             %%

x = firearm_law_fractions_sa_dt.sum;
y = suicides_per_firearm_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-SuicidesPerFirearm.csv'))

%%                              (Figure 2d)                              %%

figure
hold on
plot([1:12],results.te,'Color',[0 0 0],'LineWidth',0.8)
scatter([1:12],results.te,120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[225 225 225]/255)
scatter(find((results.sig==1)&(results.rho<0)),results.te(find((results.sig==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[230 70 70]/255)
scatter(find((results.trd==1)&(results.rho<0)),results.te(find((results.trd==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[255 200 200]/255)
scatter(find((results.sig==1)&(results.rho>0)),results.te(find((results.sig==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[70 70 230]/255)
scatter(find((results.trd==1)&(results.rho>0)),results.te(find((results.trd==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[200 200 255]/255)
xlabel('Delay (months)','fontweight','bold','FontName','Helvetica')
ylabel({'Transfer entropy (bits)'},'fontweight','bold','FontName','Helvetica')
xlim([0 13])
xticks([0:13])
ylim([0 0.04])
yticks([0:0.01:0.04])
xticklabels({'','0','1','2','3','4','5','6','7','8','9','10','11',''})
hold off
set(gcf,'position',[10,10,600,150])


%%
%%             firearm restrictiveness -> firearm ownership              %%

x = firearm_law_fractions_sa_dt.sum;
y = firearms_fo_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-FirearmOwnership.csv'))

%%                              (Figure 2e)                              %%

figure
hold on
plot([1:12],results.te,'Color',[0 0 0],'LineWidth',0.8)
scatter([1:12],results.te,120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[225 225 225]/255)
scatter(find((results.sig==1)&(results.rho<0)),results.te(find((results.sig==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[230 70 70]/255)
scatter(find((results.trd==1)&(results.rho<0)),results.te(find((results.trd==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[255 200 200]/255)
scatter(find((results.sig==1)&(results.rho>0)),results.te(find((results.sig==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[70 70 230]/255)
scatter(find((results.trd==1)&(results.rho>0)),results.te(find((results.trd==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[200 200 255]/255)
xlabel('Delay (months)','fontweight','bold','FontName','Helvetica')
ylabel({'Transfer entropy (bits)'},'fontweight','bold','FontName','Helvetica')
xlim([0 13])
xticks([0:13])
ylim([0 0.04])
yticks([0:0.01:0.04])
xticklabels({'','0','1','2','3','4','5','6','7','8','9','10','11',''})
hold off
set(gcf,'position',[10,10,600,150])


%%               firearm restrictiveness -> firearm deaths               %%

x = firearm_law_fractions_sa_dt.sum;
y = firearm_deaths_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-FirearmDeaths.csv'))


%%                              (Figure 2f)                              %%

figure
hold on
plot([1:12],results.te,'Color',[0 0 0],'LineWidth',0.8)
scatter([1:12],results.te,120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[225 225 225]/255)
scatter(find((results.sig==1)&(results.rho<0)),results.te(find((results.sig==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[230 70 70]/255)
scatter(find((results.trd==1)&(results.rho<0)),results.te(find((results.trd==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[255 200 200]/255)
scatter(find((results.sig==1)&(results.rho>0)),results.te(find((results.sig==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[70 70 230]/255)
scatter(find((results.trd==1)&(results.rho>0)),results.te(find((results.trd==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[200 200 255]/255)
xlabel('Delay (months)','fontweight','bold','FontName','Helvetica')
ylabel({'Transfer entropy (bits)'},'fontweight','bold','FontName','Helvetica')
xlim([0 13])
xticks([0:13])
ylim([0 0.04])
yticks([0:0.01:0.04])
xticklabels({'','0','1','2','3','4','5','6','7','8','9','10','11',''})
hold off
set(gcf,'position',[10,10,600,150])


%%             firearm restrictiveness -> firearm accidents              %%

x = firearm_law_fractions_sa_dt.sum;
y = firearm_accidents_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-FirearmAccidents.csv'))

%%                              (Figure 2g)                              %%

figure
hold on
plot([1:12],results.te,'Color',[0 0 0],'LineWidth',0.8)
scatter([1:12],results.te,120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[225 225 225]/255)
scatter(find((results.sig==1)&(results.rho<0)),results.te(find((results.sig==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[230 70 70]/255)
scatter(find((results.trd==1)&(results.rho<0)),results.te(find((results.trd==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[255 200 200]/255)
scatter(find((results.sig==1)&(results.rho>0)),results.te(find((results.sig==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[70 70 230]/255)
scatter(find((results.trd==1)&(results.rho>0)),results.te(find((results.trd==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[200 200 255]/255)
xlabel('Delay (months)','fontweight','bold','FontName','Helvetica')
ylabel({'Transfer entropy (bits)'},'fontweight','bold','FontName','Helvetica')
xlim([0 13])
xticks([0:13])
ylim([0 0.04])
yticks([0:0.01:0.04])
xticklabels({'','0','1','2','3','4','5','6','7','8','9','10','11',''})
hold off
set(gcf,'position',[10,10,600,150])


%%             firearm restrictiveness -> firearm homicides              %%

x = firearm_law_fractions_sa_dt.sum;
y = firearm_homicides_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-FirearmHomicides.csv'))

%%                              (Figure 2h)                              %%

figure
hold on
plot([1:12],results.te,'Color',[0 0 0],'LineWidth',0.8)
scatter([1:12],results.te,120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[225 225 225]/255)
scatter(find((results.sig==1)&(results.rho<0)),results.te(find((results.sig==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[230 70 70]/255)
scatter(find((results.trd==1)&(results.rho<0)),results.te(find((results.trd==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[255 200 200]/255)
scatter(find((results.sig==1)&(results.rho>0)),results.te(find((results.sig==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[70 70 230]/255)
scatter(find((results.trd==1)&(results.rho>0)),results.te(find((results.trd==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[200 200 255]/255)
xlabel('Delay (months)','fontweight','bold','FontName','Helvetica')
ylabel({'Transfer entropy (bits)'},'fontweight','bold','FontName','Helvetica')
xlim([0 13])
xticks([0:13])
ylim([0 0.04])
yticks([0:0.01:0.04])
xticklabels({'','0','1','2','3','4','5','6','7','8','9','10','11',''})
hold off
set(gcf,'position',[10,10,600,150])


%%              firearm restrictiveness -> firearm suicides              %%

x = firearm_law_fractions_sa_dt.sum;
y = firearm_suicides_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-FirearmSuicides.csv'))


%%                              (Figure 2i)                              %%

figure
hold on
plot([1:12],results.te,'Color',[0 0 0],'LineWidth',0.8)
scatter([1:12],results.te,120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[225 225 225]/255)
scatter(find((results.sig==1)&(results.rho<0)),results.te(find((results.sig==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[230 70 70]/255)
scatter(find((results.trd==1)&(results.rho<0)),results.te(find((results.trd==1)&(results.rho<0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[255 200 200]/255)
scatter(find((results.sig==1)&(results.rho>0)),results.te(find((results.sig==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[70 70 230]/255)
scatter(find((results.trd==1)&(results.rho>0)),results.te(find((results.trd==1)&(results.rho>0))),120,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[200 200 255]/255)
xlabel('Delay (months)','fontweight','bold','FontName','Helvetica')
ylabel({'Transfer entropy (bits)'},'fontweight','bold','FontName','Helvetica')
xlim([0 13])
xticks([0:13])
ylim([0 0.04])
yticks([0:0.01:0.04])
xticklabels({'','0','1','2','3','4','5','6','7','8','9','10','11',''})
hold off
set(gcf,'position',[10,10,600,150])


%%                                                                       %%
%%        firearm restrictiveness -> deaths per background checks        %%

x = firearm_law_fractions_sa_dt.sum;
y = deaths_per_bc_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-DeathsPerBackgoundChecks.csv'))


%%  firearm restrictiveness -> deaths per integral of background checks  %%

x = firearm_law_fractions_sa_dt.sum;
y = deaths_per_int_bc_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-DeathsPerIntegralBackgoundChecks.csv'))


%%  firearm restrictiveness -> deaths per fraction of firearm suicides   %%

x = firearm_law_fractions_sa_dt.sum;
y = deaths_per_ffs_firearm_sa_dt.USA;

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
writetable(results,strcat(results_directory,'/National_Restrictiveness-DeathsPerFractionFirearmSuicides.csv'))

%%                                                                       %%
%% --- copmute transfer entropy and partial correlations (regional) ---- %%
%%                                                                       %%
%%             firearm restrictiveness -> deaths per firearm             %%

d = find(readtable(strcat(results_directory,'national_deaths-per-firearm.csv')).te==max(readtable(strcat(results_directory,'national_deaths-per-firearm.csv')).te))-1;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(4,5),'VariableNames',[{'te'} {'p_value'} {'sig'} {'trd'} {'rho'}],'RowNames',[{'Midest'} {'Northeast'} {'South'} {'West'}]);

% midwest
x = firearm_law_fractions_sa_dt.midwest_sum;
y = deaths_per_firearm_sa_dt.midwest;

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
x = firearm_law_fractions_sa_dt.northeast_sum;
y = deaths_per_firearm_sa_dt.northeast;

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
x = firearm_law_fractions_sa_dt.south_sum;
y = deaths_per_firearm_sa_dt.south;

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
x = firearm_law_fractions_sa_dt.west_sum;
y = deaths_per_firearm_sa_dt.west;

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

writetable(results,strcat(results_directory,'/Regional_Restrictiveness-DeathsPerFirearm.csv'))


%%                                                                       %%
%%             firearm restrictiveness -> firearm ownership              %%

d = find(readtable(strcat(results_directory,'national_firearm-ownership.csv')).te==max(readtable(strcat(results_directory,'national_firearm-ownership.csv')).te))-1;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(4,5),'VariableNames',[{'te'} {'p_value'} {'sig'} {'trd'} {'rho'}],'RowNames',[{'Midest'} {'Northeast'} {'South'} {'West'}]);

% midwest
x = firearm_law_fractions_sa_dt.midwest_sum;
y = firearms_fo_sa_dt.midwest;

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
x = firearm_law_fractions_sa_dt.northeast_sum;
y = firearms_fo_sa_dt.northeast;

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
x = firearm_law_fractions_sa_dt.south_sum;
y = firearms_fo_sa_dt.south;

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
x = firearm_law_fractions_sa_dt.west_sum;
y = firearms_fo_sa_dt.west;

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

writetable(results,strcat(results_directory,'/Regional_Restrictiveness-FirearmOwnership.csv'))


%%                                                                       %%
%%              firearm restrictiveness -> firearm suicides              %%

d = find(readtable(strcat(results_directory,'national_firearm-suicides.csv')).te==max(readtable(strcat(results_directory,'national_firearm-suicides.csv')).te))-1;

% create empty table to hold partial correlation and transfer entropy results
results=array2table(nan(4,5),'VariableNames',[{'te'} {'p_value'} {'sig'} {'trd'} {'rho'}],'RowNames',[{'Midest'} {'Northeast'} {'South'} {'West'}]);

% midwest
x = firearm_law_fractions_sa_dt.midwest_sum;
y = firearm_suicides_sa_dt.midwest;

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
x = firearm_law_fractions_sa_dt.northeast_sum;
y = firearm_suicides_sa_dt.northeast;

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
x = firearm_law_fractions_sa_dt.south_sum;
y = firearm_suicides_sa_dt.south;

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
x = firearm_law_fractions_sa_dt.west_sum;
y = firearm_suicides_sa_dt.west;

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

writetable(results,strcat(results_directory,'/Regional_Restrictiveness-FirearmSuicides.csv'))


%%                                                                       %%
%% --------------------- plot supplementary figures -------------------- %%
%%                                                                       %%
%%           Figure S1a: time series of regional firearm laws            %%

figure
hold on
bar(months_2000_2019,firearm_law_counts.permissive_midwest+firearm_law_counts.restrictive_midwest+firearm_law_counts.permissive_northeast+firearm_law_counts.restrictive_northeast+firearm_law_counts.permissive_south+firearm_law_counts.restrictive_south+firearm_law_counts.permissive_west+firearm_law_counts.restrictive_west,'FaceColor',[110 180 230]/255)
bar(months_2000_2019,firearm_law_counts.permissive_northeast+firearm_law_counts.restrictive_northeast+firearm_law_counts.permissive_south+firearm_law_counts.restrictive_south+firearm_law_counts.permissive_west+firearm_law_counts.restrictive_west,'FaceColor',[50 115 175]/255)
bar(months_2000_2019,firearm_law_counts.permissive_south+firearm_law_counts.restrictive_south+firearm_law_counts.permissive_west+firearm_law_counts.restrictive_west,'FaceColor',[220 160 55]/255)
bar(months_2000_2019,firearm_law_counts.permissive_west+firearm_law_counts.restrictive_west,'FaceColor',[60 140 105]/255)
xlabel('Time','fontweight','bold')
ylabel({'Number of firearm laws'},'fontweight','bold')
xlim([datetime("2000-01-01") datetime("2020-01-01")])
% ylim([0 14])
legend('Midwest','Northeast','South','West','Position',[0.18 0.7 0.1 0.2])
hold off
set(gcf,'position',[10,10,600,200])



%%           Figure S1b: time series of regional firearm deaths          %%

figure
hold on
plot(months_2000_2019,firearm_deaths.midwest,'Color',[110 180 230]/255,'LineWidth',1)
plot(months_2000_2019,firearm_deaths.northeast,'Color',[50 115 175]/255,'LineWidth',1)
plot(months_2000_2019,firearm_deaths.south,'Color',[220 160 55]/255,'LineWidth',1)
plot(months_2000_2019,firearm_deaths.west,'Color',[60 140 105]/255,'LineWidth',1)
xlabel('Time','fontweight','bold')
ylabel({'Firearm deaths'},'fontweight','bold')
xlim([datetime("2000-01-01") datetime("2020-01-01")])
ylim([0 2000])
legend('Midwest','Northeast','South','West','Position',[0.18 0.7 0.1 0.2])
hold off
set(gcf,'position',[10,10,600,200])


%%         Figure S1c: time series of regional firearm ownership         %%

figure
hold on
plot(months_2000_2019,firearms_fo.midwest,'Color',[110 180 230]/255,'LineWidth',1)
plot(months_2000_2019,firearms_fo.northeast,'Color',[50 115 175]/255,'LineWidth',1)
plot(months_2000_2019,firearms_fo.south,'Color',[220 160 55]/255,'LineWidth',1)
plot(months_2000_2019,firearms_fo.west,'Color',[60 140 105]/255,'LineWidth',1)
xlabel('Time','fontweight','bold')
ylabel({'Firearm ownership'},'fontweight','bold')
xlim([datetime("2000-01-01") datetime("2020-01-01")])
ylim([0 120000000])
legend('Midwest','Northeast','South','West','Position',[0.18 0.7 0.1 0.2])
hold off
set(gcf,'position',[10,10,600,200])


%%      Figure S2a: time series of regional firearm restrictiveness      %%

figure
hold on
plot(months_2000_2019,firearm_law_fractions.midwest_sum,'Color',[110 180 230]/255,'LineWidth',1)
plot(months_2000_2019,firearm_law_fractions.northeast_sum,'Color',[50 115 175]/255,'LineWidth',1)
plot(months_2000_2019,firearm_law_fractions.south_sum,'Color',[220 160 55]/255,'LineWidth',1)
plot(months_2000_2019,firearm_law_fractions.west_sum,'Color',[60 140 105]/255,'LineWidth',1)
xlabel('Time','fontweight','bold')
ylabel({'Firearm restrictiveness'},'fontweight','bold')
xlim([datetime("2000-01-01") datetime("2020-01-01")])
% ylim([-3 18])
legend('Midwest','Northeast','South','West','Position',[0.18 0.7 0.1 0.2])
hold off
set(gcf,'position',[10,10,600,200])

%%         Figure S2b: time series of regional deaths per firearm        %%

figure
hold on
plot(months_2000_2019,deaths_per_firearm.midwest,'Color',[110 180 230]/255,'LineWidth',1)
plot(months_2000_2019,deaths_per_firearm.northeast,'Color',[50 115 175]/255,'LineWidth',1)
plot(months_2000_2019,deaths_per_firearm.south,'Color',[220 160 55]/255,'LineWidth',1)
plot(months_2000_2019,deaths_per_firearm.west,'Color',[60 140 105]/255,'LineWidth',1)
xlabel('Time','fontweight','bold')
ylabel({'Deaths per firearm'},'fontweight','bold')
xlim([datetime("2000-01-01") datetime("2020-01-01")])
% ylim([-3 18])
legend('Midwest','Northeast','South','West','Position',[0.18 0.7 0.1 0.2])
hold off
set(gcf,'position',[10,10,600,200])

%%         Figure S3a: time series of national number of firerams        %%

figure
hold on
plot(months_2000_2019,firearms_fo.USA,'Color',[0 0 0],'LineWidth',0.8)
xlabel('Time','fontweight','bold')
ylabel({'Number of firearms'},'fontweight','bold')
xlim([datetime("2000-01-01") datetime("2020-01-01")])
ylim([0 300000000])
hold off
set(gcf,'position',[10,10,600,200])


%%         Figure S3b: time series of national background checks         %%
figure
hold on
plot(months_2000_2019,background_checks.USA,'Color',[0 0 0],'LineWidth',0.8)
xlabel('Time','fontweight','bold')
ylabel({'Background checks'},'fontweight','bold')
xlim([datetime("2000-01-01") datetime("2020-01-01")])
% ylim([0 8])
hold off
set(gcf,'position',[10,10,600,200])

%%    Figure S3c: time series of national integrated background checks   %%

figure
hold on
plot(months_2000_2019,int_background_checks.USA,'Color',[0 0 0],'LineWidth',0.8)
xlabel('Time','fontweight','bold')
ylabel({'Integral of background checks'},'fontweight','bold')
xlim([datetime("2000-01-01") datetime("2020-01-01")])
% ylim([0 8])
hold off
set(gcf,'position',[10,10,600,200])

%%    Figure S3d: time series of national number of firerams from ffs    %%

figure
hold on
plot(months_2000_2019,firearms_ffs.USA,'Color',[0 0 0],'LineWidth',0.8)
xlabel('Time','fontweight','bold')
ylabel({'Number of firearms from';'fraction of firearm suicides'},'fontweight','bold')
xlim([datetime("2000-01-01") datetime("2020-01-01")])
ylim([100000000 200000000])
hold off
set(gcf,'position',[10,10,600,200])

%%                                                                       %%
%%                                                                       %%