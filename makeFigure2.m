function [stats,ctrldata,cuprdata,depthData,ctrlAvg,cuprAvg] = makeFigure2(showplots,showquadplots,showstats,ctrlAvg,cuprAvg)
% MAKEFIGURE2 Creates graphs and numerical data for JOM & CLC et al Figure 2
% Generates all data panels and associated numerical data
% inputs:
% showplots = 1 to generate data graphs, else 0
% showquadplots = 1 to generate timepoint plots for all quads analyzed,
% else 0
% showstats = 1 to generate multcompare figs, else 0
if ispc
    slash = '\';
else
    slash = '/';
end
[~,name] = fileparts(pwd);
if ~contains(name,'Orthmann-Murphy_Call_etal_2020_Elife') 
    cd('..');
    [~,name] = fileparts(pwd);
    if ~contains(name,'Orthmann-Murphy_Call_etal_2020_Elife') 
        error(['Change current folder to ' name])
    end
end
addpath('.');
addpath(fullfile('.','FinalDataStructs'));
addpath(genpath(fullfile('.','MATLAB_code')));
if nargin<4
    cd('FinalDataStructs');
    load('cupr_notAveraged.mat', 'cupr');
    cuprAvg = averageQuads(cupr);
    cuprAvg = averageConds(cuprAvg);
    clear cupr
    load('ctrl_notAveraged.mat', 'ctrl');
    ctrlAvg = averageQuads_ctrl(ctrl);
    ctrlAvg = averageConds_ctrl(ctrlAvg);
    clear ctrl
end
if showplots
    [ctrldata.avgDeath,ctrldata.semDeath,ctrldata.avgNew,ctrldata.semNew] = plotByBin(ctrlAvg,'ctrl');
    [cuprdata.avgDeath,cuprdata.semDeath,cuprdata.avgNew,cuprdata.semNew] = plotByBin(cuprAvg,'cupr');
    [ctrldata.avglost3,ctrldata.semlost3,ctrldata.avglost1,ctrldata.semlost1,ctrldata.avgnew3,ctrldata.semnew3,ctrldata.avgnew1,ctrldata.semnew1] = plotWKrates_cuprL1vL3(ctrlAvg,'ctrl');
    [cuprdata.avglost3,cuprdata.semlost3,cuprdata.avglost1,cuprdata.semlost1,cuprdata.avgnew3,cuprdata.semnew3,cuprdata.avgnew1,cuprdata.semnew1] = plotWKrates_cuprL1vL3(cuprAvg,'cupr');
    [cuprdata.rawavg1,cuprdata.rawsem1,cuprdata.rawavg2,cuprdata.rawsem2,cuprdata.rawavg3,cuprdata.rawsem3,cuprdata.rawanovan] = plotRawCellNumberPerBin(cuprAvg,showstats);
    depthData = Fig2_NewCellDistrPlotsHistos_all(cuprAvg,showquadplots); %used r033 in fig
end
conds = {'ctrl','cupr'};
stats = struct;
stats.ctrl = [];
stats.cupr = [];
for c = 1:2
    cond = conds{c};
    if c==1
        in = ctrlAvg;
    else
        in = cuprAvg;
    end
    for type = 2:3 %2 = loss rate; 3 = new rate
        if type==2
            start = 4;
            n = 3;
        else
            start = 5;
            n = 2;
        end
        M1 = [];
        M3 = [];
        fields = fieldnames(in);
        fields = fields(1:end-2);
        for f = 1:length(fields)
            M1 = [M1 in.(fields{f}).avgquad.BinnedWKdataProp(start:start+n,type,1,1)];
            M3 = [M3 in.(fields{f}).avgquad.BinnedWKdataProp(start:start+n,type,1,3)];
        end
        M1 = M1';
        M3 = M3';
        M = [M1;M3];
        M = M(:);
        layer = repmat([repmat({'L1'},size(M1,1),1); repmat({'L3'},size(M3,1),1)],n+1,1);
        wks = [];
        for i=1:n+1
            wks = [wks; ones(size(M1,1)+size(M3,1),1).*i];
        end
        an = [repmat(fields,n+1,1); repmat(fields,n+1,1)];
        tbl = table(M,layer,wks,an);
        tbl.layer = nominal(tbl.layer);
        tbl.an = nominal(tbl.an);
        nandex = isnan(tbl.M);
        tbl(nandex,:) = [];
        ps = [];
        if type ==2
            stats.(cond).loss_lme = fitlme(tbl, 'M ~ layer*wks + (wks|an)');
            if showstats
                displ = 'on';
            else
                displ = 'off';
            end
            [~,anovatbl,anovastats] = anovan(M,{layer,an,wks},'varnames',{'layer','animal','timepoint'},'random',2,'model',[1 0 0; 0 0 1; 1 0 1],'display',displ);
            stats.(cond).loss_anovatbl = anovatbl;
            stats.(cond).loss_anovastats = anovastats;
            if showstats
                figure
                multcompare(anovastats,'Dimension',[1 3]);
            end
            for i = 1:n+1
                [~,p] = ttest2(M1(:,i),M3(:,i));
                ps = [ps p.*(n+1)]; % bonferroni correction (reject null if result < 0.05)
            end
            stats.(cond).loss_ps_bonferroni = ps;
        else
            stats.(cond).new_lme = fitlme(tbl, 'M ~ layer*wks + (wks|an)');
            [~,anovatbl,anovastats] = anovan(M,{layer,an,wks},'varnames',{'layer','animal','timepoint'},'random',2,'model',[1 0 0; 0 0 1; 1 0 1],'display',displ);
            stats.(cond).new_anovatbl = anovatbl;
            stats.(cond).new_anovastats = anovastats;
            if showstats
                figure
                multcompare(anovastats,'Dimension',[1 3]);
            end
            for i = 1:n+1
                [~,p] = ttest2(M1(:,i),M3(:,i));
                ps = [ps p.*(n+1)]; % bonferroni correction (reject null if result < 0.05)
            end
            stats.(cond).new_ps_bonferroni = ps;
        end
    end
end