function ALL = calcProcLosses(ALL)
    cond_names = {'ctrl','cupr'};
    for k = 1:length(cond_names)
        ALL.stats.procLosses.(cond_names{k}) = [];
        fields = fieldnames(ALL.(cond_names{k}));
        for i = 1:length(fields)
            tps = size(ALL.(cond_names{k}).(fields{i}).proc_LengthDiffs,2);
            if tps < 7
                T_loss_tp = [sum(ALL.(cond_names{k}).(fields{i}).proc_LengthDiffs,'omitnan'), NaN(1,7-tps)];
                T_loss_net = sum(T_loss_tp,'omitnan');
                ALL.stats.procLosses.(cond_names{k}) = [ALL.stats.procLosses.(cond_names{k}); T_loss_tp, T_loss_net];        
            else
                T_loss_tp = sum(ALL.(cond_names{k}).(fields{i}).proc_LengthDiffs,'omitnan');
                T_loss_net = sum(T_loss_tp,'omitnan');
                ALL.stats.procLosses.(cond_names{k}) = [ALL.stats.procLosses.(cond_names{k}); T_loss_tp, T_loss_net];
            end
        end
    end
    [c1,c2] = getFigColors;
    figure('Name','Average Loss in Process Length')
    xNames = {'de novo','remyelinating'};
    sems = [std(ALL.stats.procLosses.ctrl(:,end),'omitnan')./sqrt(length(fieldnames(ALL.ctrl))) ,... 
        std(ALL.stats.procLosses.cupr(:,end),'omitnan')./sqrt(length(fieldnames(ALL.cupr)))];
    
    ctrlLoss = ALL.stats.procLosses.ctrl;
    cuprLoss = ALL.stats.procLosses.cupr;
    [ctrlLoss,cuprLoss] = forceConcat(ctrlLoss,cuprLoss,1);

    raw_data = [abs(ctrlLoss(:,end)) , abs(cuprLoss(:,end))];
    plotSpread(raw_data,'distributionMarkers',{'o'},'distributionColors',{c1,c2},'xNames',xNames) 
    hold on
    title('length lost in processes')
    ylabel('average length lost per cell (\mum)')
    ctrl_avg = abs(mean(ctrlLoss(:,end),'omitnan'));
    cupr_avg = abs(mean(cuprLoss(:,end),'omitnan'));
    data = [ctrl_avg, cupr_avg];
    bar(data,'FaceColor','none','EdgeColor','k','LineWidth',1.5)
    errorbar(1,ctrl_avg,sems(1),'k');
    errorbar(2,cupr_avg,sems(2),'k');
    hold off

    figQuality(gcf,gca,[4 3])
    % export_fig('.\EPS_Panels\AvgProcLosses.eps',gcf);
    [~,p_procLoss,~,stats_procLoss] = ttest2(raw_data(:,1),raw_data(:,2))
end