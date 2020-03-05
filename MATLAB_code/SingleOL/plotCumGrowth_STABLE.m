function ALL = plotCumGrowth_STABLE(ALL)
% GRAPH FOR CUMULATIVE GROWTH
fields = fieldnames(ALL.bzaS);
temp = [];
for i = 1:length(fields)
    idx = isnan(ALL.bzaS.(fields{i}).Total_SheathLengths);
    ALL.bzaS.(fields{i}).Total_SheathLengths(idx) = [];
    lnths = ALL.bzaS.(fields{i}).Total_SheathLengths;
    temp = [temp; lnths];
end
ALL.stats.allCummGrowth.bzaS = temp;
ALL.stats.normCummGrowth.bzaS = temp./temp(:,1);
ALL.stats.meanCummGrowth.bzaS = mean(temp,1,'omitnan');
ALL.stats.normMeanGrowth.bzaS = mean(ALL.stats.normCummGrowth.bzaS,1,'omitnan');
sem = [];
normsem = [];
for k = 1:size(ALL.stats.allCummGrowth.bzaS,2)
    sem = [sem, std(ALL.stats.allCummGrowth.bzaS(:,k),'omitnan')./sqrt(length(ALL.stats.allCummGrowth.bzaS(:,k)))];
    normsem = [normsem, std(ALL.stats.normCummGrowth.bzaS(:,k),'omitnan')./sqrt(length(ALL.stats.normCummGrowth.bzaS(:,k)))];
end
ALL.stats.growthSEM.bzaS = sem;
ALL.stats.normGrowthSEM.bzaS = normsem;
bsln =  ALL.stats.allCummGrowth.bzaS(:,1);
last = ALL.stats.allCummGrowth.bzaS(:,end);

[~,~,~,c1] = getFigColors;
avgs = [mean(bsln,'omitnan'),mean(last,'omitnan')];
sems = [calcSEM(bsln'),calcSEM(last')];
figure
hold on
plot(ALL.stats.allCummGrowth.bzaS','-o','Color',c1)
errorbar(avgs,sems,'.','MarkerSize',25,'Color',c1.*0.8)
hold off
title('net total length change')
xticks([1 2])
xticklabels({'baseline','5 weeks recovery'})
xlim([0.5 2.5])
ylim([0, max(max(ALL.stats.allCummGrowth.bzaS))+1000])
ylabel('total sheath length (\mum)')
figQuality(gcf,gca,[4 3])
end