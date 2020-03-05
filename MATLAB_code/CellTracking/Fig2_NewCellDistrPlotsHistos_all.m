function out = Fig2_NewCellDistrPlotsHistos_all(cuprAvg,showplots)
rng(73); %set random seed start
out = struct;
ALL.cupr = cuprAvg;
% ALL.ctrl = ctrlAvg;
cond = {'cupr'};% 'ctrl'};
for ii = 1%:2
    out.(cond{ii}).bslnZbin = [];
    out.(cond{ii}).rec1wkZbin = [];
    out.(cond{ii}).rec2wkZbin = [];
    out.(cond{ii}).lastNEWZbin = [];
    out.(cond{ii}).lastZbin = [];
    out.(cond{ii}).concCoords = [];
    an = fieldnames(ALL.(cond{ii}));
    for a = 1:length(an)-2 %exclude avg and sem
        quad = fieldnames(ALL.(cond{ii}).(an{a}));
        out.(cond{ii}).(an{a}).Zbins = [];
        out.(cond{ii}).(an{a}).ZRbins = [];
        out.(cond{ii}).(an{a}).var = [];
        variance = [];
        for q = 1:length(quad)-2 %exclude avg and sem
            if contains(quad(q),'originalXLS')
                continue
            end
            if contains(an{a},'v')
                name = an{a};
            else
                name = quad{q};
            end
            [~,~,~,wkIdx] = plotCurves(name,ALL.(cond{ii}).(an{a}).(quad{q}).TPdata,1);
            idx1wkrec = wkIdx{5};
            idx2wkrec = wkIdx{6};
            idx5wkrec = wkIdx{9}; 
            
            % parse data for each time point, taking into account animals
            % without a 5 wk recovery image
            tp = fieldnames(ALL.(cond{ii}).(an{a}).(quad{q}).series);
            databsln = ALL.(cond{ii}).(an{a}).(quad{q}).series.tp0;
            dataLastWKCond = ALL.(cond{ii}).(an{a}).(quad{q}).series.(tp{wkIdx{4}});
            
            data1wkrec = ALL.(cond{ii}).(an{a}).(quad{q}).series.(tp{idx1wkrec});
            newidx = ~ismember(data1wkrec(:,1),dataLastWKCond(:,1));
            data1wkrec = data1wkrec(newidx,:);
            
            data2wkrec = ALL.(cond{ii}).(an{a}).(quad{q}).series.(tp{idx2wkrec});
            newidx = ~ismember(data2wkrec(:,1),dataLastWKCond(:,1));
            data2wkrec = data2wkrec(newidx,:);
            
            if isnan(idx5wkrec)
                fprintf('no 3wk timepoint \n')
                idx5wkrec = wkIdx{11};
                if ~isnan(idx5wkrec)
                    datalast = ALL.(cond{ii}).(an{a}).(quad{q}).series.(tp{idx5wkrec});
                    newidx = ~ismember(datalast(:,1),dataLastWKCond(:,1));
                    data5wkrec = datalast(newidx,:);
                else
                    datalast = [];
                    data5wkrec = [];
                end
            else
                datalast = ALL.(cond{ii}).(an{a}).(quad{q}).series.(tp{idx5wkrec});
                newidx = ~ismember(datalast(:,1),dataLastWKCond(:,1));
                data5wkrec = datalast(newidx,:);
            end
            
            %Below: comparing a single time point (what x, y, and z are defined
            %as in the next few lines) to uniformly-distributed coordinates. Distribution of
            %coordinates in each dimension compared by KS test to uniformly-
            %distributed values in that dimension
            perTP = [];
            Zbins = [];
            
            if showplots
                figure
            end
            for w = 1:5
                if a==1
                    out.(cond{ii}).concCoords.(['t' num2str(w)]) = [];
                end
                switch w
                    case 1
                        var = databsln;
                        xb = var(:,end-2);
                        yb = var(:,end-1);
                        zb = var(:,end);
                        zb = (zb - min(zb));
%                         idx = zb>300;
%                         zb(idx) = []; %remove data points outside of 0 to 300 range due to window tilt
%                         yb(idx) = [];
%                         xb(idx) = [];
                    case 2
                        var = data1wkrec;
                    case 3
                        var = data2wkrec;
                    case 5
                        var = datalast;
                        if isempty(var)
                            continue
                        end
                    case 4
                        var = data5wkrec;
                        if isempty(var)
                            continue
                        end
                end
                x = var(:,end-2);
                y = var(:,end-1);
                z = var(:,end);
                z = (z - min(z));
