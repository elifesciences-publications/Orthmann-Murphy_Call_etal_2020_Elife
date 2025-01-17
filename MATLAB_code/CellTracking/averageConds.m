function ALL = averageConds(ALL)
an = fieldnames(ALL);
for a = 1:length(an)
    WKdata(:,:,a) = ALL.(an{a}).avgquad.WKdata;
    WKdataProp(:,:,a) = ALL.(an{a}).avgquad.WKdataProp;
    AlignData(:,:,a) = ALL.(an{a}).avgquad.AlignData;
    AlignDataProp(:,:,a) = ALL.(an{a}).avgquad.AlignDataProp;
    Dists(a,:) = ALL.(an{a}).avgquad.Dists;
%     BinnedTerrR(a,:) = ALL.(an{a}).avgquad.BinnedTerrR;
%     BinnedTerrRrot(a,:) = ALL.(an{a}).avgquad.BinnedTerrRrot;
    BinnedDists(:,:,a) = ALL.(an{a}).avgquad.BinnedDists;
    BinnedLPnum(a,:) = ALL.(an{a}).avgquad.BinnedLPnum;
    BinnedLPdist(a,:) = ALL.(an{a}).avgquad.BinnedLPdist;
    BinnedLPprop(a,:) = ALL.(an{a}).avgquad.BinnedLPprop;
    BinnedRPnum(a,:) = ALL.(an{a}).avgquad.BinnedRPnum;
    BinnedRPdist(a,:) = ALL.(an{a}).avgquad.BinnedRPdist;
    BinnedRPprop(a,:) = ALL.(an{a}).avgquad.BinnedRPprop;
    BinnedRPrandnum(a,:) = ALL.(an{a}).avgquad.BinnedRPrandnum;
    BinnedRPranddist(a,:) = ALL.(an{a}).avgquad.BinnedRPranddist;
    BinnedRPrandprop(a,:) = ALL.(an{a}).avgquad.BinnedRPrandprop;
    for b = 1:3
        BinnedAlign(:,:,a,b) = ALL.(an{a}).avgquad.BinnedAlign(:,:,1,b);
        BinnedAlignProp(:,:,a,b) = ALL.(an{a}).avgquad.BinnedAlignProp(:,:,1,b);
        BinnedWKdata(:,:,a,b) = ALL.(an{a}).avgquad.BinnedWKdata(:,:,1,b);
        BinnedWKdataProp(:,:,a,b) = ALL.(an{a}).avgquad.BinnedWKdataProp(:,:,1,b);
    end
    volOverlap(a,:) = ALL.(an{a}).avgquad.volOverlap;
    volOverlapRand(a,:) = ALL.(an{a}).avgquad.volOverlapRand;
end
    % overall data
    ALL.avg.WKdata = mean(WKdata,3,'omitnan');
    temp = ~isnan(WKdata);
    n = sum(temp,3);
    ALL.sem.WKdata = std(WKdata,0,3,'omitnan') ./ sqrt(n);
    ALL.avg.WKdataProp = mean(WKdataProp,3,'omitnan');
    temp = ~isnan(WKdataProp);
    n = sum(temp,3);
    ALL.sem.WKdataProp = std(WKdataProp,0,3,'omitnan') ./ sqrt(n);
    ALL.avg.AlignData = mean(AlignData,3,'omitnan');
    temp = ~isnan(AlignData);
    n = sum(temp,3);
    ALL.sem.AlignData = std(AlignData,0,3,'omitnan') ./ sqrt(n);
    ALL.avg.AlignDataProp = mean(AlignDataProp,3,'omitnan');
    temp = ~isnan(AlignDataProp);
    n = sum(temp,3);
    ALL.sem.AlignDataProp = std(AlignDataProp,0,3,'omitnan') ./ sqrt(n);
    ALL.avg.Dists = mean(Dists,1,'omitnan');
    ALL.avg.DistsAll = Dists;
    ALL.sem.Dists = std(Dists,0,1,'omitnan') ./ sqrt(a);
    % binned data
    ALL.avg.BinnedAlign = mean(BinnedAlign,3,'omitnan');
    temp = ~isnan(BinnedAlign);
    n = sum(temp,3);
    ALL.sem.BinnedAlign = std(BinnedAlign,0,3,'omitnan') ./ sqrt(n);
    ALL.avg.BinnedAlignProp = mean(BinnedAlignProp,3,'omitnan');
    temp = ~isnan(BinnedAlignProp);
    n = sum(temp,3);
    ALL.sem.BinnedAlignProp = std(BinnedAlignProp,0,3,'omitnan') ./ sqrt(n);
    ALL.avg.BinnedWKdata = mean(BinnedWKdata,3,'omitnan');
    temp = ~isnan(BinnedWKdata);
    n = sum(temp,3);
    ALL.sem.BinnedWKdata = std(BinnedWKdata,0,3,'omitnan') ./ sqrt(n);
    ALL.avg.BinnedWKdataProp = mean(BinnedWKdataProp,3,'omitnan');
    temp = ~isnan(BinnedWKdataProp);
    n = sum(temp,3);
    ALL.sem.BinnedWKdataProp = std(BinnedWKdataProp,0,3,'omitnan') ./ sqrt(n);
