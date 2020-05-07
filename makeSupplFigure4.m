function [ng2_dataC, ng2table, ng2_ratios, ng2stats, gfap_dataC, gfaptable, gfap_ratios, gfapstats] = makeSupplFigure4(showplots,showstats)
%  MAKESUPPLFIGURE1 Creates graphs and numerical data for JOM & CLC et al Supplemental Figure 
% 1
% 
% Generates data panels (ng2 and gfap counts by depth 0-500 um) and associated 
% numerical data
% 
% inputs:
% 
% showplots = 1 to generate data graphs, else 0
% 
% showstats = 1 to generate multcompare figs, else 0
if ispc
    slash = '\';
else
    slash = '/';
end
[filepath,name] = fileparts(pwd);
if ~contains(name,'Orthmann-Murphy_Call_etal_2020_Elife')
    try 
        cd([filepath slash 'Orthmann-Murphy_Call_etal_2020_Elife'])
    catch ME
        error(['Change current folder to ' name])
    end
end
addpath(genpath(['.' slash 'MATLAB_code']));
bsln = [9 6.5 6.5 5.5 7; 9 8.5 6.5 4 2.5; 8 7 7 5.5 5;  10.5 7 7 4.5 5.5]';
c1 = [10.5 6.5 6 6.5 4.5; 10 10.5 6.5 5.5 7; 10.5 6.5 8 8 6.5; 9 4 5.5 4.5 4.5]';
c2 = [13 6.5 5.5 4 6.5; 13.5 6 5 3.5 4.5;  9.5 6  5.5 5  3.5; 12.5 5.5 6.5 5.5 3.5]'; 
c3 = [11.5 8.5 7 7.5 5.5;  7 9.5 9 7.5 7.5; 7 5.5 6.5 6.5 7; 8 7 8.67 6.67 7]'; 
c3r1 = [9 5.5 9 7 7; 8 8 8 6.5 6.5; 8.5 10.5 13.5 14.5 13.5; 16 5.5 12.5 8 10; 15 7 7 6.5 5.5; 10 9 8 6 5; 14 7 5.5 7.5 6.5; 8 9 5 9 8]';
c3r2 = [7.5 9.5 6.5 5 6; 9 6.5 7.5 4 6.5; 9.5 5 7 7 6.5; 10.5 7 9 8 6.5; 5 6.5 4 5.5 6]';
c3r3 = [13.5 5 5.5 5 8.5; 7.5 11 5 4 4.5]';
c3r5 = [13 7.5 9 9.5 7.5; 10 9 9.5 9 9; 12 9 9 6 8; 9.5 6 5.5 6.5 6.5]';
ng2stats = struct;
ng2_dataC = {bsln,c1,c2,c3,c3r1,c3r2,c3r3,c3r5};
% generate graph for all 500 microns analyzed (ng2 data)
avgs_ng2 = [mean(bsln,2),mean(c1,2),mean(c2,2),mean(c3,2),mean(c3r1,2),mean(c3r2,2),mean(c3r3,2),mean(c3r5,2)]; 
sems_ng2 = [calcSEM(bsln,2),calcSEM(c1,2),calcSEM(c2,2),calcSEM(c3,2),calcSEM(c3r1,2),calcSEM(c3r2,2),calcSEM(c3r3,2),calcSEM(c3r5,2)]; 
ng2table = table(avgs_ng2,sems_ng2,'VariableNames',{'avgs','sems'});
if showplots
    barwitherr(sems_ng2(1:5,:)',avgs_ng2(1:5,:)')
    xticklabels({'baseline' 'cup1wk' 'cup2wk' 'cup3wk' 'rec1wk' 'rec2wk' 'rec3wk' 'rec5wk'})
    legend({'0-100' '100-200' '200-300' '300-400' '400-500'})
    figQuality(gcf,gca,[5 2])
end
if showstats
    displayopt = 'on';
else
    displayopt = 'off';
end
% ng2 statistics
an = [];
tp = [];
depth = [];
count = 0;
d = [100;200;300;400;500];
for i = 1:8 %tps
    N = size(ng2_dataC{i},2);
    for n = 1 : N
        an = [an; repmat(n+count,5,1)];
    end
    depth = [depth; repmat(d,N,1)];
    tp = [tp; repmat(i,numel(ng2_dataC{i}),1)];
    count = count+N;
