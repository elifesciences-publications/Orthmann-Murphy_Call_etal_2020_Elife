function plotExample3Dvols(ctrl,cupr)
for i = 1:2
    if i==1
        ALL = cupr;
        vol = 'a4151201';
        f = fieldnames(cupr.(vol));
        name = f{2};
    else
        ALL = ctrl;
        vol = 'a4160216';
        f = fieldnames(ctrl.(vol));
        name = f{2};
    end
    
    [~,centerJ,~] = getVertices(name);
    xyscale = 0.41512723649798663290298476483042;
    centerS = [centerJ(1:2).*xyscale centerJ(3).*3];
    vectorTot = sum(getVector(ALL.(vol).(name).series));        
    
    tp = fieldnames(ALL.(vol).(name).series);
    series  = ALL.(vol).(name).series;
    stblIdx = ismember(series.(tp{end})(:,1),series.(tp{1})(:,1));
    degenIdx = ~ismember(series.(tp{1})(:,1),series.(tp{end})(:,1));
    newIdx = ~ismember(series.(tp{end})(:,1),series.(tp{1})(:,1));
    StblCoords = ALL.(vol).(name).series.(tp{end})(stblIdx, end-2:end) + centerS;
    DegenCoords = ALL.(vol).(name).series.tp0(degenIdx, end-2:end) + centerS;
    NewCoords = ALL.(vol).(name).series.(tp{end})(newIdx, end-2:end) + centerS;
    % define stbl coords
    s = (StblCoords);
    s = [s(:,1:2) s(:,end).*-1];
    szs = size(s,1);
    cs = [zeros(szs,1) zeros(szs,1) zeros(szs,1)];
    % define degen coords
    d = (DegenCoords + vectorTot);
    d = [d(:,1:2) d(:,end).*-1];
    szd = size(d,1);
    cd = [ones(szd,1) zeros(szd,1) ones(szd,1)];
    % define new coords
    n = NewCoords;
    n = [n(:,1:2) n(:,end).*-1];
    szn = size(n,1);
    cn = [zeros(szn,1) ones(szn,1) zeros(szn,1)];
    % define radii
    rs = ones(szs,1).*5;
    rd = ones(szd,1).*5;
    rn = ones(szn,1).*5;
    
    figure
    bubbleplot3(s(:,1),s(:,2),s(:,3),rs,cs,0.6,[],[]);
    hold on;
    bubbleplot3(d(:,1),d(:,2),d(:,3),rd,cd,0.6,[],[]);
    bubbleplot3(n(:,1),n(:,2),n(:,3),rn,cn,0.6,[],[]);
    xlim([0 450])
    ylim([0 450])
    zlim([-400 0])
    camlight right; 
    lighting phong; 
    view(28, 55);
    ax = gca;
    ax.FontSize = 10;
    ax.FontName = 'Arial';
    ax.GridColor = 'k';
    ax.GridAlpha = 0.3;
    hold off
    view([32 23])
    figQuality(gcf,gca,[4 3])
    if i == 2
        last = s;
        stblIdxB = ismember(series.(tp{1})(:,1),series.(tp{end})(:,1));
        StblCoordsB = ALL.(vol).(name).series.(tp{end})(stblIdx, end-2:end) + centerS;
        bsln = (StblCoordsB + vectorTot);
        bsln = [bsln(:,1:2) bsln(:,end).*-1];
        szb = size(bsln,1);
        cb = [ones(szb,1) zeros(szb,1) zeros(szb,1)];
        
        figure
        subplot(1,3,1)
        bubbleplot3(bsln(:,1),bsln(:,2),bsln(:,3),rs,cb,0.3,[],[]);
        xlim([0 450])
        ylim([0 450])
        zlim([-400 0])
        camlight right; 
        lighting phong; 
        view(28, 55);
        ax = gca;
        ax.FontSize = 10;
        ax.FontName = 'Arial';
        ax.GridColor = 'k';
        ax.GridAlpha = 0.3;
        view([32 23])
        
        subplot(1,3,2)
        bubbleplot3(last(:,1),last(:,2),last(:,3),rs,cs,0.3,[],[]);
        xlim([0 450])
        ylim([0 450])
        zlim([-400 0])
        camlight right; 
        lighting phong; 
        view(28, 55);
        ax = gca;
        ax.FontSize = 10;
        ax.FontName = 'Arial';
        ax.GridColor = 'k';
        ax.GridAlpha = 0.3;
        view([32 23])
        
        subplot(1,3,3)
        bubbleplot3(last(:,1),last(:,2),last(:,3),rs,cs,0.4,[],[]);
        hold on;
        bubbleplot3(bsln(:,1),bsln(:,2),bsln(:,3),rs,cb,0.4,[],[]);
        xlim([0 450])
        ylim([0 450])
        zlim([-400 0])
        camlight right; 
        lighting phong; 
        view(28, 55);
        ax = gca;
        ax.FontSize = 10;
        ax.FontName = 'Arial';
        ax.GridColor = 'k';
        ax.GridAlpha = 0.3;
        hold off
        view([32 23])
    end
end
end

