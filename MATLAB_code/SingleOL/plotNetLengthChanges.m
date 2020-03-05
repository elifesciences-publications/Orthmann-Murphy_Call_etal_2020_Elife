% edited 20180516 CLC - added line plot, adjusted figQuality
function ALL = plotNetLengthChanges(ALL)
% BEESWARM PLOT OF NET GROWTH PER SHEATH
% LINE PLOT OF NET LENGTH CHANGE PER TIMEPOINT
[c1,c2] = getFigColors;
% First parse cuprizone data
cupr_fields = fieldnames(ALL.cupr);
ALL.stats.allnetchanges.cupr = [];
for i = 1:length(cupr_fields)
    ALL.stats.meanNetChange.cupr(i,1) = mean(ALL.cupr.(cupr_fields{i}).net_sheath_LengthDiffs);
    ALL.stats.allnetchanges.cupr = [ALL.stats.allnetchanges.cupr; ALL.cupr.(cupr_fields{i}).net_sheath_LengthDiffs];
end
cupr_avg = mean(ALL.stats.meanNetChange.cupr);
cupr_sem = std(ALL.stats.allnetchanges.cupr)./sqrt(length(cupr_fields));
% Now parse control data
ctrl_fields = fieldnames(ALL.ctrl);
ALL.stats.allnetchanges.ctrl = [];
for i = 1:length(ctrl_fields)
    ALL.stats.meanNetChange.ctrl(i,1) = mean(ALL.ctrl.(ctrl_fields{i}).net_sheath_LengthDiffs);
    ALL.stats.allnetchanges.ctrl = [ALL.stats.allnetchanges.ctrl; ALL.ctrl.(ctrl_fields{i}).net_sheath_LengthDiffs];
end
ctrl_avg = mean(ALL.stats.meanNetChange.ctrl);
ctrl_sem = std(ALL.stats.allnetchanges.ctrl)./sqrt(length(ctrl_fields));

figure('Name','Net Change in Length per Sheath')
xNames = {'CTRL','CUPR'};
biggest = max(length(ALL.stats.allnetchanges.ctrl) , length(ALL.stats.allnetchanges.cupr));
% Force the sizes of cupr/ctrl vectors to same length for concatenation
if biggest > length(ALL.stats.allnetchanges.ctrl)
    temp = NaN(biggest,1);
    temp(1:length(ALL.stats.allnetchanges.ctrl)) = ALL.stats.allnetchanges.ctrl;
    ALL.stats.allnetchanges.ctrl = temp;
else
    temp = NaN(biggest,1);
    temp(1:length(ALL.stats.allnetchanges.cupr)) = ALL.stats.allnetchanges.cupr;
    ALL.stats.allnetchanges.cupr = temp;
end
data = [ALL.stats.allnetchanges.ctrl , ALL.stats.allnetchanges.cupr];
figure
p = plotSpread(data,'xNames',xNames, 'distributionColors',{c1,c2});
hold on
title('net length change per sheath')
ylabel('net change in sheath length (\mum)')
% Overlay averages and construct errorbars with SEM
plot(1,ctrl_avg,'o','MarkerFaceColor',c1,'MarkerSize',8,'MarkerEdgeColor',c1)
E1 = errorbar(1,ctrl_avg,ctrl_sem,'.-','Color',c1);
E1.CapSize = 22;
E1.LineWidth = 1.2;
E1.MarkerSize = 17;
plot(2,cupr_avg,'o','MarkerFaceColor',c2,'MarkerSize',8,'MarkerEdgeColor',c2)
E2 = errorbar(2,cupr_avg,cupr_sem,'.-','Color',c2);
E2.CapSize = 22;
E2.LineWidth = 1.2;
E2.MarkerSize = 17;
hold off

figQuality(gcf,gca,[4 3])
%export_fig('.\EPS_Panels\NetLengthChanges.eps',gcf);

avgCtrlLnths = mean(ALL.stats.avgLnthChngPerTP.ctrl,'omitnan');
semCtrlLnths = calcSEM(ALL.stats.avgLnthChngPerTP.ctrl,1);
avgCuprLnths = mean(ALL.stats.avgLnthChngPerTP.cupr,'omitnan');
semCuprLnths = calcSEM(ALL.stats.avgLnthChngPerTP.cupr,1);

figure('Name','Net Change in Length per Sheath per Time Point')
hold on
xNames = {'CTRL','CUPR'};
errorbar([2,4,6,8,10,12,14],avgCtrlLnths,semCtrlLnths,'-s','LineWidth',2,'MarkerFaceColor',c1,'MarkerEdgeColor',c1)
errorbar([2,4,6,8,10,12,14],avgCuprLnths,semCuprLnths,'-s','LineWidth',2,'MarkerFaceColor',c2,'MarkerEdgeColor',c1)
title('Net Total Sheath Growth')
xlabel('Time (days)')
xticklabels({'0-2' '2-4' '4-6' '6-8' '8-10' '10-12' '12-14'})
ylabel('Total Sheath Length (\mum)')
legend('CTRL','CUPR','Location','northeast')
hold off

figQuality(gcf,gca,[6 5])
end