end
dataM = [bsln(:);c1(:);c2(:);c3(:);c3r1(:);c3r2(:);c3r3(:);c3r5(:)];
tbl = table(dataM,an,tp,depth,'VariableNames', {'numCells','animal','timepoint','depth'});
ng2stats.ng2_lme = fitlme(tbl,'numCells ~ depth*timepoint + (animal|timepoint)');
[~,ng2stats.anovatbl,ng2stats.anovastats] = anovan(dataM,{depth,an,tp},'varnames',{'depth','animal','timepoint'},'random',2,'model',[1 0 0; 0 0 1; 1 0 1],'Display',displayopt);
if showstats
    figure;
    multcompare(ng2stats.anovastats,'Dimension',1);
    figure;
    multcompare(ng2stats.anovastats,'Dimension',3);
end
% ng2 100:500 ratio
ng2_ratios = {bsln(end,:)./bsln(1,:) c1(end,:)./c1(1,:) c2(end,:)./c2(1,:) c3(end,:)./c3(1,:) c3r1(end,:)./c3r1(1,:)...
    c3r2(end,:)./c3r2(1,:) c3r3(end,:)./c3r3(1,:) c3r5(end,:)./c3r5(1,:)}; 
% ng2_ratios = {bsln(1,:)./bsln(end,:) c1(1,:)./c1(end,:) c2(1,:)./c2(end,:) c3(1,:)./c3(end,:) c3r1(1,:)./c3r1(end,:)...
%     c3r2(1,:)./c3r2(end,:) c3r3(1,:)./c3r3(end,:) c3r5(1,:)./c3r5(end,:)}; 
avgrat = zeros(size(ng2_ratios));
semrat = zeros(size(ng2_ratios));
tp = [];
for i = 1:length(ng2_ratios)
    avgrat(i) = mean(ng2_ratios{i});
    semrat(i) = calcSEM(ng2_ratios{i},2);
    tp = [tp; repmat(i,length(ng2_ratios{i}),1)];
end
if showplots
    figure
    errorbar(0:7,avgrat,semrat,'ko-','MarkerFaceColor','k');
    ylim([0 1.5])
    xlim([0 7])
    xticks(0:7)
    figQuality(gcf,gca,[4 1.6])
end
% allrats = [ng2_ratios{:}]';
% [~,ng2stats.rattbl,ng2stats.ratstats] = anova1(allrats,tp);
idx100 = depth==100;
idx500 = depth==500;
data100 = dataM(idx100);
data500 = dataM(idx500);
% TP = tp(idx100);
dataRat = data500./data100;
[~,ng2stats.ratioKWtbl,ng2stats.ratioKWstats] = kruskalwallis(dataRat,tp,displayopt);
if showstats
    figure
    ng2stats.multcomp = multcompare(ng2stats.ratioKWstats,'CType','lsd');
end
%% gfap count data
bsln = [10.5 6 4.5 2 1.5; 12 9.5 7 6 6.5; 15.5 10 6 2 3; 14.5 9 7 2 0]';
c1 = [13 15 9.5 4 0; 18.5 18 8.5 5.5 3; 23.5 18 8.5 5.5 3; 20 20 25 12.5 14.5]';
c2 = [19 20.5 16 12 7; 14.5 11 5.5 6.5 7; 16 14 8 5 5.5; 14 20.5 15 12.5 6]';
c3 = [7 11 9 9 8; 5 4 8 9 13; 11 6 8 5 6; 10 11 12 11 9]';
c3r1 = [20 19.5 26 30 26; 10.5 14 21.5 24.5 34.5; 23 17.5 13.5 11.5 6; 11.5 13.5 17 12 22; 15 15.5 19 25.5 23]';
c3r2 = [17 12.5 13 15.5 21; 10 13 10 13 14; 14.5 14 16 22 25.5; 16 17.5 15.5 13.5 18.5]';
c3r3 = [14 12 15.5 20.5 24.5; 13 18.5 15 17 12]';
c3r5 = [10.5 7.5 10 9.5 16.5; 15 11 14 8.5 15.5; 13.5 9.5 9 12 11; 7 4 6 8 7.5]';
gfap_dataC = {bsln,c1,c2,c3,c3r1,c3r2,c3r3,c3r5};
% generate graph for all 500 microns analyzed (gfap data)
avgs_gfap = [mean(bsln,2),mean(c1,2),mean(c2,2),mean(c3,2),mean(c3r1,2),mean(c3r2,2),mean(c3r3,2),mean(c3r5,2)];
sems_gfap = [calcSEM(bsln,2),calcSEM(c1,2),calcSEM(c2,2),calcSEM(c3,2),calcSEM(c3r1,2),calcSEM(c3r2,2),calcSEM(c3r3,2),calcSEM(c3r5,2)];
gfaptable = table(avgs_gfap,sems_gfap,'VariableNames',{'avgs','sems'});
if showplots
    figure;
    barwitherr(sems_gfap(1:5,:)',avgs_gfap(1:5,:)')
    xticklabels({'baseline' 'cup1wk' 'cup2wk' 'cup3wk' 'rec1wk' 'rec2wk' 'rec3wk' 'rec5wk'})
    legend({'0-100' '100-200' '200-300' '300-400' '400-500'})
    figQuality(gcf,gca,[5 2])
