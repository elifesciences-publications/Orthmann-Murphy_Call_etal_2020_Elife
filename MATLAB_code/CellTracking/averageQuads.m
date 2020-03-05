function ALL = averageQuads(ALL)
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
    BinnedLPnum = [];
    BinnedLPdist = [];
    BinnedLPprop = [];
    BinnedRPnum = [];
    BinnedRPdist = [];
    BinnedRPprop = [];
    BinnedRPrandnum = [];
    BinnedRPranddist = [];
    BinnedRPrandprop = [];
    volOverlap = [];
    volOverlapRand = [];
    for q = 1:length(quad)
        WKdata(:,:,q) = ALL.(vol{v}).(quad{q}).WKdata;
        WKdataProp(:,:,q) = ALL.(vol{v}).(quad{q}).WKdata ./ ALL.(vol{v}).(quad{q}).WKdata(1,1);
        AlignData(:,:,q) = ALL.(vol{v}).(quad{q}).AlignData;
        AlignDataProp(:,:,q) = ALL.(vol{v}).(quad{q}).AlignData ./ ALL.(vol{v}).(quad{q}).AlignData(1,1);
        Dstats = ALL.(vol{v}).(quad{q}).Dstats;
        Dists(q,:) = [Dstats.avgDstbl Dstats.avgDlostnew Dstats.avgDall Dstats.avgDearlynew];
        for b = 1:3
            BinnedAlign(:,:,q,b) = ALL.(vol{v}).(quad{q}).binned.align.(bin{b});
            BinnedAlignProp(:,:,q,b) = ALL.(vol{v}).(quad{q}).binned.align.(bin{b}) ./ ALL.(vol{v}).(quad{q}).binned.align.(bin{b})(1,1);
            BinnedWKdata(:,:,q,b) = ALL.(vol{v}).(quad{q}).binned.wkdata.(bin{b});
            BinnedWKdataProp(:,:,q,b) = ALL.(vol{v}).(quad{q}).binned.wkdata.(bin{b}) ./ ALL.(vol{v}).(quad{q}).binned.wkdata.(bin{b})(1,1);
