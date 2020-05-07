% edited CLC 20180427
function ParseInternodeDesignations(directory,cond)
%     type = input('Enter ctrl OR cupr\n','s');
    directory = fullfile(directory, cond);
    addpath(genpath(directory));
    contents = dir(directory);
    contents(1:2) = [];
    dirFlags = [contents.isdir];
    folders = contents(dirFlags);
    for f = 1:length(folders)
        anFolder = fullfile(directory, folders(f).name);
        anContents = dir(anFolder);
        for j = 3:length(anContents)
            regName = anContents(j).name;
            regFolder = fullfile(anFolder, regName);
            regContents = dir(regFolder);
            regTraceFiles = regContents(contains({regContents.name},'.traces'));
            for k = 1:length(regTraceFiles)
                fldr = {regTraceFiles.folder};
                regs = {regTraceFiles.name};
                varname = matlab.lang.makeValidName(regs{k});
                if exist(fullfile(fldr{1},[varname '.mat']),'file') == 2 
                    load(fullfile(fldr{1},[varname '.mat']));
                else
                    tracesFile = fullfile(fldr{1},regs{k});
                    xmlstruct = parseXML(tracesFile);
                    save(fullfile(fldr{1},[varname '.mat']),'xmlstruct');
                end
                if contains(cond,'ctrl')
                    [SheathData, Data] = parseRemyelinatingSheaths_ctrl_v3(xmlstruct);
                elseif contains(cond,'cupr')
                    [SheathData, Data] = parseRemyelinatingSheaths_cupr_v3(xmlstruct);
                end
                save(fullfile(fldr{1},[regName '_' 'ROI' '_' num2str(k) '_SheathData' '.mat']),'SheathData');
                save(fullfile(fldr{1},[regName '_' 'ROI' '_' num2str(k) '_Data' '.mat']),'Data');
            end
        end
    end
end