function plotL1terr_ctrl(ctrlAvg)
ALL = ctrlAvg;
vol = 'a4160216';
f = fieldnames(ALL.(vol));
name = f{2};
[~,centerJ,~] = getVertices(name);
xyscale = 0.41512723649798663290298476483042;
centerS = [centerJ(1:2).*xyscale centerJ(3).*3];
vectorTot = sum(getVector(ALL.(vol).(name).binned.series.b1));
tps = fieldnames(ALL.(vol).(name).binned.series.b1);
series = ALL.(vol).(name).binned.series.b1;
stblidxb = ismember(series.(tps{1})(:,1), series.(tps{end})(:,1));
stblidxl = ismember(series.(tps{end})(:,1), series.(tps{1})(:,1));
newidx = ~ismember(series.(tps{end})(:,1), series.(tps{1})(:,1)); 
lostidx = ~ismember(series.(tps{1})(:,1), series.(tps{end})(:,1));
L1NewCoords = ALL.(vol).(name).binned.series.b1.(tps{end})(newidx, end-2:end) + centerS;
L1BslnStblCoords = ALL.(vol).(name).binned.series.b1.tp0(stblidxb, end-2:end) + centerS;
L1LastStblCoords = ALL.(vol).(name).binned.series.b1.(tps{end})(stblidxl, end-2:end) + centerS;
n = (L1NewCoords);
n = [n(:,1:2) n(:,end).*-1];
n = n(n(:,3)>-130,:);
szn = size(n,1);
cn = [zeros(szn,1) ones(szn,1) zeros(szn,1)];
s = L1BslnStblCoords + vectorTot;
s = [s(:,1:2) s(:,end).*-1];
s = s(s(:,3)>-130,:);
szs = size(s,1);
cs = [zeros(szs,1) zeros(szs,1) zeros(szs,1)];
sl = L1LastStblCoords;
sl = [sl(:,1:2) sl(:,end).*-1];
sl = sl(sl(:,3)>-130,:);
rnxy = ones(szn,1).*75.7;
rnz = ones(szn,1).*32.2;
rsxy = ones(szs,1).*75.7;
rsz = ones(szs,1).*32.2;
figure
subplot(1,3,1)
hold on
bubbleplot3(s(:,1),s(:,2),s(:,3),[rsxy rsxy rsz],cs,0.2,[],[]);
hold off
xlim([-80 510])
ylim([-80 510])
zlim([-180 0])
zticks([-100 0])
set(gca,'Yticklabel',[]) 
set(gca,'Xticklabel',[]) 
set(gca,'Zticklabel',[]) 
camlight right; 
lighting phong; 
view(28, 55);
ax = gca;
ax.FontSize = 10;
ax.FontName = 'Arial';
ax.GridColor = 'k';
ax.GridAlpha = 0.3;
box on

subplot(1,3,2)
hold on
bubbleplot3(n(:,1),n(:,2),n(:,3),[rnxy rnxy rnz],cn,0.4,[],[]);
bubbleplot3(sl(:,1),sl(:,2),sl(:,3),[rsxy rsxy rsz],cs,0.2,[],[]);
hold off
xlim([-80 510])
ylim([-80 510])
zlim([-180 0])
zticks([-100 0])
set(gca,'Yticklabel',[]) 
set(gca,'Xticklabel',[]) 
set(gca,'Zticklabel',[]) 
camlight right; 
lighting phong; 
view(28, 55);
ax = gca;
ax.FontSize = 10;
ax.FontName = 'Arial';
ax.GridColor = 'k';
ax.GridAlpha = 0.3;
box on

subplot(1,3,3)
hold on
bubbleplot3(n(:,1),n(:,2),n(:,3),[rnxy rnxy rnz],cn,0.4,[],[]);
bubbleplot3(s(:,1),s(:,2),s(:,3),[rsxy rsxy rsz],cs,0.2,[],[]);
bubbleplot3(sl(:,1),sl(:,2),sl(:,3),[rsxy rsxy rsz],cs,0.2,[],[]);
hold off
xlim([-80 510])
ylim([-80 510])
zlim([-180 0])
zticks([-100 0])
set(gca,'Yticklabel',[]) 
set(gca,'Xticklabel',[]) 
set(gca,'Zticklabel',[]) 
camlight right; 
lighting phong; 
view(28, 55);
ax = gca;
ax.FontSize = 10;
ax.FontName = 'Arial';
ax.GridColor = 'k';
ax.GridAlpha = 0.3;
box on