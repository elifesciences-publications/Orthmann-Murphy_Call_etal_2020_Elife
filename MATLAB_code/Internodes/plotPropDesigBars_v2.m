function plotPropDesigBars_v2(P,M,cond)
colors = {[255 247 147]...
          [158 41 255]...
          [74 254 255]};
for i=1:3
    colors{i} = colors{i}./255;
end
if contains(cond,'cupr')
    labels = {'replaced','not replaced','novel'};
    d = fieldnames(P);
    figure
    hold on
    sem = [P.(d{4})(:,end), P.(d{2})(:,end), P.(d{3})(:,end)];
    data = [P.(d{4})(:,end-1), P.(d{2})(:,end-1), P.(d{3})(:,end-1)];
    b = bar(data','stacked');
    set(b(1),'FaceColor', [0.5 0.5 0.5]);
    set(b(2),'FaceColor', colors{1});
    set(b(3),'FaceColor', colors{2});
    errorbar([1 2 3],data(1,:),sem(1,:),'Color','k','LineStyle','none')
    errorbar([1 2 3],sum(data(1:2,:)),sem(2,:),'Color','k','LineStyle','none')
    errorbar([1 2 3],sum(data(1:3,:)),sem(3,:),'Color','k','LineStyle','none')
    xticks([1 2 3])
    set(gca,'XTickLabel',labels)
    ylabel('proportion of internodes')
    ylim([0 1.2])
    hold off
    figQuality(gcf,gca,[3.1 2.4])
else %ctrl
    labels = {'stable', 'novel'};
    d = fieldnames(P);
    figure
    hold on
    sem = [P.(d{1})(:,end), P.(d{3})(:,end)];
    data = [P.(d{1})(:,end-1), P.(d{3})(:,end-1)];
    b = bar(data','stacked');
    set(b(1),'FaceColor', [0.5 0.5 0.5]);
    set(b(2),'FaceColor', colors{1});
    set(b(3),'FaceColor', colors{2});
    errorbar([1 2],data(1,:),sem(1,:),'Color','k','LineStyle','none')
    errorbar([1 2],sum(data(1:2,:)),sem(2,:),'Color','k','LineStyle','none')
    errorbar([1 2],sum(data(1:3,:)),sem(3,:),'Color','k','LineStyle','none')
    xticks([1 2])
    set(gca,'XTickLabel',labels)
    ylabel('proportion of internodes')
    ylim([0 1.2])
    hold off
    figQuality(gcf,gca,[3.1 2.4])
end

sem = [P.bsln(1:end,end), P.last(1:end,end)];
data = [P.bsln(1:end,end-1), P.last(1:end,end-1)];
figure
hold on
b = bar(data','stacked');
set(b(1),'FaceColor', [0.5 0.5 0.5]);
set(b(2),'FaceColor', colors{1});
set(b(3),'FaceColor', colors{2});
% set(b(4),'FaceColor', colors{3});
errorbar([1 2],data(1,:),sem(1,:),'Color','k','LineStyle','none')
errorbar([1 2],sum(data(1:2,:)),sem(2,:),'Color','k','LineStyle','none')
errorbar([1 2],sum(data(1:3,:)),sem(3,:),'Color','k','LineStyle','none')
% errorbar([1 2],sum(data(1:4,:)),sem(4,:),'Color','k','LineStyle','none')
xticks([1 2])
set(gca,'XTickLabel',{'baseline','final'})
ylabel('proportion of internodes')
ylim([0 1.2])
hold off
figQuality(gcf,gca,[3.1 2.4])
end