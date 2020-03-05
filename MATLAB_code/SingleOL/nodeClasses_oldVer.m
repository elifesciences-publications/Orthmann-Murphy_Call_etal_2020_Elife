function ALL = nodeClasses_oldVer(ALL)
    cond = {'ctrl','cupr'};
    ALL.stats.nodeClassLasts = [];
    ALL.stats.nodeClassBslns = [];
    for c = 1:2
        cells = fieldnames(ALL.(cond{c}));
        ALL.stats.NodeClassLnths_bsln.(cond{c}) = [];
        ALL.stats.NodeClassLnths_last.(cond{c}) = [];
        ALL.stats.NodeClassTots_bsln.(cond{c}) = [];
        ALL.stats.NodeClassTots_last.(cond{c}) = [];
        ALL.stats.lostIntClass.(cond{c}) = [];
        ALL.stats.lostIntClassProp.(cond{c}) = [];
        ALL.stats.i2tc_LnthChng.(cond{c}) = [];
        ALL.stats.i2t_LnthChngs.(cond{c}) = [];
        ALL.stats.i2c_LnthChngs.(cond{c}) = [];
        ALL.stats.i2i_LnthChngs.(cond{c}) = [];
        ALL.stats.t2c_LnthChngs.(cond{c}) = [];
        ALL.stats.isolDynam.(cond{c}) = [];
        ALL.stats.isolStbl.(cond{c}) = [];
        for k = 1:length(cells)
            nodes = ALL.(cond{c}).(cells{k}).nodeClassPerTP;
            lnths = ALL.(cond{c}).(cells{k}).sheathLengthPerTP;
            temp = lnths==0;
            lostIdx = any(temp,2);
            mostnbrs = max(nodes(lostIdx,:),[],2,'omitnan');
            numIsol = sum(max(nodes,[],2)==3);
            numTerm = sum(max(nodes,[],2)==4);
            numCont = sum(max(nodes,[],2)==5);
            isolClass = sum(any(mostnbrs==3,2));
            termClass = sum(any(mostnbrs==4,2));
            contClass = sum(any(mostnbrs==5,2));
            % numbers of internodes lost per class
            ALL.stats.lostIntClass.(cond{c}) = [ALL.stats.lostIntClass.(cond{c}); isolClass termClass contClass];
            % proportions of internodes per class
            isolProp = isolClass./numIsol;
            termProp = termClass./numTerm;
            contProp = contClass./numCont;
            ALL.stats.lostIntClassProp.(cond{c}) = [ALL.stats.lostIntClassProp.(cond{c}); isolProp termProp contProp];
            % parsing dynamic internodes
            i2t = nodes(:,1)==3 & nodes(:,end)==4;
            i2t_lnths = lnths(i2t,:);
            i2t_netchng = i2t_lnths(:,end) - i2t_lnths(:,1);
            i2c = nodes(:,1)==3 & nodes(:,end)==5;
            i2c_lnths = lnths(i2c,:);
            i2c_netchng = i2c_lnths(:,end) - i2c_lnths(:,1);
            t2c = nodes(:,1)==4 & nodes(:,end)==5;
            t2c_lnths = lnths(t2c,:);
            t2c_netchng = t2c_lnths(:,end) - t2c_lnths(:,1);
            i2i = nodes(:,1)==3 & nodes(:,end)==3;
            i2i_lnths = lnths(i2i,:);
            i2i_netchng = i2i_lnths(:,end) - i2i_lnths(:,1);
            % assigning length changes to ALL struct
            ALL.stats.i2t_LnthChngs.(cond{c}) = [ALL.stats.i2t_LnthChngs.(cond{c}); i2t_netchng];
            ALL.stats.i2c_LnthChngs.(cond{c}) = [ALL.stats.i2c_LnthChngs.(cond{c}); i2c_netchng];
            ALL.stats.t2c_LnthChngs.(cond{c}) = [ALL.stats.t2c_LnthChngs.(cond{c}); t2c_netchng];
            ALL.stats.isolDynam.(cond{c}) = [ALL.stats.isolDynam.(cond{c}); sum(i2t_netchng>0) + sum(i2c_netchng>0),sum(i2t_netchng<0) + sum(i2c_netchng<0)];
            ALL.stats.isolStbl.(cond{c}) = [ALL.stats.isolStbl.(cond{c}); sum(i2i_netchng>0),sum(i2i_netchng<0)];
            ALL.stats.i2tc_LnthChng.(cond{c}) = [ALL.stats.i2tc_LnthChng.(cond{c}); mean(i2t_netchng) mean(i2c_netchng)];
            ALL.stats.i2i_LnthChngs.(cond{c}) = [ALL.stats.i2i_LnthChngs.(cond{c}); i2i_netchng];
            % get lengths and total numbers of internodes for each
            %       designation at d00 and d14
            days = fieldnames(ALL.(cond{c}).(cells{k}).raw);
            types = [];
            lnths = [];
            for d = 1:length(days)
                nodes = ALL.(cond{c}).(cells{k}).raw.(days{d}).Sheath_Info.node_class;
                lnthsTemp = ALL.(cond{c}).(cells{k}).raw.(days{d}).Sheath_Info.intLengths;
                temp = [sum(nodes==1);...
                        sum(nodes==2);...
                        sum(nodes==3);...
                        sum(nodes==4);...
                        sum(nodes==5)];
                types = [types temp];
                lnths = [lnths lnthsTemp];
                ALL.(cond{c}).(cells{k}).NodeClassTots = types;
                if d==1
                    idx0 = nodes==3;
                    n0lnth = mean(lnthsTemp(idx0),'omitnan');
                    idx1 = nodes==4;
                    n1lnth = mean(lnthsTemp(idx1),'omitnan');
                    idx2 = nodes==5;
                    n2lnth = mean(lnthsTemp(idx2),'omitnan');
                    ALL.stats.NodeClassLnths_bsln.(cond{c}) = [ALL.stats.NodeClassLnths_bsln.(cond{c});...
                                                                n0lnth n1lnth n2lnth];
                    ALL.stats.NodeClassTots_bsln.(cond{c}) = [ALL.stats.NodeClassTots_bsln.(cond{c}); temp'];
                elseif d==length(days)
                    if contains(days{end},'d14') || contains(days{end},'d15')
                        idx0 = nodes==3;
                        n0lnth = mean(lnthsTemp(idx0),'omitnan');
                        idx1 = nodes==4;
                        n1lnth = mean(lnthsTemp(idx1),'omitnan');
                        idx2 = nodes==5;
                        n2lnth = mean(lnthsTemp(idx2),'omitnan');
                        ALL.stats.NodeClassLnths_last.(cond{c}) = [ALL.stats.NodeClassLnths_last.(cond{c});...
                            n0lnth n1lnth n2lnth];
                        ALL.stats.NodeClassTots_last.(cond{c}) = [ALL.stats.NodeClassTots_last.(cond{c}); temp'];
                    else
                        ALL.stats.NodeClassLnths_last.(cond{c}) = [ALL.stats.NodeClassLnths_last.(cond{c});...
                            NaN NaN NaN];
                        ALL.stats.NodeClassTots_last.(cond{c}) = [ALL.stats.NodeClassTots_last.(cond{c}); NaN(1,5)];
                    end
                end
            end
        end
    end
    %% average lengths at d00 and d14
    bslnAvgs = [mean(ALL.stats.NodeClassLnths_bsln.ctrl,'omitnan'); mean(ALL.stats.NodeClassLnths_bsln.cupr,'omitnan')];
    bslnSems = [calcSEM(ALL.stats.NodeClassLnths_bsln.ctrl); calcSEM(ALL.stats.NodeClassLnths_bsln.cupr)];
    colors = {[255 247 147]...
              [215 71 90]...
              [74 254 255]};
    for i=1:3
        colors{i} = colors{i}./255;
    end
    figure
    subplot(1,2,1)
    b = barwitherr(bslnSems,bslnAvgs);
    set(b(1),'FaceColor', colors{1});
    set(b(2),'FaceColor', colors{2});
    set(b(3),'FaceColor', colors{3});
    ylim([0 90])
    legend('isol','intr','cont','Location','northwest')
    xticklabels({'de novo' 'remyel'})
    ylabel('average myelin sheath length (\mum)')
    box off
    
    lastAvgs = [mean(ALL.stats.NodeClassLnths_last.ctrl,'omitnan'); mean(ALL.stats.NodeClassLnths_last.cupr,'omitnan')];
    lastSems = [calcSEM(ALL.stats.NodeClassLnths_bsln.ctrl); calcSEM(ALL.stats.NodeClassLnths_bsln.cupr)];
    subplot(1,2,2)
    b = barwitherr(lastSems,lastAvgs);
    set(b(1),'FaceColor', colors{1});
    set(b(2),'FaceColor', colors{2});
    set(b(3),'FaceColor', colors{3});    
%     legend('0 nbrs','1 nbr','2 nbrs','Location','northwest')
    xticklabels({'de novo' 'remyel'})
    ylabel('average myelin sheath length (\mum)')
    
    figQuality(gcf,gca,[5 3])
    
    %% proportions
    bslnCtAvg = mean(ALL.stats.NodeClassTots_bsln.ctrl(:,3:end),'omitnan');
    bslnCtSem = calcSEM(ALL.stats.NodeClassTots_bsln.ctrl(:,3:end))./sum(bslnCtAvg);
    bslnCtAvg = bslnCtAvg./sum(bslnCtAvg);
    
    bslnCuAvg = mean(ALL.stats.NodeClassTots_bsln.cupr(:,3:end),'omitnan');
    bslnCuSem = calcSEM(ALL.stats.NodeClassTots_bsln.cupr(:,3:end))./sum(bslnCuAvg);
    bslnCuAvg = bslnCuAvg./sum(bslnCuAvg);
    
    lastCtAvg = mean(ALL.stats.NodeClassTots_last.ctrl(:,3:end),'omitnan');
    lastCtSem = calcSEM(ALL.stats.NodeClassTots_last.ctrl(:,3:end))./sum(lastCtAvg);
    lastCtAvg = lastCtAvg./sum(lastCtAvg);
    
    lastCuAvg = mean(ALL.stats.NodeClassTots_last.cupr(:,3:end),'omitnan');
    lastCuSem = calcSEM(ALL.stats.NodeClassTots_last.cupr(:,3:end))./sum(lastCuAvg);
    lastCuAvg = lastCuAvg./sum(lastCuAvg);
    
    figure
    subplot(1,2,1)
    hold on
    title('proportions of internodes, day 0')
    b = bar([bslnCtAvg;bslnCuAvg],'stacked');
    set(b(1),'FaceColor', colors{1});
    set(b(2),'FaceColor', colors{2});
    set(b(3),'FaceColor', colors{3});
    errorbar(1,bslnCtAvg(1),bslnCtSem(1),'k')
    errorbar(1,bslnCtAvg(1)+bslnCtAvg(2),bslnCtSem(2),'k')
    errorbar(1,sum(bslnCtAvg),bslnCtSem(3),'k')
    errorbar(2,bslnCuAvg(1),bslnCuSem(1),'k')
    errorbar(2,bslnCuAvg(1)+bslnCuAvg(2),bslnCuSem(2),'k')
    errorbar(2,sum(bslnCuAvg),bslnCuSem(3),'k')
    ylim([0 1.1])
    ylabel('proportion of sheaths per cell')
    xticks([1 2])
    xticklabels({'de novo','remyel'})
    legend({'0 neighbours', '1 neighbour', '2 neighbours'},'Location','southeast')
    box off
    hold off
    
    subplot(1,2,2)
    hold on
    title('proportions of internodes, day 14')
    b = bar([lastCtAvg;lastCuAvg],'stacked');
    set(b(1),'FaceColor', colors{1});
    set(b(2),'FaceColor', colors{2});
    set(b(3),'FaceColor', colors{3});
    errorbar(1,lastCtAvg(1),lastCtSem(1),'k')
    errorbar(1,lastCtAvg(1)+lastCtAvg(2),lastCtSem(2),'k')
    errorbar(1,sum(lastCtAvg),lastCtSem(3),'k')
    errorbar(2,lastCuAvg(1),lastCuSem(1),'k')
    errorbar(2,lastCuAvg(1)+lastCuAvg(2),lastCuSem(2),'k')
    errorbar(2,sum(lastCuAvg),lastCuSem(3),'k')
    ylim([0 1.1])
    ylabel('proportion of sheaths per cell')
    xticks([1 2])
    xticklabels({'de novo','remyel'})
    hold off
    figQuality(gcf,gca,[7 3])
    
end