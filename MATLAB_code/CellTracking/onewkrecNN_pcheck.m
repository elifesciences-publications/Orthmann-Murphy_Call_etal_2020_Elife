function pvals = onewkrecNN_pcheck(cuprAvg,ctrlAvg,fit)
rng(81); %set random seed start
rndcnt = 0;
pvals.cupr.cond = [];
pvals.cupr.radpack = [];
pvals.cupr.var = [];
pvals.cupr.scl = [];
pvals.cupr.uni = [];
pvals.cupr.uniPD = [];
pvals.cupr.RuniPD = [];

pvals.ctrl.cond = [];
pvals.ctrl.radpack = [];
pvals.ctrl.var = [];
pvals.ctrl.scl = [];
pvals.ctrl.uni = [];
pvals.ctrl.uniPD = [];
pvals.ctrl.RuniPD = [];
while rndcnt < 100
    rndcnt = rndcnt + 1;
    fprintf([num2str(rndcnt) ' '])
    out = struct;
    ALL.cupr = cuprAvg;
    ALL.ctrl = ctrlAvg;
    cond = {'cupr' 'ctrl'};
    for ii = 1:2
        out.(cond{ii}).bslnZbin = [];
        out.(cond{ii}).bslnZRbin = [];
        out.(cond{ii}).bslnZRSbin = [];
        out.(cond{ii}).rec1wkZbin = [];
        out.(cond{ii}).rec1wkZRbin = [];
        out.(cond{ii}).rec1wkZRSbin = [];
        out.(cond{ii}).rec2wkZbin = [];
        out.(cond{ii}).rec2wkZRbin = [];
        out.(cond{ii}).rec2wkZRSbin = [];
        out.(cond{ii}).lastNEWZbin = [];
        out.(cond{ii}).lastNEWZRbin = [];
        out.(cond{ii}).lastNEWZRSbin = [];
        out.(cond{ii}).lastZbin = [];
        out.(cond{ii}).lastZRbin = [];
        out.(cond{ii}).lastZRSbin = [];
        an = fieldnames(ALL.(cond{ii}));
        for a = 1:length(an)-2 %exclude avg and sem
            quad = fieldnames(ALL.(cond{ii}).(an{a}));
            out.(cond{ii}).(an{a}).Zbins = [];
            out.(cond{ii}).(an{a}).ZRbins = [];
            out.(cond{ii}).(an{a}).binsRndScl = [];
            out.(cond{ii}).(an{a}).var = [];
            out.(cond{ii}).(an{a}).Rvar = [];
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
                idx3wkrec = wkIdx{7}; %note, switched to 3 weeks to correspond with current histoloy available
                
                % parse data for each time point, taking into account animals
                % without a 5 wk recovery image
                tp = fieldnames(ALL.(cond{ii}).(an{a}).(quad{q}).series);
                databsln = ALL.(cond{ii}).(an{a}).(quad{q}).series.tp0;
                
                data1wkrec = ALL.(cond{ii}).(an{a}).(quad{q}).series.(tp{idx1wkrec});
                newidx = ~ismember(data1wkrec(:,1),databsln(:,1));
                data1wkrec = data1wkrec(newidx,:);
                
                data2wkrec = ALL.(cond{ii}).(an{a}).(quad{q}).series.(tp{idx2wkrec});
                newidx = ~ismember(data2wkrec(:,1),databsln(:,1));
                data2wkrec = data2wkrec(newidx,:);
                % calc 1NN, get variance
                [~,Dbsln]=knnsearch(databsln(:,end-2:end),databsln(:,end-2:end),'K',2);
                [~,D1wkr]=knnsearch(data1wkrec(:,end-2:end),data1wkrec(:,end-2:end),'K',2);
                [~,D2wkr]=knnsearch(data2wkrec(:,end-2:end),data2wkrec(:,end-2:end),'K',2);
                variance = [std(Dbsln(:,2)).^2, std(D1wkr(:,2)).^2, std(D2wkr(:,2)).^2;...
                    mean(growbubbles(databsln(:,end-2:end))), mean(growbubbles(data1wkrec(:,end-2:end))), mean(growbubbles(data2wkrec(:,end-2:end)))];
                if isnan(idx3wkrec)
                    idx3wkrec = wkIdx{8};
                    if isnan(idx3wkrec)
                        datalast = [];
                        datalastNEW = [];
                        variance = [variance, NaN(2)];
                    end
                else
                    datalast = ALL.(cond{ii}).(an{a}).(quad{q}).series.(tp{idx3wkrec});
                    newidx = ~ismember(datalast(:,1),databsln(:,1));
                    datalastNEW = datalast(newidx,:);
                    [~,Dlastnew]=knnsearch(datalastNEW(:,end-2:end),datalastNEW(:,end-2:end),'K',2);
                    [~,Dlast]=knnsearch(datalast(:,end-2:end),datalast(:,end-2:end),'K',2);
                    variance = [variance, [std(Dlastnew(:,2)).^2, std(Dlast(:,2)).^2;...
                        mean(growbubbles(datalastNEW(:,end-2:end))), mean(growbubbles(datalast(:,end-2:end)))]];
                end
                
                %Below: comparing a single time point (what x, y, and z are defined
                %as in the next few lines) to uniformly-distributed coordinates. Distribution of
                %coordinates in each dimension compared by KS test to uniformly-
                %distributed values in that dimension
                perTP = [];
                Zbins = [];
                ZRbins = [];
                binsRndScl = [];
                Rvar = [];
                
                for w = 1:5
                    switch w
                        case 1
                            var = databsln;
                        case 2
                            var = data1wkrec;
                        case 3
                            var = data2wkrec;
                        case 5
                            var = datalast;
                            if isempty(var)
                                Rvar = [Rvar, NaN([2,1])];
                                continue
                            end
                        case 4
                            var = datalastNEW;
                            if isempty(var)
                                Rvar = [Rvar, NaN([2,1])];
                                continue
                            end
                    end
                    x = var(:,end-2);
                    y = var(:,end-1);
                    z = var(:,end);
                    z = (z - min(z));
                    xmin = min(x);
                    xmax = max(x);
                    ymin = min(y);
                    ymax = max(y);
                    zmin = min(z);
                    zmax = max(z);
                    
                    perTP = [perTP; [x y z]];
                    
                    xr = xmin + (xmax-xmin)*rand(length(x),1);
                    yr = ymin + (ymax-ymin)*rand(length(x),1);
                    zr = 0 + (300-(0))*rand(length(z),1);
                    
                    edges = 0:25:300;
                    idx = discretize(z,edges);
                    bins = [];
                    for j = 1:length(edges)
                        bins = [bins; sum(idx==j)];
                    end
                    bins = [bins(1:end-2); bins(end-1) + bins(end)];
                    Zbins = [Zbins bins];
                    
                    idx = discretize(zr,edges);
                    rbins = [];
                    for j = 1:length(edges)
                        rbins = [rbins; sum(idx==j)];
                    end
                    rbins = [rbins(1:end-2); rbins(end-1) + rbins(end)];
                    ZRbins = [ZRbins rbins];

                    n = sum(bins);
                    zrs = random(fit, n, 1);
                    idx = discretize(zrs,edges);
                    rsbins = [];
                    for j = 1:length(edges)
                        rsbins = [rsbins; sum(idx==j)];
                    end
                    rsbins = [rsbins(1:end-2); rsbins(end-1) + rsbins(end)];
                    binsRndScl = [binsRndScl rsbins];
                    
                    % calculate nearest neighbor variance for simulated data
                    [~,DR]=knnsearch([xr yr zr],[xr yr zr],'K',2);
                    DR = [std(DR(:,2)).^2; mean(growbubbles([xr yr zr]))];
                    Rvar = [Rvar, DR];
                end % time point loop
                if q==1 || (q==2 && contains(an{a},'v'))
                    out.(cond{ii}).(an{a}).Zbins = Zbins;
                    out.(cond{ii}).(an{a}).ZRbins = ZRbins;
                    out.(cond{ii}).(an{a}).binsRndScl = binsRndScl;
                    out.(cond{ii}).(an{a}).var = variance;
                    out.(cond{ii}).(an{a}).Rvar = Rvar;
                else
                    [out.(cond{ii}).(an{a}).Zbins, Zbins] = forceConcat(out.(cond{ii}).(an{a}).Zbins, Zbins, 1);
                    [out.(cond{ii}).(an{a}).ZRbins, ZRbins] = forceConcat(out.(cond{ii}).(an{a}).ZRbins, ZRbins, 1);
                    [out.(cond{ii}).(an{a}).binsRndScl, binsRndScl] = forceConcat(out.(cond{ii}).(an{a}).binsRndScl, binsRndScl, 1);
                    if size(out.(cond{ii}).(an{a}).Zbins,2) > size(Zbins,2) % account for 1 region closing before the other
                        out.(cond{ii}).(an{a}).Zbins = [out.(cond{ii}).(an{a}).Zbins(:,1:3) + Zbins, out.(cond{ii}).(an{a}).Zbins(:,4:5)];
                        out.(cond{ii}).(an{a}).ZRbins = [out.(cond{ii}).(an{a}).ZRbins(:,1:3) + ZRbins, out.(cond{ii}).(an{a}).ZRbins(:,4:5)];
                        out.(cond{ii}).(an{a}).binsRndScl = [out.(cond{ii}).(an{a}).binsRndScl(:,1:3) + binsRndScl, out.(cond{ii}).(an{a}).binsRndScl(:,4:5)];
                    elseif size(out.(cond{ii}).(an{a}).Zbins,2) < size(Zbins,2) % account for 1 region closing before the other
                        out.(cond{ii}).(an{a}).Zbins = [out.(cond{ii}).(an{a}).Zbins + Zbins(:,1:3), Zbins(:,4:5)];
                        out.(cond{ii}).(an{a}).ZRbins = [out.(cond{ii}).(an{a}).ZRbins + ZRbins(:,1:3), ZRbins(:,4:5)];
                        out.(cond{ii}).(an{a}).binsRndScl = [out.(cond{ii}).(an{a}).binsRndScl + binsRndScl(:,1:3), binsRndScl(:,4:5)];
                    else
                        out.(cond{ii}).(an{a}).Zbins = out.(cond{ii}).(an{a}).Zbins + Zbins; % sum data across quads
                        out.(cond{ii}).(an{a}).ZRbins = out.(cond{ii}).(an{a}).ZRbins + ZRbins;
                        out.(cond{ii}).(an{a}).binsRndScl = out.(cond{ii}).(an{a}).binsRndScl + binsRndScl;
                    end
                    out.(cond{ii}).(an{a}).var = out.(cond{ii}).(an{a}).var + variance;
                    out.(cond{ii}).(an{a}).Rvar = out.(cond{ii}).(an{a}).Rvar + Rvar;
                end
                
            end % quad loop
            
            if contains(an{a},'v')
                q=q-1; % account for 'originalXLS' being first in list
            end
            out.(cond{ii}).(an{a}).Zbins = out.(cond{ii}).(an{a}).Zbins ./ q; % average data across quads per animal
            out.(cond{ii}).(an{a}).ZRbins = out.(cond{ii}).(an{a}).ZRbins ./ q;
            out.(cond{ii}).(an{a}).binsRndScl = out.(cond{ii}).(an{a}).binsRndScl ./ q;
            out.(cond{ii}).(an{a}).var = out.(cond{ii}).(an{a}).var ./ q;
            out.(cond{ii}).(an{a}).Rvar = out.(cond{ii}).(an{a}).Rvar ./ q;
            tps = fieldnames(out.(cond{ii}));
            tps = tps(1:15);
            k = 0;
            for i = 1:3:length(tps) % concatenate data across animals
                k = k+1;
                if k>size(Zbins,2)
                    continue
                end
                temp = out.(cond{ii}).(an{a}).Zbins(:,k);
                [out.(cond{ii}).(tps{i}), temp] = forceConcat(out.(cond{ii}).(tps{i}), temp,1);
                out.(cond{ii}).(tps{i}) = [out.(cond{ii}).(tps{i}) temp];
                temp = out.(cond{ii}).(an{a}).ZRbins(:,k);
                [out.(cond{ii}).(tps{i+1}), temp] = forceConcat(out.(cond{ii}).(tps{i+1}), temp,1);
                out.(cond{ii}).(tps{i+1}) = [out.(cond{ii}).(tps{i+1}) temp];
                temp = out.(cond{ii}).(an{a}).binsRndScl(:,k);
                [out.(cond{ii}).(tps{i+2}), temp] = forceConcat(out.(cond{ii}).(tps{i+2}), temp,1);
                out.(cond{ii}).(tps{i+2}) = [out.(cond{ii}).(tps{i+2}) temp];
            end
        end % an loop
        %%
        fld = fieldnames(out.(cond{ii}));
        tps = fld(1:12); % change to 15 (and subplotting to 1,5,k./2) to also include 3rd wk including stable cells
        pUni = [];
        pUniPD = [];
        pRUniPD = [];
        for i = 1:3:length(tps)
            b = mean(out.(cond{ii}).(tps{i}),2,'omitnan');
            br = mean(out.(cond{ii}).(tps{i+1}),2,'omitnan');
            [~,pRealvsRandUni] = kstest2(b,br);
            pUni = [pUni pRealvsRandUni]; 
            pd = makedist('uniform');
            [~,pRealvsUniPD] = kstest(b,'cdf',pd);
            pUniPD = [pUniPD pRealvsUniPD];
            [~,pRandvsUniPD] = kstest(br,'cdf',pd);
            pRUniPD = [pRUniPD pRandvsUniPD];
        end
        pvals.(cond{ii}).uni = [pvals.(cond{ii}).uni; pUni];
        pvals.(cond{ii}).uniPD = [pvals.(cond{ii}).uniPD; pUniPD];
        pvals.(cond{ii}).RuniPD = [pvals.(cond{ii}).RuniPD; pRUniPD];
        
        pScl = [];
        for i = 1:3:length(tps)
            b = mean(out.(cond{ii}).(tps{i}),2,'omitnan');
            br = mean(out.(cond{ii}).(tps{i+2}),2,'omitnan');
            [~,pRealvsRandScl] = kstest2(b,br);
            pScl = [pScl pRealvsRandScl];
        end
        pvals.(cond{ii}).scl = [pvals.(cond{ii}).scl; pScl];
        
        fld = fld(16:end); % indiv. animal structs (first 10 are real/rand tps)
        anvar = [];
        anRvar = [];
        anMaxRad = [];
        anRMaxRad = [];
        for i = 1:length(fld)
            anvar = [anvar; out.(cond{ii}).(fld{i}).var(1,:)]; % row 1 is variance of k=1 NN distances; row 2 is mean radius from growbubbles
            anRvar = [anRvar; out.(cond{ii}).(fld{i}).Rvar(1,:)];
            anMaxRad = [anMaxRad; out.(cond{ii}).(fld{i}).var(2,:)];
            anRMaxRad = [anRMaxRad; out.(cond{ii}).(fld{i}).Rvar(2,:)];
        end
        [~,p_variance] = ttest2(anvar,anRvar,'Dim',1);
        [~,p_radpack] = ttest2(anMaxRad,anRMaxRad,'Dim',1);
        pvals.(cond{ii}).var = [pvals.(cond{ii}).var; p_variance];
        pvals.(cond{ii}).radpack = [pvals.(cond{ii}).radpack; p_radpack];
    end
    pCond = [];
    for i = 1:3:length(tps)
        ctrl = mean(out.ctrl.(tps{i}),2,'omitnan');
        cupr = mean(out.cupr.(tps{i}),2,'omitnan');
        [~,pCtrlVsCupr] = kstest2(ctrl,cupr);
        pCond = [pCond pCtrlVsCupr];
    end
    pvals.(cond{ii}).cond = [pvals.(cond{ii}).cond; pCond];
end
fprintf('\n')
end