function [distStats,ctrlTerrPs,ctrlTerrStats,cuprTerrPs,cuprTerrStats] = makeFigure3(showplots,showstats,ctrlAvg,cuprAvg)
% MAKEFIGURE3 Creates graphs and numerical data for JOM & CLC et al Figure 2
% REQUIRES RUNNING SingleOLAnalysis FIRST IF ALL_########.mat DOES NOT
%   EXIST
% All panels for Figure 3 and associated Supplemental Figure are generated
%   within SingleOLAnalysis
% Generates panels a,b,c,D?,h,i,j,k,l and associated numerical data
% inputs:
%   showplots = 1 to generate data graphs, else 0
%   showstats = 1 to generate multcompare figs, else 0
%   include ctrlAvg, cuprAvg if already generated
if ispc
    slash = '\';
else
    slash = '/';
end
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
if showplots
    % panels a,b
    plotExample3Dvols(ctrlAvg,cuprAvg);
    % panel c
    distStats = plotDists_simple(ctrlAvg,cuprAvg,showstats);
    % panel i,j
    plotL1terr_cupr(cuprAvg);
    plotL1terr_ctrl(ctrlAvg);
    % panel g
    load('ALLsingleOLdata_20200203.mat','ALL');
    load('d14_MOBPM180411_2_Reg1_singleOL_1_edit2_traces.mat','xmlstruct');
    singlePolarizedSheathOverlay(ALL,xmlstruct);
    % panel h
    makeCircHistos(ALL);
    % panel #
    [ctrlTerrPs,ctrlTerrStats] = plotTerritoryOverlap_oneCond(ctrlAvg,1);
    [cuprTerrPs,cuprTerrStats] = plotTerritoryOverlap_oneCond(cuprAvg,2);
end
    function makeCircHistos(ALL)
        cond = {'ctrl' 'cupr'};
        for c = 1:length(cond)
            ALLalpha.(cond{c}) = [];
            an = fieldnames(ALL.(cond{c}));
            for a = 1:length(an)
                days = fieldnames(ALL.(cond{c}).(an{a}).raw);
                if any(contains(days,{'d14','d15'}))
                    p = [ALL.(cond{c}).(an{a}).raw.(days{end}).Sheath_Info.pnode1coords;...
                        ALL.(cond{c}).(an{a}).raw.(days{end}).Sheath_Info.pnode2coords];
                    nans = [];
                    for i = 1:length(p)
                        nans = [nans; sum(isnan(p{i}))];
                    end
                    p = p(~nans);
                    p = cell2mat(p);
                    p(:,3) = p(:,3).*-1;
                    center = getCenter(an{a});
                    center(3) = center(3)*-1;
                    p = p-center;
                    alpha = atan2(p(:,2),p(:,1));
                    mean_dir = circ_mean(alpha);
                    norm_p = [];
                    norm_p(:,1) = cos(-mean_dir).*p(:,1) - sin(-mean_dir).*p(:,2);
                    norm_p(:,2) = sin(-mean_dir).*p(:,1) + cos(-mean_dir).*p(:,2);
                end
            end
            edges = -4:0.1:4;
            idx = discretize(ALLalpha.(cond{c}),edges);
            bins = [];
            for j = 1:length(edges)
                bins = [bins; sum(idx==j)];
            end
            avgbins = mean(bins,2);
            avgBinnedAlpha.(cond{c}) = [];
            for j = 1:length(edges)
                avgBinnedAlpha.(cond{c}) = [avgBinnedAlpha.(cond{c}); zeros(round(avgbins(j)),1) + edges(j)];
            end
        end
        [c1,c2] = getFigColors;
        figure
        subplot(1,2,1)
        circ_plot(avgBinnedAlpha.ctrl,'hist','k',20,true,true,'linewidth',2,'color',c1);
        pRayleigh = circ_otest(avgBinnedAlpha.ctrl);
        title({'ctrl avg'; num2str(pRayleigh)})
        subplot(1,2,2)
        circ_plot(avgBinnedAlpha.cupr,'hist','k',20,true,true,'linewidth',2,'color',c2);
        pRayleigh = circ_otest(avgBinnedAlpha.cupr);
        title({'cupr avg'; num2str(pRayleigh)})
    end
end

