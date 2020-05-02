function [terrPs,terrStats] = plotTerritoryOverlap_oneCond(in1,figColorNum)
[c1,c2] = getFigColors;
colors = [c1;c2];
data=in1;
color=colors(figColorNum,:);
an = fieldnames(data);
for a = 1:length(an)-2
    bslnCellNumPerAn.in1(a) = data.(an{a}).avgquad.BinnedWKdata(1,1,1,1);
end
% plot replaced volume relative to ratio of baseline to new cells
in1Data = in1.avg.volOverlapPerAn(:,2) .* (bslnCellNumPerAn.in1' ./ in1.avg.volOverlapPerAn(:,1));
in1RanData = in1.avg.volOverlapRandPerAn(:,2) .* (bslnCellNumPerAn.in1' ./ in1.avg.volOverlapRandPerAn(:,1));
groups = [repmat('real',size(in1Data)); repmat('rand',size(in1RanData))];
[terrPs.ReplVolp,~,terrStats.ReplVol] = anova1([in1Data;in1RanData],groups);
l = length(in1Data);
idx = [ones(l,1); ones(l,1).*2];
avg = [mean(in1Data,'omitnan');mean(in1RanData,'omitnan')];
sem = [calcSEM(in1Data,1);calcSEM(in1RanData,1)];
Data = [in1Data;in1RanData];
figure
b = barwitherr(sem,avg);
b(1).FaceColor = 'none';
hold on
plotSpread(Data,'distributionMarkers',{'o'},'distributionIdx',idx,'distributionColors',{color,[0.5 0.5 0.5]})
xticks([1 2])
xticklabels({'condition','random'})
ylim([0 1])
hold off
figQuality(gcf,gca,[1 1.8])

% plot novel volume relative to ratio of baseline to new cells
in1Data = in1.avg.volOverlapPerAn(:,4) .* (bslnCellNumPerAn.in1' ./ in1.avg.volOverlapPerAn(:,1));
in1RanData = in1.avg.volOverlapRandPerAn(:,4) .* (bslnCellNumPerAn.in1' ./ in1.avg.volOverlapRandPerAn(:,1));
groups = [repmat('real',size(in1Data)); repmat('rand',size(in1RanData))];
[terrPs.novlVolp,~,terrStats.novlVol] = anova1([in1Data;in1RanData],groups);
l = length(in1Data);
idx = [ones(l,1); ones(l,1).*2];
avg = [mean(in1Data,'omitnan');mean(in1RanData,'omitnan')];
sem = [calcSEM(in1Data,1);calcSEM(in1RanData,1)];
Data = [in1Data;in1RanData];
figure
b = barwitherr(sem,avg);
b(1).FaceColor = 'none';
hold on
plotSpread(Data,'distributionMarkers',{'o'},'distributionIdx',idx,'distributionColors',{color,[0.5 0.5 0.5]})
xticks([1 2])
xticklabels({'condition','random'})
% ylim([0 3.5])
hold off
figQuality(gcf,gca,[1,1.8])