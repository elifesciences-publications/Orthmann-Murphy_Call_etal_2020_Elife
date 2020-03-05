function [pRangeBsln, pRangeLast, ALL] = plotRanges(ALL)
% length range per cell
cond = {'ctrl','cupr'};
for c = 1:2
    ALL.stats.range.(cond{c}) = [];
    cells = fieldnames(ALL.(cond{c}));
    for k = 1:length(cells)
        bshort = min(ALL.(cond{c}).(cells{k}).raw.d00.Sheath_Info.intLengths);
        blong = max(ALL.(cond{c}).(cells{k}).raw.d00.Sheath_Info.intLengths);
        days = fieldnames(ALL.(cond{c}).(cells{k}).raw);
        if contains(days{end},'d14') || contains(days{end},'d15')
            lshort = min(ALL.(cond{c}).(cells{k}).raw.(days{end}).Sheath_Info.intLengths);
            llong = max(ALL.(cond{c}).(cells{k}).raw.(days{end}).Sheath_Info.intLengths);
            ALL.stats.range.(cond{c}) = [ALL.stats.range.(cond{c}); blong-bshort, llong-lshort];
        else
            ALL.stats.range.(cond{c}) = [ALL.stats.range.(cond{c}); blong-bshort, NaN];
        end
    end
end
[~,pRangeBsln] = ttest2(ALL.stats.range.ctrl(:,1),ALL.stats.range.cupr(:,1));
[~,pRangeLast] = ttest2(ALL.stats.range.ctrl(:,2),ALL.stats.range.cupr(:,2));
[c1,c2] = getFigColors;
figure
avgDataBsln = [mean(ALL.stats.range.ctrl(:,1)),mean(ALL.stats.range.cupr(:,1))];
semBsln = [calcSEM(ALL.stats.range.ctrl(:,1)'),calcSEM(ALL.stats.range.cupr(:,1)')];
ctrlData = ALL.stats.range.ctrl;
cuprData = ALL.stats.range.cupr;
[ctrlData,cuprData] = forceConcat(ctrlData,cuprData,1);
hold on
plotSpread([ctrlData(:,1),cuprData(:,1)],'distributionMarkers',{'o'},'distributionColors',{c1,c2},'xNames',{'de novo','remyelinating'})
barwitherr(semBsln,avgDataBsln,'FaceColor','none','EdgeColor','k','LineWidth',1.5);
ylabel('range of sheath lengths (\mum)')
hold off
figQuality(gcf,gca,[4 3])
end