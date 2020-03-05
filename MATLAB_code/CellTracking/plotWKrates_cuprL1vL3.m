function [avglost3,semlost3,avglost1,semlost1] = plotWKrates_cuprL1vL3(in,cond)
condEnd = 10;
[c1, c2] = getFigColors;
if contains(cond,'ctrl')
    color = c1;
else
    color = c2;
end
figure
title('lost rate')
avglost3 = [0;in.avg.BinnedWKdataProp(2:condEnd,2,1,3).*-1];
semlost3 = [0;in.sem.BinnedWKdataProp(2:condEnd,2,1,3)];
avglost1 = [0;in.avg.BinnedWKdataProp(2:condEnd,2,1,1).*-1];
semlost1 = [0;in.sem.BinnedWKdataProp(2:condEnd,2,1,1)];

firstplotline = '--o';
firstplotlinecolor = color;
firstplotcolor = color;
secondplotline = '-s';
secondplotlinecolor = color.*0.5;
secondplotcolor = color.*0.5;

errorbar(0:condEnd-1,avglost3,semlost3,secondplotline,'Color',secondplotlinecolor,'MarkerFaceColor',secondplotcolor)
hold on
errorbar(0:condEnd-1,avglost1,semlost1,firstplotline,'Color',firstplotlinecolor,'MarkerFaceColor',firstplotcolor)
ylabel({'rate of loss'; '(proportion of baseline/week)'})
ylim([-0.5 0])
xticks(0:condEnd-1)
xticklabels({'0' '1' '2' '3' '4' '5' '6' '7' '8' '9'})
xlabel('weeks')
hold off
figQuality(gcf,gca,[2.6 1.6])

figure 
title('new rate')
avgnew3 = [0;in.avg.BinnedWKdataProp(2:condEnd,3,1,3)];
semnew3 = [0;in.sem.BinnedWKdataProp(2:condEnd,3,1,3)];
avgnew1 = [0;in.avg.BinnedWKdataProp(2:condEnd,3,1,1)];
semnew1 = [0;in.sem.BinnedWKdataProp(2:condEnd,3,1,1)];
errorbar(0:condEnd-1,avgnew3,semnew3,secondplotline,'Color',secondplotlinecolor,'MarkerFaceColor',secondplotcolor)
hold on
errorbar(0:condEnd-1,avgnew1,semnew1,firstplotline,'Color',firstplotlinecolor','MarkerFaceColor',firstplotcolor)
ylabel({'rate of addition'; '(proportion of baseline/week)'})
xticks(0:condEnd-1)
xticklabels({'0' '1' '2' '3' '4' '5' '6' '7' '8' '9'})
xlabel('weeks')
ylim([0 .3])
hold off
figQuality(gcf,gca,[2.6 1.6])