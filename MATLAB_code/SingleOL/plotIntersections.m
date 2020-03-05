function intersects = plotIntersections(ALL)
cond = {'ctrl','cupr'};
intersects = struct;
    for c = 1:2
        intersects.(cond{c}) = [];
        cells = fieldnames(ALL.(cond{c}));
        for k = 1:length(cells)
            temp = [ALL.(cond{c}).(cells{k}).raw.d00.Sheath_Info.intersections, ALL.(cond{c}).(cells{k}).raw.d00.Sheath_Info.intLengths];
            days = fieldnames(ALL.(cond{c}).(cells{k}).raw);
            if contains(days{end},'d14') || contains(days{end},'d15')
                temp2 = [ALL.(cond{c}).(cells{k}).raw.(days{end}).Sheath_Info.intersections, ALL.(cond{c}).(cells{k}).raw.(days{end}).Sheath_Info.intLengths];
                intersects.(cond{c}) = [intersects.(cond{c}); temp,temp2];
            else
                intersects.(cond{c}) = [intersects.(cond{c}); temp,NaN(size(temp))];
            end
        end
    end
% figure
% hold on
% d00 = intersects.ctrl(1:50,1);
% d14 = intersects.ctrl(1:50,3);
% plot([d00,d14]','ko-')
% hold off
[c1,c2] = getFigColors;
figure
hold on
subplot(2,1,1)
ctrl = intersects.ctrl;
s = RandStream('mlfg6331_64');
[~,idx] = datasample(s,ctrl,round(size(ctrl,1)/2),1,'Replace',false);
ctrl(idx,1) = 100 - ctrl(idx,1);
plot(ctrl(:,1),ctrl(:,2),'.','Color',c1);
xlim([-5 105])
ylim([0 200])
xticks([0 50 100])
xticklabels([-1 0 1])
xlabel('relative process position')
ylabel('myelin sheath length (\mum)')
box off
hold off

subplot(2,1,2)
hold on
cupr = intersects.cupr;
s = RandStream('mlfg6331_64');
[~,idx] = datasample(s,cupr,round(size(cupr,1)/2),1,'Replace',false);
cupr(idx,1) = 100 - cupr(idx,1);
plot(cupr(:,1),cupr(:,2),'.','Color',c2);
xlim([-5 105])
xticks([0 50 100])
xticklabels([-1 0 1])
xlabel('relative process position')
ylabel('myelin sheath length (\mum)')
hold off
figQuality(gcf,gca,[3 5])

end
    