function [Fig1hi_datatable, Fig1jk_datatable, stats, ctrlAvg, cuprAvg] = makeFigure1(showplots,showstats,ctrlAvg,cuprAvg)
%  MAKEFIGURE1 Creates graphs and numerical data for JOM & CLC et al Figure 1.
% 
% Generates Fig 1 panels h, i, j, k and associated numerical data
% 
% inputs:
% 
% ctrlAvg: optional if already generated from running code once
% 
% cuprAvg: as above
% 
% showplots = 1 to generate data graphs, else 0
% 
% showstats = 1 to generate multcompare figs, else 0
if ispc
    slash = '\';
else
    slash = '/';
end
[~,name] = fileparts(pwd);
if ~contains(name,'Remyelination Manuscript Code Jan 2020') 
    cd(['..' slash]);
    [~,name] = fileparts(pwd);
    if ~contains(name,'Remyelination Manuscript Code Jan 2020') 
        error(['Change current folder to ' name])
    end
end
addpath(['.' slash]);
addpath(['.' slash 'FinalDataStructs']);
addpath(genpath(['.' slash 'MATLAB_code']));
if nargin==2
    cd(['FinalDataStructs' slash]);
    load('cupr_notAveraged.mat', 'cupr');
    cuprAvg = averageQuads(cupr);
    cuprAvg = averageConds(cuprAvg);
    clear cupr
    load('ctrl_notAveraged.mat', 'ctrl');
    ctrlAvg = averageQuads_ctrl(ctrl);
    ctrlAvg = averageConds_ctrl(ctrlAvg);
    clear ctrl
end
% panels h-i
if showplots
    plotOverall(ctrlAvg,cuprAvg);
end
[~,totNperwk_ctrl] = getNperwk(ctrlAvg);
[~,totNperwk_cupr] = getNperwk(cuprAvg);
cta = ctrlAvg.avg.WKdataProp;
cts = ctrlAvg.sem.WKdataProp;
cua = cuprAvg.avg.WKdataProp;
cus = cuprAvg.sem.WKdataProp;
wktots_ctrl = [cta(:,1), cts(:,1)];
wktots_cupr = [cua(:,1), cus(:,1)];
cumwknew_ctrl = [cta(:,5), cts(:,5)];
cumwknew_cupr = [cua(:,5), cus(:,5)];
cumwkloss_ctrl = [cta(:,4), cts(:,4)];
cumwkloss_cupr = [cua(:,4), cus(:,4)];
% panels j-k
if showplots
    plotWKrates(ctrlAvg,cuprAvg);
end
lossrates_cup = [cuprAvg.avg.WKdataProp(2:10,2).*-1, cuprAvg.sem.WKdataProp(2:10,2)];
newrates_cup = [cuprAvg.avg.WKdataProp(2:10,3), cuprAvg.sem.WKdataProp(2:10,3)];
lossrates_ctl = [ctrlAvg.avg.WKdataProp(2:10,2), ctrlAvg.sem.WKdataProp(2:10,2)];
newrates_ctl = [ctrlAvg.avg.WKdataProp(2:10,3), ctrlAvg.sem.WKdataProp(2:10,3)];
Fig1hi_datatable = table(totNperwk_ctrl', wktots_ctrl, cumwknew_ctrl, cumwkloss_ctrl, totNperwk_cupr', wktots_cupr, cumwknew_cupr, cumwkloss_cupr);
Fig1jk_datatable = table(lossrates_ctl, newrates_ctl, lossrates_cup, newrates_cup);
%% ctrl vs cupr loss/new stats for recovery time points
stats = struct;
for type = 2:3 %2 = loss rate; 3 = new rate
    %     if type==2
    start = 2;
    n = 9;
    %     else
    %         start = 5;
    %         n = 5;
    %     end
    Mctrl = [];
    Mcupr = [];
    ctrfields = fieldnames(ctrlAvg);
    ctrfields = ctrfields(1:end-2);
    cupfields = fieldnames(cuprAvg);
    cupfields = cupfields(1:end-2);
    bsln_ct = [];
    bsln_cu = [];
    for f = 1:length(ctrfields)
        bsln = ctrlAvg.(ctrfields{f}).avgquad.WKdataProp(start-1,1);
        bsln_ct = [bsln_ct; bsln];
        if type==2
            bsln = -bsln;
        end
        Mctrl = [Mctrl ctrlAvg.(ctrfields{f}).avgquad.WKdataProp(start:n+1,type)]; % - bsln];
    end
    for f = 1:length(cupfields)
        bsln = cuprAvg.(cupfields{f}).avgquad.WKdataProp(start-1,1);
        bsln_cu = [bsln_cu; bsln];
        if type==2
            bsln = -bsln;
        end
        Mcupr = [Mcupr cuprAvg.(cupfields{f}).avgquad.WKdataProp(start:n+1,type)]; % - bsln];
    end
    Mctrl = Mctrl';
    Mcupr = Mcupr';
    M = [Mctrl;Mcupr];
    M = M(:);
    bsln = repmat([bsln_ct; bsln_cu],n,1);
    cond = repmat([repmat({'ctrl'},size(Mctrl,1),1); repmat({'cupr'},size(Mcupr,1),1)],n,1);
    wks = [];
    for i=1:n
        wks = [wks; ones(size(Mctrl,1)+size(Mcupr,1),1).*i];
    end
    an = repmat([ctrfields; cupfields],n,1);
    tbl = table(M,cond,wks,an);
    tbl.cond = nominal(tbl.cond);
    tbl.an = nominal(tbl.an);
    nandex = isnan(tbl.M);
    tbl(nandex,:) = [];
    ps = [];
    if type ==2
        stats.loss_lme = fitlme(tbl, 'M ~ cond*wks + (wks|an)');
        stats.loss_anova = anova(stats.loss_lme);
        for i = 1:n
            [~,p] = ttest2(Mctrl(:,i),Mcupr(:,i));
            ps = [ps p.*n]; % bonferroni correction (reject null if result < 0.05)
        end
        stats.loss_ps_bonferroni = ps;
        [~, stats.loss_anovatbl, stats.loss_anovastats] = anovan(M,{an,wks,cond},'varnames',{'animal','timepoint','condition'},'random',1,'model',[0 1 0; 0 0 1; 0 1 1]);
        if showstats
            figure
            multcompare(stats.loss_anovastats,"Dimension",[2,3]);
        end
    else
        stats.new_lme = fitlme(tbl, 'M ~ cond*wks + (wks|an)');
        stats.new_anova = anova(stats.new_lme);
        for i = 1:n
            [~,p] = ttest2(Mctrl(:,i),Mcupr(:,i));
            ps = [ps p.*n]; % bonferroni correction (reject null if result < 0.05)
        end
        stats.new_ps_bonferroni = ps;
        [~, stats.new_anovatbl, stats.new_anovastats] = anovan(M,{an,wks,cond},'varnames',{'animal','timepoint','condition'},'random',1,'model',[0 1 0; 0 0 1; 0 1 1]);
        if showstats
            figure
            multcompare(stats.new_anovastats,"Dimension",[2,3]);
        end
    end
end
end