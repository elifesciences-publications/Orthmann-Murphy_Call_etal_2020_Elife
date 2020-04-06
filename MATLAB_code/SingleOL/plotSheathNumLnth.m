function [ALL, stats] = plotSheathNumLnth(ALL)
ALL.stats.meanSheathNum = [];
cond = {'ctrl','cupr'};
for c = 1:2
    cells = fieldnames(ALL.(cond{c}));
    ALL.stats.BaseNumSheaths.(cond{c}) = [];
    ALL.stats.LastNumSheaths.(cond{c}) = [];
    ALL.stats.BaseLnthSheaths.(cond{c}) = [];
    ALL.stats.LastLnthSheaths.(cond{c}) = [];
    for i = 1:length(cells)
        ALL.stats.BaseNumSheaths.(cond{c}) = [ALL.stats.BaseNumSheaths.(cond{c}); ALL.(cond{c}).(cells{i}).num_BslineSheaths];
        ALL.stats.BaseLnthSheaths.(cond{c}) = [ALL.stats.BaseLnthSheaths.(cond{c}); ALL.(cond{c}).(cells{i}).mean_BslineSheathLength];
        days = fieldnames(ALL.(cond{c}).(cells{i}).raw);
        if contains(days{end},'d14') || contains(days{end},'d15')
            ALL.stats.LastNumSheaths.(cond{c}) = [ALL.stats.LastNumSheaths.(cond{c}); ALL.(cond{c}).(cells{i}).num_FinalSheaths];
            ALL.stats.LastLnthSheaths.(cond{c}) = [ALL.stats.LastLnthSheaths.(cond{c}); ALL.(cond{c}).(cells{i}).Total_SheathLengths(end)/ALL.(cond{c}).(cells{i}).num_FinalSheaths];
        elseif contains(days{end},'d12') || contains(days{end},'d13')
            ALL.stats.LastNumSheaths.(cond{c}) = [ALL.stats.LastNumSheaths.(cond{c}); ALL.(cond{c}).(cells{i}).num_FinalSheaths];
            temp = ALL.(cond{c}).(cells{i}).Total_SheathLengths;
            nandex = isnan(temp);
            temp(nandex) = [];
            L = temp(end);
            ALL.stats.LastLnthSheaths.(cond{c}) = [ALL.stats.LastLnthSheaths.(cond{c}); L/ALL.(cond{c}).(cells{i}).num_FinalSheaths];
            clear temp L
        else 
            ALL.stats.LastNumSheaths.(cond{c}) = [ALL.stats.LastNumSheaths.(cond{c}); NaN];
            ALL.stats.LastLnthSheaths.(cond{c}) = [ALL.stats.LastLnthSheaths.(cond{c}); NaN];
        end
    end
end
% statistics for numbers of sheaths
ctrlan = length(ALL.stats.BaseNumSheaths.ctrl);
cupran = length(ALL.stats.BaseNumSheaths.cupr);
data = [ALL.stats.BaseNumSheaths.ctrl;ALL.stats.LastNumSheaths.ctrl;ALL.stats.BaseNumSheaths.cupr;ALL.stats.LastNumSheaths.cupr];
cond = cell((ctrlan*2)+(cupran*2),1);
cond(1:ctrlan*2) = {'ctrl'};
cond(ctrlan*2+1:end) = {'cupr'};
tp = cell(size(cond));
tp(1:ctrlan) = {'bsln'};
tp(ctrlan+1:ctrlan*2) = {'last'};
tp(ctrlan*2+1:(ctrlan*2+1)+cupran) = {'bsln'};
tp((ctrlan*2+1)+cupran:end) = {'last'};
[stats.pNum,stats.numtbl,stats.numstats] = anovan(data,{cond,tp},'varnames',{'cond','tp'},'model','interaction','display','off');
% multcompare(stats,'Dimension',[1 2]);

% statistics for lengths of sheaths
ctrlan = length(ALL.stats.BaseLnthSheaths.ctrl);
cupran = length(ALL.stats.BaseLnthSheaths.cupr);
data = [ALL.stats.BaseLnthSheaths.ctrl;ALL.stats.LastLnthSheaths.ctrl;ALL.stats.BaseLnthSheaths.cupr;ALL.stats.LastLnthSheaths.cupr];
cond = cell((ctrlan*2)+(cupran*2),1);
cond(1:ctrlan*2) = {'ctrl'};
cond(ctrlan*2+1:end) = {'cupr'};
tp = cell(size(cond));
tp(1:ctrlan) = {'bsln'};
tp(ctrlan+1:ctrlan*2) = {'last'};
tp(ctrlan*2+1:(ctrlan*2+1)+cupran) = {'bsln'};
tp((ctrlan*2+1)+cupran:end) = {'last'};
[stats.pLnth,stats.lnthtbl,stats.lnthstats] = anovan(data,{cond,tp},'varnames',{'cond','tp'},'model','interaction','display','on');
stats.multcomp = multcompare(stats.lnthstats,'Dimension',[1 2],'CType','tukey-kramer');