end
% gfap statistics
an = [];
tp = [];
depth = [];
count = 0;
d = [100;200;300;400;500];
for i = 1:8 %tps
    N = size(gfap_dataC{i},2);
    for n = 1 : N
        an = [an; repmat(n+count,5,1)];
    end
    depth = [depth; repmat(d,N,1)];
    tp = [tp; repmat(i,numel(gfap_dataC{i}),1)];
    count = count+N;
end
dataM = [bsln(:);c1(:);c2(:);c3(:);c3r1(:);c3r2(:);c3r3(:);c3r5(:)];
tbl = table(dataM,an,tp,depth,'VariableNames', {'numCells','animal','timepoint','depth'});
gfapstats.gfap_lme = fitlme(tbl,'numCells ~ depth*timepoint + (animal|timepoint)');
[~,gfapstats.anovatbl,gfapstats.anovastats] = anovan(dataM,{depth,an,tp},'varnames',{'depth','animal','timepoint'},'random',2,'model',[1 0 0; 0 0 1; 1 0 1],'Display',displayopt);
if showstats
    figure;
    multcompare(gfapstats.anovastats,'Dimension',1);
    figure;
    multcompare(gfapstats.anovastats,'Dimension',3);
end
% gfap 100+200:400+500 ratio
gfap_ratios = {bsln(end,:)./bsln(1,:) c1(end,:)./c1(1,:) c2(end,:)./c2(1,:) c3(end,:)./c3(1,:)...
    c3r1(end,:)./c3r1(1,:) c3r2(end,:)./c3r2(1,:) c3r3(end,:)./c3r3(1,:) c3r5(end,:)./c3r5(1,:)}; 
% gfap_ratios = {sum(bsln(end-1:end,:))./sum(bsln(1:2,:)) sum(c1(end-1:end,:))./sum(c1(1:2,:)) sum(c2(end-1:end,:))./sum(c2(1:2,:)) sum(c3(end-1:end,:))./sum(c3(1:2,:))...
%     sum(c3r1(end-1:end,:))./sum(c3r1(1:2,:)) sum(c3r2(end-1:end,:))./sum(c3r2(1:2,:)) sum(c3r3(end-1:end,:))./sum(c3r3(1:2,:)) sum(c3r5(end-1:end,:))./sum(c3r5(1:2,:))}; 
avgrat = zeros(size(gfap_ratios));
semrat = zeros(size(gfap_ratios));
tp = [];
for i = 1:length(gfap_ratios)
    avgrat(i) = mean(gfap_ratios{i});
    semrat(i) = calcSEM(gfap_ratios{i},2);
    tp = [tp; repmat(i,length(gfap_ratios{i}),1)];
end
if showplots
    figure
    errorbar(0:7,avgrat,semrat,'ko-','MarkerFaceColor','k');
    xlim([0 7])
    xticks(0:7)
    ylim([0 3])
    figQuality(gcf,gca,[4 1.6])
end
% allrats = [gfap_ratios{:}]';
% [~,gfapstats.rattbl,gfapstats.ratstats] = anova1(allrats,tp);
idx100 = depth==100;
idx500 = depth==500;
data100 = dataM(idx100);
data500 = dataM(idx500);
% TP = tp(idx100);
dataRat = data500./data100;
[~,gfapstats.ratioKWtbl,gfapstats.ratioKWstats] = kruskalwallis(dataRat,tp,displayopt);
if showstats
    figure
    gfapstats.multcomp = multcompare(gfapstats.ratioKWstats,'CType','lsd');
end
end