function data = parseNodeFolders(data, cond_dir)
dirstr = cond_dir.folder;
cond = dirstr(end-6:end);
data.(cond) = [];
animal = {cond_dir.name};
animal = animal(3:end);
for a = 1:length(animal)
    bullshit = cd([dirstr '\' animal{a}]);
    sxn = dir(bullshit);
    bullshit = cd([dirstr '\' animal{a}]); % won't actually cd unless run twice...
    sxn = dir(bullshit);
    sxn = {sxn.name};
    sxn = sxn(3:end);
    for s = 1:length(sxn)
        bullshit = cd([dirstr '\' animal{a} '\' sxn{s}]);
        files = dir(bullshit);
        bullshit = cd([dirstr '\' animal{a} '\' sxn{s}]); % won't actually cd unless run twice...
        files = dir(bullshit);
        files = {files.name};
        files = files(3:end);
        data.(cond).(animal{a}).(sxn{s}).b4c = xlsread(files{1},'A:C');
        data.(cond).(animal{a}).(sxn{s}).b4f = xlsread(files{2},'A:C');
        data.(cond).(animal{a}).(sxn{s}).cas = xlsread(files{3},'A:C');
        
        biv = data.(cond).(animal{a}).(sxn{s}).b4c;
        caspr = data.(cond).(animal{a}).(sxn{s}).cas;
        dists = cell(size(biv,1),1);
        limit = 3.5;
        for b = 1:size(biv,1)
            [idx,dist] = knnsearch(caspr,biv(b,:),'K',2);
            dist = dist(dist < limit);
            idx = idx(dist < limit);
            caspr(idx,:) = NaN;
            dists{b} = dist;
        end
        alldist = [dists{:}];
        figure
        histogram(alldist)
        figQuality(gcf,gca,[4 3])
        flnks = [];
        for i = 1:length(dists)
            flnks = [flnks; length(dists{i})];
        end
        isol = length(flnks(flnks==0)) + size(data.(cond).(animal{a}).(sxn{s}).b4f,1);
        hemi = length(flnks(flnks==1));
        node = length(flnks(flnks==2));
        data.(cond).(animal{a}).(sxn{s}).isol = isol;
        data.(cond).(animal{a}).(sxn{s}).hemi = hemi;
        data.(cond).(animal{a}).(sxn{s}).node = node;
        total = isol + hemi + node;
        data.(cond).(animal{a}).(sxn{s}).isolP = isol./total;
        data.(cond).(animal{a}).(sxn{s}).hemiP = hemi./total;
        data.(cond).(animal{a}).(sxn{s}).nodeP = node./total;
        figure
        bar([data.(cond).(animal{a}).(sxn{s}).isol...
            data.(cond).(animal{a}).(sxn{s}).hemi...
            data.(cond).(animal{a}).(sxn{s}).node])
        xticklabels({'isolated?' 'heminode' 'node'})
        ylabel('number of beta-IV puncta')
        title([cond ' ' sxn{s}])
        ylim([0 1000])
        figQuality(gcf,gca,[4 3])
        % run again with xy flipped data
        biv = data.(cond).(animal{a}).(sxn{s}).b4c;
        biv = [biv(:,2) biv(:,1) biv(:,3)];
        caspr = data.(cond).(animal{a}).(sxn{s}).cas;
        dists = cell(size(biv,1),1);
        limit = 3.5;
        for b = 1:size(biv,1)
            [idx,dist] = knnsearch(caspr,biv(b,:),'K',2);
            dist = dist(dist < limit);
            idx = idx(dist < limit);
            caspr(idx,:) = NaN;
            dists{b} = dist;
        end
        alldist = [dists{:}];
        figure
        histogram(alldist)
        figQuality(gcf,gca,[4 3])
        flnks = [];
        for i = 1:length(dists)
            flnks = [flnks; length(dists{i})];
        end
        data.(cond).(animal{a}).(sxn{s}).isol_flp = length(flnks(flnks==0)) + size(data.(cond).(animal{a}).(sxn{s}).b4f,1);
        data.(cond).(animal{a}).(sxn{s}).hemi_flp = length(flnks(flnks==1));
        data.(cond).(animal{a}).(sxn{s}).node_flp = length(flnks(flnks==2));
        figure
        bar([data.(cond).(animal{a}).(sxn{s}).isol_flp...
            data.(cond).(animal{a}).(sxn{s}).hemi_flp...
            data.(cond).(animal{a}).(sxn{s}).node_flp])
        xticklabels({'isolated?' 'heminode' 'node'})
        ylabel('number of beta-IV puncta')
        title([cond ' ' sxn{s} ' xyflipped'])
        ylim([0 1000])
        figQuality(gcf,gca,[4 3])
    end
    data.(cond).(animal{a}).avg = [(data.(cond).(animal{a}).(sxn{1}).isol + data.(cond).(animal{a}).(sxn{2}).isol) ./ 2,...
                                   (data.(cond).(animal{a}).(sxn{1}).hemi + data.(cond).(animal{a}).(sxn{2}).hemi) ./ 2,...
                                   (data.(cond).(animal{a}).(sxn{1}).node + data.(cond).(animal{a}).(sxn{2}).node) ./ 2];
    data.(cond).(animal{a}).avgP = [(data.(cond).(animal{a}).(sxn{1}).isolP + data.(cond).(animal{a}).(sxn{2}).isolP) ./ 2,...
                                   (data.(cond).(animal{a}).(sxn{1}).hemiP + data.(cond).(animal{a}).(sxn{2}).hemiP) ./ 2,...
                                   (data.(cond).(animal{a}).(sxn{1}).nodeP + data.(cond).(animal{a}).(sxn{2}).nodeP) ./ 2];
    data.(cond).(animal{a}).avg_flp = [(data.(cond).(animal{a}).(sxn{1}).isol_flp + data.(cond).(animal{a}).(sxn{2}).isol_flp) ./ 2,...
                                   (data.(cond).(animal{a}).(sxn{1}).hemi_flp + data.(cond).(animal{a}).(sxn{2}).hemi_flp) ./ 2,...
                                   (data.(cond).(animal{a}).(sxn{1}).node_flp + data.(cond).(animal{a}).(sxn{2}).node_flp) ./ 2];
end