%     ALL.avg.BinnedTerrR = mean(BinnedTerrR,1,'omitnan');
%     ALL.sem.BinnedTerrR = std(BinnedTerrR,[],1,'omitnan') ./ sqrt(a);
%     ALL.avg.BinnedTerrRrot = mean(BinnedTerrRrot,1,'omitnan');
%     ALL.sem.BinnedTerrrot = std(BinnedTerrRrot,[],1,'omitnan') ./ sqrt(a);
    ALL.avg.BinnedDists = mean(BinnedDists,3,'omitnan');
    ALL.avg.BinnedDistsALL = BinnedDists;
    ALL.sem.BinnedDists = std(BinnedDists,0,3,'omitnan') ./ sqrt(a);
    ALL.avg.volOverlapPerAn = volOverlap;
    ALL.avg.volOverlapRandPerAn = volOverlapRand;
    ALL.avg.volOverlap = mean(volOverlap,1);
    ALL.sem.volOverlap = std(volOverlap,0,1) ./ sqrt(a);
    ALL.avg.volOverlapRand = mean(volOverlapRand,1);
    ALL.sem.volOverlapRand = std(volOverlapRand,0,1) ./ sqrt(a);
    %LP
    ALL.avg.BinnedLPnum = mean(BinnedLPnum,1,'omitnan');
    ALL.sem.BinnedLPnum = std(BinnedLPnum,0,1,'omitnan') ./ sqrt(a);
    ALL.avg.BinnedLPdist = mean(BinnedLPdist,1,'omitnan');
    ALL.sem.BinnedLPdist = std(BinnedLPdist,0,1,'omitnan') ./ sqrt(a);
    ALL.avg.BinnedLPprop = mean(BinnedLPprop,1,'omitnan');
    ALL.sem.BinnedLPprop = std(BinnedLPprop,0,1,'omitnan') ./ sqrt(a);
    %RP
    ALL.avg.BinnedRPnum = mean(BinnedRPnum,1,'omitnan');
    ALL.sem.BinnedRPnum = std(BinnedRPnum,0,1,'omitnan') ./ sqrt(a);
    ALL.avg.BinnedRPdist = mean(BinnedRPdist,1,'omitnan');
    ALL.sem.BinnedRPdist = std(BinnedRPdist,0,1,'omitnan') ./ sqrt(a);
    ALL.avg.BinnedRPprop = mean(BinnedRPprop,1,'omitnan');
    ALL.sem.BinnedRPprop = std(BinnedRPprop,0,1,'omitnan') ./ sqrt(a);
    %RPrand
    ALL.avg.BinnedRPrandnum = mean(BinnedRPrandnum,1,'omitnan');
    ALL.sem.BinnedRPrandnum = std(BinnedRPrandnum,0,1,'omitnan') ./ sqrt(a);
    ALL.avg.BinnedRPranddist = mean(BinnedRPranddist,1,'omitnan');
    ALL.sem.BinnedRPranddist = std(BinnedRPranddist,0,1,'omitnan') ./ sqrt(a);
    ALL.avg.BinnedRPrandprop = mean(BinnedRPrandprop,1,'omitnan');
    ALL.sem.BinnedRPrandprop = std(BinnedRPrandprop,0,1,'omitnan') ./ sqrt(a);
end