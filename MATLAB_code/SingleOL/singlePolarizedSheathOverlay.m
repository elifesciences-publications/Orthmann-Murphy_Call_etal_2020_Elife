function singlePolarizedSheathOverlay(ALL,xmlstruct)
%% single example overlaid on sheath data
cond = 'ctrl';
an = 'a411_2_r1c1';
day = 'd14';
data = ALL.(cond).(an).raw.(day);
p = [data.Sheath_Info.pnode1coords; data.Sheath_Info.pnode2coords];
idx = [];
for i = 1:length(p)
    if isnan(p{i})
       idx = [idx, i];
    end
end
p(idx) = [];
p = cell2mat(p);
% p(:,3) = p(:,3).*-1;
center = getCenter(an);
p = p-center;
n = size(p,1);
vectsum = sum(p,1);
figure
hold on
plotVolumes(an, data.sheathIndex, xmlstruct, cond)
for i = 1:size(p,1)
    lh = plot([0; p(i,1)], [0; p(i,2)], 'k-');
end
hold off
xlim([-180 180])
ylim([-180 180])
figQuality(gcf,gca,[4 3.5])