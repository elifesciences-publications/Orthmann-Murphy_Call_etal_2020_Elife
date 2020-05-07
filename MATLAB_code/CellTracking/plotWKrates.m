function plotWKrates(ctrl,cupr,intrv)
ctlEnd = 10;
cupEnd = 10;
intEnd = 9;
[c1, c2] = getFigColors;
figure
title('lost rate')
avglostcupr = [0;cupr.avg.WKdataProp(2:cupEnd,2).*-1];
semlostcupr = [0;cupr.sem.WKdataProp(2:cupEnd,2)];
avglostctrl = [0;ctrl.avg.WKdataProp(2:ctlEnd,2).*-1];
semlostctrl = [0;ctrl.sem.WKdataProp(2:ctlEnd,2)];
if nargin==3
    firstplotline = '-';
    firstplotlinecolor = c2;
    firstplotcolor = c2;
    secondplotlinecolor = c3;
    secondplotcolor = c3;
else
    firstplotline = '-';
    firstplotlinecolor = c1;
    firstplotcolor = c1;
    secondplotlinecolor = c2;
    secondplotcolor = c2;
end
errorbar(0:ctlEnd-1,avglostctrl,semlostctrl,firstplotline,'Color',firstplotlinecolor,'Marker','s','MarkerFaceColor',firstplotcolor)
hold on
errorbar(0:cupEnd-1,avglostcupr,semlostcupr,'Color',secondplotlinecolor,'Marker','s','MarkerFaceColor',secondplotcolor)
if nargin==3
    avglostintrv = [0;intrv.avg.WKdataProp(2:intEnd,2).*-1];
    semlostintrv = [0;intrv.sem.WKdataProp(2:intEnd,2)];
    errorbar(0:intEnd-1,avglostintrv,semlostintrv,'Color',c4,'Marker','s','MarkerFaceColor',c4);
end
ylabel('rate of loss (proportion of baseline/week)')
ylim([-0.4 0])
xticks(0:cupEnd-1)
xticklabels({'0' '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12'})
xlabel('weeks from baseline')
hold off
figQuality(gcf,gca,[3.6 2])

figure 
title('new rate')
avgnewcupr = [0;cupr.avg.WKdataProp(2:cupEnd,3)];
semnewcupr = [0;cupr.sem.WKdataProp(2:cupEnd,3)];
avgnewctrl = [0;ctrl.avg.WKdataProp(2:ctlEnd,3)];
semnewctrl = [0;ctrl.sem.WKdataProp(2:ctlEnd,3)];
errorbar(0:ctlEnd-1,avgnewctrl,semnewctrl,firstplotline,'Color',firstplotlinecolor,'Marker','s','MarkerFaceColor',firstplotcolor)
hold on
errorbar(0:cupEnd-1,avgnewcupr,semnewcupr,'Color',secondplotlinecolor,'Marker','s','MarkerFaceColor',secondplotcolor)
if nargin==3
    avgnewintrv = [0;intrv.avg.WKdataProp(2:intEnd,3)];
    semnewintrv = [0;intrv.sem.WKdataProp(2:intEnd,3)];
    errorbar(0:intEnd-1,avgnewintrv,semnewintrv,'Color',c4,'Marker','s','MarkerFaceColor',c4);
end
ylabel('rate of addition (proportion of baseline/week)')
xticks(0:cupEnd-1)
xticklabels({'0' '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12'})
xlabel('weeks from baseline')
ylim([0 .3])
hold off
figQuality(gcf,gca,[3.6 2])
% an = fieldnames(ctrl);
% for i = 1:length(an)
%     coefCtrl = polyfit(4:6, avgnewctrl(4:6)', 1);
%     slopeCtrl = coefCtrl(1);
% end
% coefCupr = polyfit(4:6, avgnewcupr(4:6)', 1);
% slopeCupr = coefCupr(1);
% end

% %% Stats for recovery time points
% if nargin==2
%     start = 2;
%     n = 8;
% else
%     start = 5;
%     n = 5;
% end
% for type = 2:3 %2 = loss rate; 3 = new rate
%     Mctrl = [];
%     Mcupr = [];
%     Mintr = [];
%     ctrfields = fieldnames(ctrl);
%     cupfields = fieldnames(cupr);
%     for f = 1:length(ctrfields)-2
%         Mctrl = [Mctrl ctrl.(ctrfields{f}).avgquad.WKdataProp(start:9,type)];
%     end
%     for f = 1:length(cupfields)-2
%         Mcupr = [Mcupr cupr.(cupfields{f}).avgquad.WKdataProp(start:9,type)];
%     end
%     if nargin==3
%         intfields = fieldnames(intrv);
%         for f = 1:length(intfields)-2
%             Mintr = [Mintr intrv.(intfields{f}).avgquad.WKdataProp(start:9,type)];
%         end
%         Mintr = Mintr';
%     end
%     Mctrl = Mctrl';
%     Mcupr = Mcupr';
%     group = [ones(size(Mctrl,1),1); 2.*ones(size(Mcupr,1),1); 3.*ones(size(Mintr,1),1)];
%     M = [Mctrl;Mcupr;Mintr];
%     if nargin == 2
%         t = table(group,M(:,1),M(:,2),M(:,3),M(:,4),M(:,5),M(:,6),M(:,7),M(:,8),...
%             'VariableNames',{'bin','trt1','trt2','trt3','rec1','rec2','rec3','rec4','rec5'});
%         rectp = table([1 2 3 4 5 6 7 8]','VariableNames',{'tp'});
%         rm = fitrm(t,'trt1-rec5~bin','WithinDesign',rectp);
%     else 
%         t = table(group,M(:,1),M(:,2),M(:,3),M(:,4),M(:,5),...
%             'VariableNames',{'bin','rec1','rec2','rec3','rec4','rec5'});
%         rectp = table([1 2 3 4 5]','VariableNames',{'rectp'});
%         rm = fitrm(t,'rec1-rec5~bin','WithinDesign',rectp);
%     end
%     mauchly(rm)
%     ranova(rm)
% %     group1 = ones(size(Mctrl));
% %     group2 = 2.*ones(size(Mcupr));
% %     group3 = 3.*ones(size(Mcupr));
% %     tpstemp = ones(size(Mctrl,1),1);
% %     tps = [tpstemp; 2.*tpstemp; 3.*tpstemp; 4.*tpstemp; 5.*tpstemp];
% %     tpstemp = ones(size(Mcupr,1),1);
% %     tps = [tps; tpstemp; 2.*tpstemp; 3.*tpstemp; 4.*tpstemp; 5.*tpstemp];
% %     tpstemp = ones(size(Mintr,1),1);
% %     tps = [tps; tpstemp; 2.*tpstemp; 3.*tpstemp; 4.*tpstemp; 5.*tpstemp];
% %     [panov,tbl,stats] = anovan([Mctrl(:);Mcupr(:);Mintr(:)], {[group1(:); group2(:); group3(:)], tps})
% %     figure; 
% %     multcompare(stats,'Dimension',[1,2]);
%     for i = 1:n
%         [~,p] = ttest2(Mctrl(:,i),Mcupr(:,i));
%         if nargin==3
%             [~,p2] = ttest2(Mctrl(:,i),Mintr(:,i));
%         else
%             p2 = [];
%         end
%         [p*5 p2*5] %#ok<NOPRT> % bonferroni correction (reject null if result < 0.05)
%     end
end