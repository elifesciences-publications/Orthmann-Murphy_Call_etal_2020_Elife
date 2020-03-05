function [ALL, psBFC, stats] = plotExtVRet(ALL)
    cond_names = {'ctrl';'cupr'};
    ALL.stats.extVret = struct;
    for c = 1:length(cond_names)
        ALL.stats.extVret.(cond_names{c}).ext = [];
        ALL.stats.extVret.(cond_names{c}).exttot = [];
        ALL.stats.extVret.(cond_names{c}).ret = [];
        ALL.stats.extVret.(cond_names{c}).rettot = [];
        ALL.stats.extVret.(cond_names{c}).extlnth = [];
        ALL.stats.extVret.(cond_names{c}).retlnth = [];
        fields = fieldnames(ALL.(cond_names{c}));
        for i = 1:length(fields)
            diffs = ALL.(cond_names{c}).(fields{i}).net_sheath_LengthDiffs;
            ext_diffs = diffs(diffs > 0);
            ret_diffs = diffs(diffs < 0);
            ALL.stats.extVret.(cond_names{c}).ext = [ALL.stats.extVret.(cond_names{c}).ext; ext_diffs];
            ALL.stats.extVret.(cond_names{c}).extlnth = [ALL.stats.extVret.(cond_names{c}).extlnth; mean(ext_diffs,'omitnan')];
            ALL.stats.extVret.(cond_names{c}).exttot = [ALL.stats.extVret.(cond_names{c}).exttot, length(ext_diffs)];
            ALL.stats.extVret.(cond_names{c}).ret = [ALL.stats.extVret.(cond_names{c}).ret; ret_diffs];
            ALL.stats.extVret.(cond_names{c}).retlnth = [ALL.stats.extVret.(cond_names{c}).retlnth; abs(mean(ret_diffs,'omitnan'))];
            ALL.stats.extVret.(cond_names{c}).rettot = [ALL.stats.extVret.(cond_names{c}).rettot, length(ret_diffs)];
        end
    end
[c1,c2] = getFigColors;
    % average number of exts/rets per cell
    ctrlSEM = [calcSEM(ALL.stats.extVret.ctrl.exttot); calcSEM(ALL.stats.extVret.ctrl.rettot)]; %check direction for matrix
    cuprSEM = [calcSEM(ALL.stats.extVret.cupr.exttot); calcSEM(ALL.stats.extVret.cupr.rettot)];
    ctrlAVG = [mean(ALL.stats.extVret.ctrl.exttot); mean(ALL.stats.extVret.ctrl.rettot)];
    cuprAVG = [mean(ALL.stats.extVret.cupr.exttot); mean(ALL.stats.extVret.cupr.rettot)];
    avg = [ctrlAVG,cuprAVG];
    sem = [ctrlSEM,cuprSEM];
    data = [ALL.stats.extVret.ctrl.exttot, ALL.stats.extVret.ctrl.rettot, ALL.stats.extVret.cupr.exttot, ALL.stats.extVret.cupr.rettot]';
    Lct = size(ALL.stats.extVret.ctrl.exttot,2);
    Lcu = size(ALL.stats.extVret.cupr.exttot,2);
    idx = [ones(Lct,1).*0.85; ones(Lcu,1).*1.85;...
           ones(Lct,1).*1.15; ones(Lcu,1).*2.15];
    xes = [1 2];
    coloridx = {c1,c2,c1,c2};
    subplot(2,1,1)
    errorbarbar(xes,avg,sem,{'EdgeColor','k','FaceColor','none'},{'k','LineStyle','none'});
    hold on
    plotSpread(data,'distributionIdx',idx,'distributionMarkers',{'o'},'distributionColors',coloridx);
    ylabel('number of net extensions/retractions');