% get means and sems for numbers and lengths to plot
ALL.stats.meanSheathNumBsln = [mean(ALL.stats.BaseNumSheaths.ctrl) , calcSEM(ALL.stats.BaseNumSheaths.ctrl')];
ALL.stats.meanSheathNumBsln(2,:) = [mean(ALL.stats.BaseNumSheaths.cupr) , calcSEM(ALL.stats.BaseNumSheaths.cupr')];
ALL.stats.meanSheathLnthBsln = [mean(ALL.stats.BaseLnthSheaths.ctrl) , calcSEM(ALL.stats.BaseLnthSheaths.ctrl')];
ALL.stats.meanSheathLnthBsln(2,:) = [mean(ALL.stats.BaseLnthSheaths.cupr) , calcSEM(ALL.stats.BaseLnthSheaths.cupr')];

ALL.stats.meanSheathNumLast = [mean(ALL.stats.LastNumSheaths.ctrl) , calcSEM(ALL.stats.LastNumSheaths.ctrl')];
ALL.stats.meanSheathNumLast(2,:) = [mean(ALL.stats.LastNumSheaths.cupr,'omitnan') , calcSEM(ALL.stats.LastNumSheaths.cupr')];
ALL.stats.meanSheathLnthLast = [mean(ALL.stats.LastLnthSheaths.ctrl) , calcSEM(ALL.stats.LastLnthSheaths.ctrl')];
ALL.stats.meanSheathLnthLast(2,:) = [mean(ALL.stats.LastLnthSheaths.cupr,'omitnan') , calcSEM(ALL.stats.LastLnthSheaths.cupr')];

ctrlNumBsln = ALL.stats.BaseNumSheaths.ctrl;
ctrlNumLast = ALL.stats.LastNumSheaths.ctrl;
cuprNumBsln = ALL.stats.BaseNumSheaths.cupr;
cuprNumLast = ALL.stats.LastNumSheaths.cupr;
ctrlLnthBsln = ALL.stats.BaseLnthSheaths.ctrl;
ctrlLnthLast = ALL.stats.LastLnthSheaths.ctrl;
cuprLnthBsln = ALL.stats.BaseLnthSheaths.cupr;
cuprLnthLast = ALL.stats.LastLnthSheaths.cupr;

[ctrlNumBsln,cuprNumBsln] = forceConcat(ctrlNumBsln,cuprNumBsln);
[ctrlNumLast,cuprNumLast] = forceConcat(ctrlNumLast,cuprNumLast);
[ctrlLnthBsln,cuprLnthBsln] = forceConcat(ctrlLnthBsln,cuprLnthBsln);
[ctrlLnthLast,cuprLnthLast] = forceConcat(ctrlLnthLast,cuprLnthLast);

[c1,c2] = getFigColors;
% comparison plot for sheath number change
figure
title('number of sheaths per cell day 0-14')
flNumCtrl = [ctrlNumBsln,ctrlNumLast];
flNumCupr = [cuprNumBsln,cuprNumLast];
hold on
plot(flNumCtrl','-o','Color',c1)
plot(flNumCupr','-o','Color',c2)
ylim([0 70])
xlim([0 3])
xticks([1 2])
xticklabels({'baseline','day 14'})
ylabel('number of sheaths')
hold off
figQuality(gcf,gca,[4 3])
% comparison plot for sheath length change
figure
title('average sheath length per cell day 0-14')
flNumCtrl = [ctrlLnthBsln,ctrlLnthLast];
flNumCupr = [cuprLnthBsln,cuprLnthLast];
hold on
plot(flNumCtrl','-o','Color',c1)
plot(flNumCupr','-o','Color',c2)
ylim([0 90])
xlim([0 3])
xticks([1 2])
xticklabels({'baseline','day 14'})
ylabel('average sheath length (\mum)')
hold off
figQuality(gcf,gca,[4 3])
end