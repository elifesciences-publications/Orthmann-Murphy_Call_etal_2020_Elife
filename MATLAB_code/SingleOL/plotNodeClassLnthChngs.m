function ALL = plotNodeClassLnthChngs(ALL)
cond = {'ctrl','cupr'};
for c = 1:length(cond)
    cells = fieldnames(ALL.(cond{c}));
    ALL.stats.NodeLnthChngs.(cond{c}).isol = NaN(length(cells),8);
    ALL.stats.NodeLnthChngs.(cond{c}).i2t = NaN(length(cells),8);
    ALL.stats.NodeLnthChngs.(cond{c}).i2c = NaN(length(cells),8);
    ALL.stats.NodeLnthChngs.(cond{c}).term = NaN(length(cells),8);
    ALL.stats.NodeLnthChngs.(cond{c}).t2c = NaN(length(cells),8);
    ALL.stats.NodeLnthChngs.(cond{c}).cont = NaN(length(cells),8);
    for k = 1:length(cells)
        nodes = ALL.(cond{c}).(cells{k}).nodeClassPerTP;
        lnths = ALL.(cond{c}).(cells{k}).sheathLengthPerTP;
        % isolated the whole time
        isolIdx = nodes(:,1)==3 & nodes(:,end)==3;
        isolLnths = lnths(isolIdx,:);
        isolLnthsNorm = isolLnths./isolLnths(:,1);
        isolDiff = isolLnths(:,end) - isolLnths(:,1);
        % starts isolated max terminal
        i2tIdx = nodes(:,1)==3 & max(nodes,[],2)==4;
        i2tLnths = lnths(i2tIdx,:);
        i2tLnthsNorm = i2tLnths./i2tLnths(:,1);
        i2tDiff = i2tLnths(:,end) - i2tLnths(:,1);
        % starts isolated max continuous
        i2cIdx = nodes(:,1)==3 & max(nodes,[],2)==5;
        i2cLnths = lnths(i2cIdx,:);
        i2cLnthsNorm = i2cLnths./i2cLnths(:,1);
        i2cDiff = i2cLnths(:,end) - i2cLnths(:,1);
        % terminal the whole time
        termIdx = nodes(:,1)==4 & nodes(:,end)==4;
        termLnths = lnths(termIdx,:);
        termLnthsNorm = termLnths./termLnths(:,1);
        termDiff = termLnths(:,end) - termLnths(:,1);
        % starts terminal max continuous
        t2cIdx = nodes(:,1)==4 & max(nodes,[],2)==5;
        t2cLnths = lnths(t2cIdx,:);
        t2cLnthsNorm = t2cLnths./t2cLnths(:,1);
        t2cDiff = t2cLnths(:,end) - t2cLnths(:,1);
        % continuous the whole time
        contIdx = nodes(:,1)==5 & nodes(:,end)==5;
        contLnths = lnths(contIdx,:);
        contLnthsNorm = contLnths./contLnths(:,1);
        contDiff = contLnths(:,end) - contLnths(:,1);
        
%         isolLnthsNormAvg = 
%         isolLnthsNormSem = calcSEM(isolLnthsNorm,1);
%         termLnthsNormAvg = 
%         termLnthsNormSem = calcSEM(termLnthsNorm,1);
%         contLnthsNormAvg = 
%         contLnthsNormSem = calcSEM(contLnthsNorm,1);
        
        ALL.stats.NodeLnthChngs.(cond{c}).isol(k,:) = mean(isolLnthsNorm,1,'omitnan');
        ALL.stats.NodeLnthChngs.(cond{c}).i2t(k,:) = mean(i2tLnthsNorm,1,'omitnan');
        ALL.stats.NodeLnthChngs.(cond{c}).i2c(k,:) = mean(i2cLnthsNorm,1,'omitnan');
        ALL.stats.NodeLnthChngs.(cond{c}).term(k,:) = mean(termLnthsNorm,1,'omitnan');
        ALL.stats.NodeLnthChngs.(cond{c}).t2c(k,:) = mean(t2cLnthsNorm,1,'omitnan');
        ALL.stats.NodeLnthChngs.(cond{c}).cont(k,:) = mean(contLnthsNorm,1,'omitnan');
        
%         figure
%         hold on;
%         errorbar(isolLnthsNormAvg,isolLnthsNormSem,'r-');
%         errorbar(termLnthsNormAvg,termLnthsNormSem,'g-');
%         errorbar(contLnthsNormAvg,contLnthsNormSem,'b-');
%         hold off
    end
end
%%
colors = {[255 247 147]...
          [215 71 90]...
          [74 254 255]};
for i=1:3
    colors{i} = colors{i}./255;
end
figure
subplot(1,2,1)
hold on
% t = {'isol','i2t','i2c','term','t2c','cont'};
t = {'isol','term','cont'};
for i=1:length(t)
    errorbar(mean(ALL.stats.NodeLnthChngs.ctrl.(t{i}),1,'omitnan'),calcSEM(ALL.stats.NodeLnthChngs.ctrl.(t{i}),1),'Color',0.9.*colors{i},'LineWidth',2);
end
legend(t,'Location','southeast')
ylim([0.5 1.5])
box off
hold off

subplot(1,2,2)
hold on
t = {'isol','term','cont'};
for i=1:length(t)
    errorbar(mean(ALL.stats.NodeLnthChngs.cupr.(t{i}),1,'omitnan'),calcSEM(ALL.stats.NodeLnthChngs.cupr.(t{i}),1),'Color',0.9.*colors{i},'LineWidth',2);
end
% legend(t)
ylim([0.5 1.5])
hold off
figQuality(gcf,gca,[8 3])
%%
figure
subplot(1,2,1)
hold on
% t = {'isol','i2t','i2c','term','t2c','cont'};
t = {'i2t','i2c','t2c'};
for i=1:length(t)
    errorbar(mean(ALL.stats.NodeLnthChngs.ctrl.(t{i}),1,'omitnan'),calcSEM(ALL.stats.NodeLnthChngs.ctrl.(t{i}),1),'Color',0.9.*colors{i},'LineWidth',2);
end
legend(t,'Location','southeast')
ylim([0.5 1.5])
box off
hold off

subplot(1,2,2)
hold on
t = {'i2c','i2t','t2c'};
for i=1:length(t)
    errorbar(mean(ALL.stats.NodeLnthChngs.cupr.(t{i}),1,'omitnan'),calcSEM(ALL.stats.NodeLnthChngs.cupr.(t{i}),1),'Color',0.9.*colors{i},'LineWidth',2);
end
% legend(t)
ylim([0.5 1.5])
hold off
figQuality(gcf,gca,[8 3])
end