%             BinnedTerrR(q,b) = ALL.(vol{v}).(quad{q}).binned.terrStats.blTerrR.(bin{b})(1,2);
%             BinnedTerrRrot(q,b) = ALL.(vol{v}).(quad{q}).binned.terrStats.blrotTerrR.(bin{b})(1,2);
            Dstats = ALL.(vol{v}).(quad{q}).binned.Dstats.(bin{b});
            BinnedDists(b,:,q) = [Dstats.avgDstbl Dstats.avgDlostnew Dstats.avgDall Dstats.avgDearlynew Dstats.avglostnewRand];
        end
        BinnedLPnum(q,:) = ALL.(vol{v}).(quad{q}).binned.LPanalysis.numCellsRepl;
        BinnedLPdist(q,:) = ALL.(vol{v}).(quad{q}).binned.LPanalysis.distCellsRepl;
        BinnedLPprop(q,:) = ALL.(vol{v}).(quad{q}).binned.LPanalysis.propCellsRepl;
        BinnedRPnum(q,:) = ALL.(vol{v}).(quad{q}).binned.RPanalysis.numCellsRepl;
        BinnedRPdist(q,:) = ALL.(vol{v}).(quad{q}).binned.RPanalysis.distCellsRepl;
        BinnedRPprop(q,:) = ALL.(vol{v}).(quad{q}).binned.RPanalysis.propCellsRepl;
        BinnedRPrandnum(q,:) = ALL.(vol{v}).(quad{q}).binned.RPrandanalysis.numCellsRepl;
        BinnedRPranddist(q,:) = ALL.(vol{v}).(quad{q}).binned.RPrandanalysis.distCellsRepl;
        BinnedRPrandprop(q,:) = ALL.(vol{v}).(quad{q}).binned.RPrandanalysis.propCellsRepl;
        volOverlap(q,:) = ALL.(vol{v}).(quad{q}).binned.terrStats.vol;
        volOverlapRand(q,:) = ALL.(vol{v}).(quad{q}).binned.terrStats.randvol;
    end
    % overall data
    ALL.(vol{v}).avgquad.WKdata = mean(WKdata,3,'omitnan');
    ALL.(vol{v}).semquad.WKdata = std(WKdata,0,3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.WKdataProp = mean(WKdataProp,3,'omitnan');
    ALL.(vol{v}).semquad.WKdataProp = std(WKdataProp,0,3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.AlignData = mean(AlignData,3,'omitnan');
    ALL.(vol{v}).semquad.AlignData = std(AlignData,0,3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.AlignDataProp = mean(AlignDataProp,3,'omitnan');
    ALL.(vol{v}).semquad.AlignDataProp = std(AlignDataProp,0,3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.Dists = mean(Dists,1,'omitnan');
    ALL.(vol{v}).semquad.Dists = std(Dists,0,1,'omitnan') ./ sqrt(q);
    
    % binned data
    ALL.(vol{v}).avgquad.BinnedAlign = mean(BinnedAlign,3,'omitnan');
    ALL.(vol{v}).semquad.BinnedAlign = std(BinnedAlign,0,3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).semquad.BinnedAlignProp = std(BinnedAlignProp,0,3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedAlignProp = mean(BinnedAlignProp,3,'omitnan');
    ALL.(vol{v}).avgquad.BinnedWKdata = mean(BinnedWKdata,3,'omitnan');
    ALL.(vol{v}).semquad.BinnedWKdata = std(BinnedWKdata,0,3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).semquad.BinnedWKdataProp = std(BinnedWKdataProp,0,3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedWKdataProp = mean(BinnedWKdataProp,3,'omitnan');
%     ALL.(vol{v}).avgquad.BinnedTerrR = mean(BinnedTerrR,1,'omitnan');
%     ALL.(vol{v}).semquad.BinnedTerrR = std(BinnedTerrR,[],1,'omitnan') ./ sqrt(q);
%     ALL.(vol{v}).avgquad.BinnedTerrRrot = mean(BinnedTerrRrot,1,'omitnan');
%     ALL.(vol{v}).semquad.BinnedTerrrot = std(BinnedTerrRrot,[],1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedDists = mean(BinnedDists,3,'omitnan');
    ALL.(vol{v}).semquad.BinnedDists = std(BinnedDists,0,3,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.volOverlap = mean(volOverlap,1);
    ALL.(vol{v}).semquad.volOverlap = std(volOverlap,0,1) ./ sqrt(q);
    ALL.(vol{v}).avgquad.volOverlapRand = mean(volOverlapRand,1);
    ALL.(vol{v}).semquad.volOverlapRand = std(volOverlapRand,0,1) ./ sqrt(q);
    %LP
    ALL.(vol{v}).avgquad.BinnedLPnum = mean(BinnedLPnum,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedLPnum = std(BinnedLPnum,0,1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedLPdist = mean(BinnedLPdist,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedLPdist = std(BinnedLPdist,0,1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedLPprop = mean(BinnedLPprop,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedLPprop = std(BinnedLPprop,0,1,'omitnan') ./ sqrt(q);
    %RP
    ALL.(vol{v}).avgquad.BinnedRPnum = mean(BinnedRPnum,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedRPnum = std(BinnedRPnum,0,1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedRPdist = mean(BinnedRPdist,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedRPdist = std(BinnedRPdist,0,1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedRPprop = mean(BinnedRPprop,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedRPprop = std(BinnedRPprop,0,1,'omitnan') ./ sqrt(q);
    %RPrand
    ALL.(vol{v}).avgquad.BinnedRPrandnum = mean(BinnedRPrandnum,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedRPrandnum = std(BinnedRPrandnum,0,1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedRPranddist = mean(BinnedRPranddist,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedRPranddist = std(BinnedRPranddist,0,1,'omitnan') ./ sqrt(q);
    ALL.(vol{v}).avgquad.BinnedRPrandprop = mean(BinnedRPrandprop,1,'omitnan');
    ALL.(vol{v}).semquad.BinnedRPrandprop = std(BinnedRPrandprop,0,1,'omitnan') ./ sqrt(q);
    
    %%%%    ALL.(vol{v}).avgquad.LostRepl
    %%% lostRepl by bin
    
end
end