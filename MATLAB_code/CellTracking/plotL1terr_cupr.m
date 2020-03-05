function plotL1terr_cupr(cuprAvg)
% Good quads for cupr bubbleplot: v235 quad1, v235 quad3,  a1141124 r001, a4151201 r033, a5151201 r097
ALL = cuprAvg;
vol = 'a1141124';
f = fieldnames(cuprAvg.(vol));
name = f{1};
[~,centerJ,~] = getVertices(name);
xyscale = 0.41512723649798663290298476483042;
centerS = [centerJ(1:2).*xyscale centerJ(3).*3];
vectorTot = sum(getVector(cuprAvg.(vol).(name).binned.series.b1));
tps = fieldnames(ALL.(vol).(name).binned.series.b1);
series = ALL.(vol).(name).binned.series.b1;
stblidxb = ismember(series.(tps{1})(:,1),series.(tps{end})(:,1));
stblidxl = ismember(series.(tps{end})(:,1),series.(tps{1})(:,1));
% numStblCells = sum(stblidxb);
L1BslnCoords = ALL.(vol).(name).binned.series.b1.tp0(~stblidxb, end-2:end) + centerS;
L1LastCoords = ALL.(vol).(name).binned.series.b1.(tps{end})(~stblidxl, end-2:end) + centerS;
L1BslnStblCoords = ALL.(vol).(name).binned.series.b1.tp0(stblidxb, end-2:end) + centerS;
L1LastStblCoords = ALL.(vol).(name).binned.series.b1.(tps{end})(stblidxl, end-2:end) + centerS;
b = (L1BslnCoords + vectorTot);
b = [b(:,1:2) b(:,end).*-1];
szb = size(b,1);
cb = [ones(szb,1) zeros(szb,1) ones(szb,1)];
l = L1LastCoords;
l = [l(:,1:2) l(:,end).*-1];
szl = size(l,1);
cl = [zeros(szl,1) ones(szl,1) zeros(szl,1)];
s = L1BslnStblCoords + vectorTot;
s = [s(:,1:2) s(:,end).*-1];
s = s(s(:,3)>-130,:);
szs = size(s,1);
cs = [zeros(szs,1) zeros(szs,1) zeros(szs,1)];
sl = L1LastStblCoords;
sl = [sl(:,1:2) sl(:,end).*-1];
sl = sl(sl(:,3)>-130,:);
rbxy = ones(szb,1).*75.7;
rbz = ones(szb,1).*32.2;
rlxy = ones(szl,1).*85.25;
rlz = ones(szl,1).*33.75;

figure
subplot(1,3,1)
hold on
bubbleplot3(b(:,1),b(:,2),b(:,3),[rbxy rbxy rbz],cb,0.3,[],[]);
bubbleplot3(s(:,1),s(:,2),s(:,3),[rbxy(1) rbxy(1) rbz(1)],cs,0.3,[],[]);
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
bubbleplot3(l(:,1),l(:,2),l(:,3),[rlxy rlxy rlz],cl,0.3,[],[]);
bubbleplot3(sl(:,1),sl(:,2),sl(:,3),[rbxy(1) rbxy(1) rbz(1)],cs,0.3,[],[]);
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
bubbleplot3(b(:,1),b(:,2),b(:,3),[rbxy rbxy rbz],cb,0.15,[],[]);
bubbleplot3(l(:,1),l(:,2),l(:,3),[rlxy rlxy rlz],cl,0.3,[],[]);
bubbleplot3(s(:,1),s(:,2),s(:,3),[rbxy(1) rbxy(1) rbz(1)],cs,0.2,[],[]);
bubbleplot3(sl(:,1),sl(:,2),sl(:,3),[rbxy(1) rbxy(1) rbz(1)],cs,0.2,[],[]);
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