%     legend({'control' 'remyelinating'})
    xticks([1 2])
    xticklabels({'extensions' 'retractions'})
    box off;
    
    % average length of exts/rets per cell
    ctrlSEM = [calcSEM(ALL.stats.extVret.ctrl.extlnth'); calcSEM(ALL.stats.extVret.ctrl.retlnth')]; 
    cuprSEM = [calcSEM(ALL.stats.extVret.cupr.extlnth'); calcSEM(ALL.stats.extVret.cupr.retlnth')];
    ctrlAVG = [mean(ALL.stats.extVret.ctrl.extlnth); mean(ALL.stats.extVret.ctrl.retlnth)];
    cuprAVG = [mean(ALL.stats.extVret.cupr.extlnth); mean(ALL.stats.extVret.cupr.retlnth)];
    subplot(2,1,2)
    avg = [ctrlAVG,cuprAVG];
    sem = [ctrlSEM,cuprSEM];
    data = [ALL.stats.extVret.ctrl.extlnth; ALL.stats.extVret.ctrl.retlnth; ALL.stats.extVret.cupr.extlnth; ALL.stats.extVret.cupr.retlnth];
    Lct = size(ALL.stats.extVret.ctrl.extlnth,1);
    Lcu = size(ALL.stats.extVret.cupr.extlnth,1);
    idx = [ones(Lct,1).*0.85; ones(Lcu,1).*1.85;...
           ones(Lct,1).*1.15; ones(Lcu,1).*2.15];
    xes = [1 2];
    coloridx = {c1,c2,c1,c2};
    errorbarbar(xes,avg,sem,{'EdgeColor','k','FaceColor','none'},{'k','LineStyle','none'});
    hold on
    plotSpread(data,'distributionIdx',idx,'distributionMarkers',{'o'},'distributionColors',coloridx);
%     title('average length of net extensions/retractions per cell')
    ylabel('length of net extensions/retractions (\mum)');
    xticks([1 2])
    xticklabels({'extensions' 'retractions'})
    figQuality(gcf,gca,[2 3.8])
    
    [~,pNumExt,~,stats.NumExt] = ttest2(ALL.stats.extVret.ctrl.exttot,ALL.stats.extVret.cupr.exttot);
    [~,pNumRet,~,stats.NumRet] = ttest2(ALL.stats.extVret.ctrl.rettot,ALL.stats.extVret.cupr.rettot);
    [~,pLnthExt,~,stats.LnthExt] = ttest2(ALL.stats.extVret.ctrl.extlnth,ALL.stats.extVret.cupr.extlnth);
    [~,pLnthRet,~,stats.LnthRet] = ttest2(ALL.stats.extVret.ctrl.retlnth,ALL.stats.extVret.cupr.retlnth);
    [~,pCtrl_extVretNum,~,stats.ctrl_extVretNum] = ttest2(ALL.stats.extVret.ctrl.exttot, ALL.stats.extVret.ctrl.rettot);
    [~,pCupr_extVretNum,~,stats.cupr_extVretNum] = ttest2(ALL.stats.extVret.cupr.exttot, ALL.stats.extVret.cupr.rettot);
    [~,pCtrl_extVretLnth,~,stats.ctrl_extVretLnth] = ttest2(ALL.stats.extVret.ctrl.extlnth, ALL.stats.extVret.ctrl.retlnth);
    [~,pCupr_extVretLnth,~,stats.cupr_extVretLnth] = ttest2(ALL.stats.extVret.cupr.extlnth, ALL.stats.extVret.cupr.retlnth);
    
    ps = [pNumExt,pNumRet,pLnthExt,pLnthRet,pCtrl_extVretNum,pCupr_extVretNum,pCtrl_extVretLnth,pCupr_extVretLnth].*8;
    psBFC = table(ps(1),ps(2),ps(3),ps(4),ps(5),ps(6),ps(7),ps(8),'VariableNames',{'pNumExt','pNumRet','pLnthExt','pLnthRet','pCtrl_extVretNum','pCupr_extVretNum','pCtrl_extVretLnth','pCupr_extVretLnth'});
end
        