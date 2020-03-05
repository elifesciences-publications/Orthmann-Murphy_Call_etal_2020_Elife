function [avg1,sem1,avg2,sem2,avg3,sem3,stats] = plotRawCellNumberPerBin(in,showstats)
avg1 = in.avg.BinnedWKdata(2:13,2:3,1,1);
sem1 = in.sem.BinnedWKdata(2:13,2:3,1,1);
figure
subplot(1,3,1)
b = barwitherr(sem1,avg1);
b(1).FaceColor = [1 0 1];
b(2).FaceColor = [0 1 0];
b(1).BarWidth = 1;
b(2).BarWidth = 1;
ylim([0 35])
xlabel({'weeks from baseline'})
ylabel({'number of cells'})
box off
figQuality(gcf,gca,[1 1])
avg2 = in.avg.BinnedWKdata(2:13,2:3,1,2);
sem2 = in.sem.BinnedWKdata(2:13,2:3,1,2);
subplot(1,3,2)
b = barwitherr(sem2,avg2);
b(1).FaceColor = [1 0 1];
b(2).FaceColor = [0 1 0];
b(1).BarWidth = 1;
b(2).BarWidth = 1;
ylim([0 35])
xlabel({'weeks from baseline'})
box off
avg3 = in.avg.BinnedWKdata(2:13,2:3,1,3);
sem3 = in.sem.BinnedWKdata(2:13,2:3,1,3);
subplot(1,3,3)
b = barwitherr(sem3,avg3);
b(1).FaceColor = [1 0 1];
b(2).FaceColor = [0 1 0];
b(1).BarWidth = 1;
b(2).BarWidth = 1;
ylim([0 35])
xlabel({'weeks from baseline'})
figQuality(gcf,gca,[6 1.6])
%% stats for 1 vs 3 comparison (recovery timepoints ONLY)
an = fieldnames(in);
an = an(1:end-2);
b1 = zeros(9,length(an));
b3 = zeros(9,length(an));
for a = 1:length(an)
    new1 = in.(an{a}).avgquad.BinnedWKdata(5:13,3,1,1);
    new3 = in.(an{a}).avgquad.BinnedWKdata(5:13,3,1,3);
    b1(:,a) = new1;
    b3(:,a) = new3;
end
data = [b1(:);b3(:)];
animal = repmat(an,1,9)';
animal = animal(:);
animals = [animal; animal];
bin1 = {'bin1'};
bin3 = {'bin3'};
bin = [repmat(bin1,size(animal)); repmat(bin3,size(animal))];
tps = 1:9;
timepoint = repmat(tps',length(an).*2,1);
% nandex = isnan(data);
% data(nandex) = [];
% animals(nandex) = [];
% bin(nandex) = [];
% timepoint(nandex) = [];
if showstats
    displ = 'on';
else
    displ = 'off';
end
[~,stats.anovatbl,stats.anovastats] = anovan(data,{animals,bin,timepoint},'varnames',{'animal','bin','timepoint'},'random',1,'model',[0 1 0; 0 0 1; 0 1 1],'display',displ);
[~,p,stats.ttci,stats.ttstats] = ttest2(b1',b3');
stats.ttpbf = p.*9;
if showstats
    figure
    multcompare(stats.anovastats,'Dimension',[2 3]);
    figure
    multcompare(stats.anovastats,'Dimension',2);
end
