% edited CLC 20180427
function compiledIntData = compileROIs_ver2(type,slash)
%     type = input('Enter ctrl OR cupr\n','s');
    directory = ['.' slash 'InternodeAnalysis_Round2' slash type slash];
    addpath(genpath(directory));
    contents = dir(directory);
    contents(1:2) = [];
    dirFlags = [contents.isdir];
    folders = contents(dirFlags);
    compiledIntData = struct;
    for f = 1:length(folders)
        anFolder = fullfile(directory, folders(f).name);
        anName = strsplit(anFolder,slash);
        anName = anName{end};
        compiledIntData.(anName) = struct;
        anContents = dir(anFolder);
        for j = 3:length(anContents)
            regName = anContents(j).name;
            regFolder = fullfile(anFolder, regName);
            regContents = dir(regFolder);
            regMatFiles = regContents(contains({regContents.name},'_Data.mat'));
            fldr = {regMatFiles.folder};
            rois = {regMatFiles.name};
            load(fullfile(fldr{1},rois{1}));
            Data1 = Data;
            load(fullfile(fldr{1},rois{2}));
            Data2 = Data;
            compiledIntData.(anName).(regName) = Data;
            clear Data
            desig = fieldnames(Data1);
            for i = 1:length(desig)
                if isstruct(Data1.(desig{i}))
                    ints = fieldnames(Data1.(desig{i}));
                    for k = 1:length(ints)
                        if istable(compiledIntData.(anName).(regName).(desig{i}).(ints{k}))
                            continue
                        end
                        compiledIntData.(anName).(regName).(desig{i}).(ints{k})...
                            = Data1.(desig{i}).(ints{k}) + Data2.(desig{i}).(ints{k});
                    end
                else
                    compiledIntData.(anName).(regName).(desig{i}) = Data1.(desig{i}) + Data2.(desig{i});
                end
            end
        end
        reg = fieldnames(compiledIntData.(anName));
        for m = 1:length(desig)
            if isstruct(compiledIntData.(anName).(reg{1}).(desig{m}))
                for n = 1:length(ints)
                    if length(reg) < 2
                        compiledIntData.(anName).mean.(desig{m}).(ints{n}) = compiledIntData.(anName).(reg{1}).(desig{m}).(ints{n});
                        continue
                    end
                    compiledIntData.(anName).mean.(desig{m}).(ints{n}) = (compiledIntData.(anName).(reg{1}).(desig{m}).(ints{n})...
                        + compiledIntData.(anName).(reg{2}).(desig{m}).(ints{n}))./2;
                end
            else
                if length(reg) < 2
                        compiledIntData.(anName).mean.(desig{m}) = compiledIntData.(anName).(reg{1}).(desig{m});
                        continue
                end
                compiledIntData.(anName).mean.(desig{m}) = (compiledIntData.(anName).(reg{1}).(desig{m})...
                    + compiledIntData.(anName).(reg{2}).(desig{m}))./2;
            end
        end
    end
    compiledIntData.condMean = Data1;
    for m = 1:length(desig)
        if isstruct(compiledIntData.condMean.(desig{m}))
            anim = fieldnames(compiledIntData);
            for n = 1:length(ints)
                for a = 1:(length(anim)-1)
                    if a==1
                        compiledIntData.condMean.(desig{m}).(ints{n}) = ...
                            compiledIntData.(anim{a}).mean.(desig{m}).(ints{n});
                    else
                        compiledIntData.condMean.(desig{m}).(ints{n}) = ...
                            compiledIntData.condMean.(desig{m}).(ints{n}) + ...
                            compiledIntData.(anim{a}).mean.(desig{m}).(ints{n});
                    end
                end
                compiledIntData.condMean.(desig{m}).(ints{n}) = ...
                    compiledIntData.condMean.(desig{m}).(ints{n})./(length(anim)-1);
            end
        else
            for a = 1:(length(anim)-1)
                if a==1
                    compiledIntData.condMean.(desig{m}) = ...
                        compiledIntData.(anim{a}).mean.(desig{m});
                else
                    compiledIntData.condMean.(desig{m}) = ...
                        compiledIntData.condMean.(desig{m}) + ...
                        compiledIntData.(anim{a}).mean.(desig{m});
                end
            end
            compiledIntData.condMean.(desig{m}) = ...
                    compiledIntData.condMean.(desig{m})./(length(anim)-1);
        end
    end
    
end
