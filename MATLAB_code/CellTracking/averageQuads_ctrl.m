function ALL = averageQuads_ctrl(ALL)
vol = fieldnames(ALL);
for v = 1:length(vol)
    quad = fieldnames(ALL.(vol{v}));
    notquad = contains(quad,'XLS');
    quad(notquad) = [];
    bin = {'b1' 'b2' 'b3'};
    WKdata = [];
    WKdataProp = [];
    AlignData = [];
    AlignDataProp = [];
    Dstats = [];
    Dists = [];
    BinnedAlign = [];
    BinnedAlignProp = [];
    BinnedWKdata = [];
    BinnedWKdataProp = [];
    BinnedSPnum = [];
    BinnedSPdist = [];
    BinnedSPprop = [];
    BinnedNPnum = [];
    BinnedNPdist = [];
    BinnedNPprop = [];
    volOverlap = [];
    volOverlapRand = [];
    for q = 1:length(quad)
        WKdata(:,:,q) = ALL.(vol{v}).(quad{q}).WKdata;
        WKdataProp(:,:,q) = ALL.(vol{v}).(quad{q}).WKdata ./ ALL.(vol{v}).(quad{q}).WKdata(1,1);
        AlignData(:,:,q) = ALL.(vol{v}).(quad{q}).AlignData;
        AlignDataProp(:,:,q) = ALL.(vol{v}).(quad{q}).AlignData ./ ALL.(vol{v}).(quad{q}).AlignData(1,1);
        Dstats = ALL.(vol{v}).(quad{q}).Dstats;
        Dists(q,:) = [Dstats.avgDstbl Dstats.avgDstblnew Dstats.avgDall Dstats.avgDearlynew];
        for b = 1:3
            BinnedAlign(:,:,q,b) = ALL.(vol{v}).(quad{q}).binned.align.(bin{b});
            BinnedAlignProp(:,:,q,b) = ALL.(vol{v}).(quad{q}).binned.align.(bin{b}) ./ ALL.(vol{v}).(quad{q}).binned.align.(bin{b})(1,1);
            BinnedWKdata(:,:,q,b) = ALL.(vol{v}).(quad{q}).binned.wkdata.(bin{b});
            BinnedWKdataProp(:,:,q,b) = ALL.(vol{v}).(quad{q}).binned.wkdata.(bin{b}) ./ ALL.(vol{v}).(quad{q}).binned.wkdata.(bin{b})(1,1);
%             BinnedTerrR(q,b) = ALL.(vol{v}).(quad{q}).binned.terrStats.blTerrR.(bin{b})(1,2);
%             BinnedTerrRrot(q,b) = ALL.(vol{v}).(quad{q}).binned.terrStats.blrotTerrR.(bin{b})(1,2);
            Dstats = ALL.(vol{v}).(quad{q}).binned.Dstats.(bin{b});
            BinnedDists(b,:,q) = [Dstats.avgDstbl Dstats.avgDstblnew Dstats.avgDall Dstats.avgDearlynew];
        end
        BinnedSPnum(q,:) = ALL.(vol{v}).(quad{q}).binned.SPanalysis.numCellsRepl;
        BinnedSPdist(q,:) = ALL.(vol{v}).(quad{q}).binned.SPanalysis.distCellsRepl;
        BinnedSPprop(q,:) = ALL.(vol{v}).(quad{q}).binned.SPanalysis.propCellsRepl;
        BinnedNPnum(q,:) = ALL.(vol{v}).(quad{q}).binned.NPanalysis.numCellsRepl;
        BinnedNPdist(q,:) = ALL.(vol{v}).(quad{q}).binned.NPanalysis.distCellsRepl;
        BinnedNPprop(q,:) = ALL.(vol{v}).(quad{q}).binned.NPanalysis.propCellsRepl;
        volOverlap(q,:) = ALL.(vol{v}).(quad{q}).binned.terrStats.vol;
        volOverlapRand(q,:) = ALL.(vol{v}).(quad{q}).binned.terrStats.randvol;
    end
    % overall data
    ALL.(vol{v}).avgquad.WKdata = mean(WKdata,3,'omitnan');
    ALL.(vol{v}).semquad.WKdata = std(WKdata,[],3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.WKdataProp = mean(WKdataProp,3,'omitnan');
    ALL.(vol{v}).semquad.WKdataProp = std(WKdataProp,[],3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.AlignData = mean(AlignData,3,'omitnan');
    ALL.(vol{v}).semquad.AlignData = std(AlignData,[],3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.AlignDataProp = mean(AlignDataProp,3,'omitnan');
    ALL.(vol{v}).semquad.AlignDataProp = std(AlignDataProp,[],3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.Dists = mean(Dists,1,'omitnan');
    ALL.(vol{v}).semquad.Dists = std(Dists,[],1,'omitnan') ./ sqrt(q);
    
    % binned data
    ALL.(vol{v}).avgquad.BinnedAlign = mean(BinnedAlign,3,'omitnan');
    ALL.(vol{v}).semquad.BinnedAlign = std(BinnedAlign,[],3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).semquad.BinnedAlignProp = std(BinnedAlignProp,[],3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedAlignProp = mean(BinnedAlignProp,3,'omitnan');
    ALL.(vol{v}).avgquad.BinnedWKdata = mean(BinnedWKdata,3,'omitnan');
    ALL.(vol{v}).semquad.BinnedWKdata = std(BinnedWKdata,[],3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).semquad.BinnedWKdataProp = std(BinnedWKdataProp,[],3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedWKdataProp = mean(BinnedWKdataProp,3,'omitnan');
%     ALL.(vol{v}).avgquad.BinnedTerrR = mean(BinnedTerrR,1,'omitnan');
%     ALL.(vol{v}).semquad.BinnedTerrR = std(BinnedTerrR,[],1,'omitnan') ./ sqrt(q);
%     ALL.(vol{v}).avgquad.BinnedTerrRrot = mean(BinnedTerrRrot,1,'omitnan');
%     ALL.(vol{v}).semquad.BinnedTerrrot = std(BinnedTerrRrot,[],1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedDists = mean(BinnedDists,3,'omitnan');
    ALL.(vol{v}).semquad.BinnedDists = std(BinnedDists,[],3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.volOverlap = mean(volOverlap);
    ALL.(vol{v}).semquad.volOverlap = std(volOverlap) ./ sqrt(q);
    ALL.(vol{v}).avgquad.volOverlapRand = mean(volOverlapRand);
    ALL.(vol{v}).semquad.volOverlapRand = std(volOverlapRand) ./ sqrt(q);
    %LP
    ALL.(vol{v}).avgquad.BinnedSPnum = mean(BinnedSPnum,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedSPnum = std(BinnedSPnum,[],1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedSPdist = mean(BinnedSPdist,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedSPdist = std(BinnedSPdist,[],1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedSPprop = mean(BinnedSPprop,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedSPprop = std(BinnedSPprop,[],1,'omitnan') ./ sqrt(q);
    %RP
    ALL.(vol{v}).avgquad.BinnedNPnum = mean(BinnedNPnum,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedNPnum = std(BinnedNPnum,[],1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedNPdist = mean(BinnedNPdist,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedNPdist = std(BinnedNPdist,[],1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedNPprop = mean(BinnedNPprop,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedNPprop = std(BinnedNPprop,[],1,'omitnan') ./ sqrt(q);
    
    %%%%    ALL.(vol{v}).avgquad.LostRepl
    %%% lostRepl by bin
    
end
end