function stats = plotDists_simple(in1,in2,showstats)
[ctrl,cupr] = getFigColors;
avg = [in1.avg.Dists([1 3]) in1.avg.BinnedDists(1,[1 3]);...
       in2.avg.Dists([1 3]) in2.avg.BinnedDists(1,[1 3])];
sem = [in1.sem.Dists([1 3]) in1.sem.BinnedDists(1,[1 3]);...
       in2.sem.Dists([1 3]) in2.sem.BinnedDists(1,[1 3])];
ctrlDataL1 = in1.avg.BinnedDistsALL(1,[1 3],:);
ctrlDataL1 = permute(ctrlDataL1,[2 3 1])';
ctrlData = [in1.avg.DistsAll(:,[1 3]) ctrlDataL1];
cuprDataL1 = in2.avg.BinnedDistsALL(1,[1 3],:);
cuprDataL1 = permute(cuprDataL1,[2 3 1])';
cuprData = [in2.avg.DistsAll(:,[1 3]) cuprDataL1];
[ctrlData,cuprData] = forceConcat(ctrlData,cuprData,1);
L = size(ctrlData,1);
idx = [ones(L,1).*0.56; ones(L,1).*3.56;...
    ones(L,1).*6.56; ones(L,1).*9.56;...
    ones(L,1).*1.45; ones(L,1).*4.45;...
    ones(L,1).*7.45; ones(L,1).*10.45];
ctrlDatavect = ctrlData(:);
cuprDatavect = cuprData(:);
xes = [1 4 7 10; 1 4 7 10];
coloridx = {ctrl cupr ctrl cupr ctrl cupr ctrl cupr};
data = [ctrlDatavect;cuprDatavect];
figure
errorbarbar(xes',avg',sem',{'EdgeColor','k','FaceColor','none'},{'k','LineStyle','none'});
hold on
plotSpread(data,'distributionIdx',idx,'distributionMarkers',{'o'},'distributionColors',coloridx);
xticks([1 4 7 10])
xticklabels({})
title('nearest neighbor distances')
hold off
figQuality(gcf,gca,[3.1 2.4])

[~,stats.anovatbl,stats.anovastats] = anova1(data,idx);
if showstats
    figure
    multcompare(stats.anovastats);
end
[~,pStbl300,~,stats.Stbl300_Tstats] = ttest2(ctrlData(:,1),cuprData(:,1));
[~,pAll300,~,stats.All300_Tstats] = ttest2(ctrlData(:,2),cuprData(:,2));
[~,pStbl100,~,stats.Stbl100_Tstats] = ttest2(ctrlData(:,3),cuprData(:,3));
[~,pAll100,~,stats.All100_Tstats] = ttest2(ctrlData(:,4),cuprData(:,4));
[~,pCT_allVstbl_300,~,stats.CTallVstbl_300_Tstats] = ttest2(ctrlData(:,1),ctrlData(:,2));
[~,pCU_allVstbl_300,~,stats.CUallVstbl_300_Tstats] = ttest2(cuprData(:,1),cuprData(:,2));
[~,pCT_allVstbl_100,~,stats.CTallVstbl_100_Tstats] = ttest2(ctrlData(:,3),ctrlData(:,4));
[~,pCU_allVstbl_100,~,stats.CUallVstbl_100_Tstats] = ttest2(cuprData(:,3),cuprData(:,4));
stats.psBFC = table(pStbl300.*8,pAll300.*8,pStbl100.*8,pAll100.*8,pCT_allVstbl_300.*8,pCU_allVstbl_300.*8,pCT_allVstbl_100.*8,pCU_allVstbl_100.*8,...
                    'VariableNames',{'pStbl300','pAll300','pStbl100','pAll100','pCT_allVstbl_300','pCU_allVstbl_300','pCT_allVstbl_100','pCU_allVstbl_100'});
end