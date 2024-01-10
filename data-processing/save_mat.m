
% define directories
cd(fileparts(matlab.desktop.editor.getActiveFilename)) % change directory to the one containing this m-file
current_dir = pwd;
processed_datasets_directory = strcat(current_dir,'/processed-data/')
cd(processed_datasets_directory);

processed_files_directory = dir();
for d = 1:size(processed_files_directory)
    
    if contains(processed_files_directory(d).name,'_sa_dt.csv') % if file is seasonally-adjusted csv
        f_name = processed_files_directory(d).name(1:end-4); % fetch file name
        f = readtable(processed_files_directory(d).name); % read file
        if ismember('Var1',f.Properties.VariableNames)
            f.Var1=[]; % remove Var1 column
        end
        writetable(f,strcat(f_name,'.csv')); % save csv file without Var1 column
        eval([f_name '=f;'])
        save(strcat(f_name,'.mat'),f_name); % save csv file without Var1 column 
    end

end

