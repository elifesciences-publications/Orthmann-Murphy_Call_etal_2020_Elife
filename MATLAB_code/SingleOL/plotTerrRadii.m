[c1,c2] = getFigColors;
coloridx = {[0.5 0.5 0.5],c1,c2 [0.5 0.5 0.5],c1,c2};
bsln = ALL.stats.terrRadii.bsln; 
ctrl = ALL.stats.terrRadii.ctrl; 
cupr = ALL.stats.terrRadii.cupr;
avg = [mean(bsln,1); mean(ctrl,1); mean(cupr,1)];
sem = [calcSEM(bsln); calcSEM(ctrl); calcSEM(cupr)];
[bsln,ctrl] = forceConcat(bsln,ctrl,1);
[ctrl,cupr] = forceConcat(ctrl,cupr,1);
data = [bsln(:);ctrl(:);cupr(:)];
L = size(bsln,1);
idx = [ones(L,1).*0.78; ones(L,1).*1.78;...
       ones(L,1).*1; ones(L,1).*2;...
       ones(L,1).*1.226; ones(L,1).*2.226];
xes = [1 2; 1 2; 1 2];
figure
errorbarbar(xes',avg',sem',{'EdgeColor','k','FaceColor','none'},{'k','LineStyle','none'});
hold on
plotSpread(data,'distributionIdx',idx,'distributionMarkers',{'o'},'distributionColors',coloridx);
xticks([1 2])
xticklabels({})
hold off
figQuality(gcf,gca,[3.1 2.4])

%%
data = [bsln(:,1);ctrl(:,1);cupr(:,1)];
group = [ones(size(bsln,1),1); 2.*ones(size(ctrl,1),1); 3.*ones(size(cupr,1),1)];
[p,~,stats] = anova1(data,group);
figure
multcompare(stats);