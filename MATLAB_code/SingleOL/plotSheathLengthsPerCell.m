function ALL = plotSheathLengthsPerCell(ALL)
cond = {'ctrl','cupr'};
for c = 1:2
    ALL.stats.bslnAllSheathLnths.(cond{c}) = [];
    ALL.stats.lastAllSheathLnths.(cond{c}) = [];
    cells = fieldnames(ALL.(cond{c}));
    for k = 1:length(cells)
        lnths = ALL.(cond{c}).(cells{k}).raw.d00.Sheath_Info.intLengths;
        [ALL.stats.bslnAllSheathLnths.(cond{c}), lnths] = forceConcat(ALL.stats.bslnAllSheathLnths.(cond{c}), lnths, 1);
        ALL.stats.bslnAllSheathLnths.(cond{c}) = [ALL.stats.bslnAllSheathLnths.(cond{c}), lnths];
        days = fieldnames(ALL.(cond{c}).(cells{k}).raw);
        if contains(days{end},{'d12','d14','d15'})
            lnths = ALL.(cond{c}).(cells{k}).raw.(days{end}).Sheath_Info.intLengths;
            [ALL.stats.lastAllSheathLnths.(cond{c}), lnths] = forceConcat(ALL.stats.lastAllSheathLnths.(cond{c}), lnths, 1);
            ALL.stats.lastAllSheathLnths.(cond{c}) = [ALL.stats.lastAllSheathLnths.(cond{c}), lnths];
        end
    end
end
[c1, c2] = getFigColors;
ctrlData = ALL.stats.bslnAllSheathLnths.ctrl;
cuprData = ALL.stats.bslnAllSheathLnths.cupr;
[ctrlData,cuprData] = forceConcat(ctrlData,cuprData,1);
data = [ctrlData,cuprData];
data(data==0) = NaN; % why are lengths==0 at d00?
colors = cell(1,size(ctrlData,2)+size(cuprData,2));
colors(1:size(ctrlData,2)) = {c1};
colors(size(ctrlData,2)+1:end) = {c2};
figure
subplot(1,2,1)
plotSpread(data,'distributionColors',colors)
hold on
sem = calcSEM(data);
avg = mean(data,'omitnan');
errorbar(avg,sem,'.','Color',[.5 .5 .5],'MarkerSize',10)
hold off
ylabel('sheath length (\mum)')
xticks([])
xticklabels({})
box off

[ALL.stats.lastAllSheathLnths.ctrl,ALL.stats.lastAllSheathLnths.cupr] = forceConcat(ALL.stats.lastAllSheathLnths.ctrl,ALL.stats.lastAllSheathLnths.cupr,1);
ctrlData = ALL.stats.lastAllSheathLnths.ctrl;
cuprData = ALL.stats.lastAllSheathLnths.cupr;
data = [ctrlData,cuprData];
data(data==0) = NaN; % remove sheaths that were lost (now = 0)
colors = cell(1,size(ctrlData,2)+size(cuprData,2));
colors(1:size(ctrlData,2)) = {c1};
colors(size(ctrlData,2)+1:end) = {c2};
subplot(1,2,2)
plotSpread(data,'distributionColors',colors)
hold on
sem = calcSEM(data);
avg = mean(data,'omitnan');
errorbar(avg,sem,'.','Color',[.5 .5 .5],'MarkerSize',10)
hold off
ylabel('sheath length (\mum)')
xticks([])
xticklabels({})
figQuality(gcf,gca,[8 3])

% ctrl 14 day statistics to compare with Corfas FC morphological data
% is internode length normally distributed?
bins = zeros(85,size(ALL.stats.lastAllSheathLnths.ctrl,2));
for i = 1:85
    if i<85
        bins(i,:) = sum(ALL.stats.lastAllSheathLnths.ctrl<(i*6) & ALL.stats.lastAllSheathLnths.ctrl>(6*(i-1)),1);
    else
        bins(i,:) = sum(ALL.stats.lastAllSheathLnths.ctrl>140,1);
    end
end
% avgbins = mean(bins,1);
totbins = sum(bins,2);
figure
bar(totbins)
figQuality(gcf,gca,[4 3])
[~,pNormalLnthsCtrl] = kstest(totbins)

% does average internode length correlate with number of internodes?
lnthVnum = NaN(size(ALL.stats.lastAllSheathLnths.ctrl,2),2);
for i = 1:size(ALL.stats.lastAllSheathLnths.ctrl,2)
    data = ALL.stats.lastAllSheathLnths.ctrl(:,i);
    lnthVnum(i,1) = mean(data,'omitnan');
    lnthVnum(i,2) = sum(~isnan(data));
end
figure
title('no correlation between number and length of internodes at d14 (ctrl cells only)')
plot(lnthVnum(:,1),lnthVnum(:,2),'ko')
ylabel('number of internodes')
xlabel('average length of internodes (\mum)')
ylim([40 80])
xlim([40 80])
figQuality(gcf,gca,[4 3])
[R,pLnthNumCorrCtrl] = corrcoef(lnthVnum(:,1),lnthVnum(:,2))
end