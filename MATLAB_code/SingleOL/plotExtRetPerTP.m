function plotExtRetPerTP(ALL)

avgExtctrl = mean(ALL.stats.extLnthPerTP.ctrl,'omitnan');
semExtctrl = calcSEM(ALL.stats.extLnthPerTP.ctrl);
avgRetctrl = mean(ALL.stats.retLnthPerTP.ctrl,'omitnan');
semRetctrl = calcSEM(ALL.stats.retLnthPerTP.ctrl);
avgExtcupr = mean(ALL.stats.extLnthPerTP.cupr,'omitnan');
semExtcupr = calcSEM(ALL.stats.extLnthPerTP.cupr);
avgRetcupr = mean(ALL.stats.retLnthPerTP.cupr,'omitnan');
semRetcupr = calcSEM(ALL.stats.retLnthPerTP.cupr);

[c1,c2] = getFigColors;
% Extension lengths per tp
figure;  
subplot(2,2,1)
hold on
title('average length of extensions between time points')
errorbar(avgExtctrl,semExtctrl,'-s','Color',c1,'LineWidth',2,'MarkerFaceColor','auto')
errorbar(avgExtcupr,semExtcupr,'-s','Color',c2,'LineWidth',2,'MarkerFaceColor','auto')
% plot(ALL.stats.extLnthPerTP.ctrl','k') 
% plot(ALL.stats.extLnthPerTP.cupr','r') 
ylim([0 9])
xlabel('time (days)')
xticklabels({'0-2' '2-4' '4-6' '6-8' '8-10' '10-12' '12-14'})
ylabel('extension length (\mum)')
ylim([0 14])
xticks(1:7)
legend('de novo','remyelinating','Location','northeast')
hold off

% Retraction lengths per tp
subplot(2,2,2) 
hold on
title('average length of retractions between time points')
errorbar(abs(avgRetctrl),semRetctrl,'-s','Color',c1,'LineWidth',2,'MarkerFaceColor','auto')
errorbar(abs(avgRetcupr),semRetcupr,'-s','Color',c2,'LineWidth',2,'MarkerFaceColor','auto')
% plot(ALL.stats.retLnthPerTP.ctrl','k') 
% plot(ALL.stats.retLnthPerTP.cupr','r')
xlabel('time (days)')
xticks(1:7)
xticklabels({'0-2' '2-4' '4-6' '6-8' '8-10' '10-12' '12-14'})
ylabel('retraction length (\mum)')
ylim([0 14])
% legend('CTRL','CUPR','Location','northeast')
hold off

% Now get averages, SEMs for number
avgExtctrl = mean(ALL.stats.extNumPerTP.ctrl,'omitnan');
semExtctrl = calcSEM(ALL.stats.extNumPerTP.ctrl);
avgRetctrl = mean(ALL.stats.retNumPerTP.ctrl,'omitnan');
semRetctrl = calcSEM(ALL.stats.retNumPerTP.ctrl);
avgExtcupr = mean(ALL.stats.extNumPerTP.cupr,'omitnan');
semExtcupr = calcSEM(ALL.stats.extNumPerTP.cupr); 
avgRetcupr = mean(ALL.stats.retNumPerTP.cupr,'omitnan');
semRetcupr = calcSEM(ALL.stats.retNumPerTP.cupr); 

% Extension num per tp
subplot(2,2,3)
hold on
title('number of extensions between time points')
errorbar(avgExtctrl,semExtctrl,'-s','Color',c1,'LineWidth',2,'MarkerFaceColor','auto')
errorbar(avgExtcupr,semExtcupr,'-s','Color',c2,'LineWidth',2,'MarkerFaceColor','auto')
% plot(ALL.stats.extNumPerTP.ctrl','k')
% plot(ALL.stats.extNumPerTP.cupr','r') 
xlabel('time (days)')
xticks(1:7)
xticklabels({'0-2' '2-4' '4-6' '6-8' '8-10' '10-12' '12-14'})
ylabel('number of extensions')
ylim([0 45])
% legend('CTRL','CUPR','Location','northeast')
hold off

% Retraction num per tp
subplot(2,2,4)
hold on
title('number of retractions between time points')
errorbar(avgRetctrl,semRetctrl,'-s','Color',c1,'LineWidth',2,'MarkerFaceColor','auto')
errorbar(avgRetcupr,semRetcupr,'-s','Color',c2,'LineWidth',2,'MarkerFaceColor','auto')
% plot(ALL.stats.retNumPerTP.ctrl','k')
% plot(ALL.stats.retNumPerTP.cupr','r') 
xlabel('time (days)')
xticks(1:7)
xticklabels({'0-2' '2-4' '4-6' '6-8' '8-10' '10-12' '12-14'})
ylabel('number of retractions')
ylim([0 45])
% legend('CTRL','CUPR','Location','northeast')
hold off

figQuality(gcf,gca,[8 6])
end
