function plotOverall(cupr,ctrl)
for c = 1:2
    if c == 1
        ALL = cupr;
        n = 10;
    else
        ALL = ctrl;
        n = 13;
    end
killCurve = ALL.avg.WKdataProp(1:n,4);
newCurve = ALL.avg.WKdataProp(1:n,5);
avgDeath = killCurve;
semDeath = ALL.sem.WKdataProp(1:n,4);
avgNew = newCurve;
semNew = ALL.sem.WKdataProp(1:n,5);
% x = [0 1 2 3 3.333 3.667 4 4.5 5 6 7 8 9 10 11 12 13 14 15];
x = 0:n-1;
y = [avgDeath,avgNew];
e = [semDeath,semNew];
figure
b = errorbarbar(x,y,e,{'stacked'},{'Color',[0.5 0.5 0.5],'LineStyle','none','MarkerSize',0.0001,'CapSize',0,'LineWidth',1.7});
set(b(1),'FaceColor','k');
set(b(1),'EdgeColor','none');
set(b(2),'FaceColor','g');
set(b(2),'EdgeColor','none');
ylim([0 1.4])
ylabel('proportion of cells')
xlabel('weeks')
figQuality(gcf,gca,[4 3])
end
end