%                 idx = z>300;
%                 z(idx) = []; %remove data points outside of 0 to 300 range due to window tilt
%                 y(idx) = [];
%                 x(idx) = [];
                
                out.(cond{ii}).concCoords.(['t' num2str(w)]) = [out.(cond{ii}).concCoords.(['t' num2str(w)]); x,y,z];
                
                perTP = [perTP; [x y z]];
                
                edges = 0:30:300;
                idx = discretize(z,edges);
                bins = [];
                for j = 1:length(edges)
                    bins = [bins; sum(idx==j)];
                end
                bins = [bins(1:end-2); bins(end-1)+bins(end)];
                Zbins = [Zbins bins];
                if showplots
                    if w==5
                        continue
                    end
                    subplot(4,1,w)
                    title([cond{ii} an{a} quad{q}])
                    if w==1
                        scat = plot3(xb,yb,-zb,'k.','MarkerSize',12);
                        zt = get(gca, 'ZTick');
                        %                         set(gca, 'ZTick',zt, 'ZTickLabel',fliplr(zt))
                        view(-90,0)
                        drawnow;
                    else
                        plot3(x,y,-z,'g.','MarkerSize',12);
                        hold on;
                        scat = plot3(xb,yb,-zb,'k.','MarkerSize',12);
                        hold off;
                        zt = get(gca, 'ZTick');
                        %                         set(gca, 'ZTick',zt, 'ZTickLabel',fliplr(zt))
                        view(-90,0)
                        drawnow;
                        markers = scat.MarkerHandle;
                        markers.EdgeColorData = uint8([0 0 0 120])';
                    end
                    ylabel('distance (\mum)')
                    zlabel('depth from pia (\mum)')
                    zlim([-300 0])
                end
                if showplots
                    figQuality(gcf,gca,[1.5,6])
                    title([cond{ii} an{a} quad{q}])
                end
            end % time point loop
            if q==1 || (q==2 && contains(an{a},'v'))
                out.(cond{ii}).(an{a}).Zbins = Zbins;
                out.(cond{ii}).(an{a}).var = variance;
            else
                [out.(cond{ii}).(an{a}).Zbins, Zbins] = forceConcat(out.(cond{ii}).(an{a}).Zbins, Zbins, 1);
                if size(out.(cond{ii}).(an{a}).Zbins,2) > size(Zbins,2) % account for 1 region closing before the other
                    out.(cond{ii}).(an{a}).Zbins = [out.(cond{ii}).(an{a}).Zbins(:,1:3) + Zbins, out.(cond{ii}).(an{a}).Zbins(:,4:5)];
                elseif size(out.(cond{ii}).(an{a}).Zbins,2) < size(Zbins,2) % account for 1 region closing before the other
                    out.(cond{ii}).(an{a}).Zbins = [out.(cond{ii}).(an{a}).Zbins + Zbins(:,1:3), Zbins(:,4:5)];
                else
                    out.(cond{ii}).(an{a}).Zbins = out.(cond{ii}).(an{a}).Zbins + Zbins; % sum data across quads
                end
                out.(cond{ii}).(an{a}).var = out.(cond{ii}).(an{a}).var + variance;
            end
        end % quad loop
        
        if contains(an{a},'v')
            q=q-1; % account for 'originalXLS' being first in list
        end
        out.(cond{ii}).(an{a}).Zbins = out.(cond{ii}).(an{a}).Zbins ./ q; % average data across quads per animal
        out.(cond{ii}).(an{a}).var = out.(cond{ii}).(an{a}).var ./ q;
        tps = fieldnames(out.(cond{ii}));
        tps = tps(1:5);
        k = 0;
        for i = 1:length(tps) % concatenate data across animals
            k = k+1;
            if k>size(Zbins,2)
                continue
            end
            temp = out.(cond{ii}).(an{a}).Zbins(:,k);
            [out.(cond{ii}).(tps{i}), temp] = forceConcat(out.(cond{ii}).(tps{i}), temp,1);
            out.(cond{ii}).(tps{i}) = [out.(cond{ii}).(tps{i}) temp];
        end
    end % an loop
    plotRealVsRandUni(out,cond,ii,tps);
    figQuality(gcf,gca,[1.5 6])
end

%%
    function plotRealVsRandUni(out,cond,ii,tps)
        figure
        g=0;
        b = mean(out.(cond{ii}).(tps{1}),2,'omitnan');
        bsem = calcSEM(out.(cond{ii}).(tps{1}),2);
        for p = 1:length(tps)-1
            g = g+1;
            subplot(4,1,g)
            t = mean(out.(cond{ii}).(tps{p}),2,'omitnan');
            tsem = calcSEM(out.(cond{ii}).(tps{p}),2);
            if p>1
                errorbarbar(0.5:9.5,b(1:end),bsem(1:end),{'BarWidth',1,'EdgeAlpha',0,'FaceColor','k','FaceAlpha',0.5},{'Color',[0.5 0.5 0.5],'LineStyle','none','MarkerSize',0.0001,'CapSize',0,'LineWidth',1.7});
                hold on
                errorbarbar(0.5:9.5,t(1:end),tsem(1:end),{'BarWidth',1,'EdgeAlpha',0,'FaceColor','g','FaceAlpha',0.7},{'Color',[0 .7 0],'LineStyle','none','MarkerSize',0.0001,'CapSize',0,'LineWidth',1.7});
                hold off
            else
                errorbarbar(0.5:9.5,b(1:end),bsem(1:end),{'BarWidth',1,'EdgeAlpha',0,'FaceColor','k','FaceAlpha',0.8},{'Color',[0.5 0.5 0.5],'LineStyle','none','MarkerSize',0.0001,'CapSize',0,'LineWidth',1.7});
            end
            set(gca, 'YAxisLocation', 'right')
            xticks([0 3.333 6.667 10]);
            xticklabels({'0' '-100' '-200' '-300'});
            ylim([0 30])
            xlim([0 length(b)])
            camroll(-90)
            TP = fieldnames(out.(cond{ii}));
            fprintf([cond{ii} '_' TP{p}(1:4) '_'])
            box off
            switch g
                case 1
                    txt = 'all cells at baseline';
                case 2
                    txt = 'new cells up to 1 wk recovery';
                case 3
                    txt = 'new cells up to 2 wks recovery';
                case 4
                    txt = 'new cells up to 5 wks recovery';
                case 5
                    txt = 'all cells up to 5 wks recovery';
            end
            title({txt});
            ylabel('number of cells')
            xlabel('depth from pia (\mum)')
        end
    end
end