function [avgDeath,semDeath,avgNew,semNew] = plotByBin(in,cond)
if contains(cond,'ctrl')
    n = 10;
else
    n = 13;
end
figure
for b = 1:3
    subplot(1,3,b)
    data = in.avg.BinnedWKdataProp(2:n,:,1,b);
    killCurve = data(:,4);
    newCurve = data(:,5);
    avgDeath = [1; killCurve];
    semDeath = in.sem.BinnedWKdataProp(2:n,4);
    avgNew = [0; newCurve];
    semNew = in.sem.BinnedWKdataProp(2:n,5);
    x = 0:n-1;
    y = [avgDeath,avgNew];
    e = [[0;semDeath],[0;semNew]];
    bars = errorbarbar(x,y,e,{'stacked'},{'Color',[0.5 0.5 0.5],'LineStyle','none','MarkerSize',0.0001,'CapSize',0,'LineWidth',1.7});
    hold on
    set(bars(1),'FaceColor','k');
    set(bars(1),'EdgeColor','none');
    set(bars(2),'FaceColor','g');
    set(bars(2),'EdgeColor','none');
    ylim([0 1.4])
    yticks(0:.2:1.4)
    if b==1
        ylabel('proportion of cells')
    end
    xlabel('weeks')
    axh.XColor = 'k'; axh.YColor = 'k'; axh.ZColor = 'k';
    box off
    hold off
end
figQuality(gcf,gca,[8.3 1.8])
end