% edited CLC 20180427
function [ SheathData, Data ] = parseRemyelinatingSheaths_ctrl_v3( xmlstruct )
% If STABLE: magenta
% If LOST(& not replaced): red
% 	Apical = AL1N
% If NOVEL: green
% 	Apical = AL1N
% If STABLE/REPLACED:
%     Magenta/Yellow + …
%           Undefined = (undefined -> undefined)
%         	Soma = soma soma (isol -> isol)
%         	Axon = axon axon (cont -> cont)
%         	Basal = basal basal (term -> term)
%         	Apical = soma axon (isol -> cont)
%         	Fork = soma basal (isol -> term)
%         	End = axon soma (cont -> isol)
%         	Custom = axon basal (cont -> term)
%     Black/Cyan + …
%         	Fork = basal soma (term -> isol)
%         	Custom = basal axon (term -> cont)
%         	Soma = (isol -> undefined)
%           Axon = (cont -> undefined)
%           Basal = (term -> undefined)
%     Blue + ...	
%           Soma = (undefined -> isol)
%           Axon = (undefined -> cont)
%           Basal = (undefined -> term)
%           Apical = (AL1N -> AL1N)
%           Fork = (undefined -> AL1N)
%           End = (AL1N -> undefined)
%     White + …
%           Soma = (AL1N -> isol)
%           Axon = (AL1N -> cont)
%           Basal = (AL1N -> term)
%           Apical = (isol -> AL1N)
%           Fork = (cont -> AL1N)
%           End = (term -> AL1N)
numPaths = size(xmlstruct.paths,2);
intNames = cell(numPaths,1);
chngStatus = zeros(numPaths,1);
nodeStatus = zeros(numPaths,1);
nodeStatusChng = zeros(numPaths,1);
for i = 1:numPaths
    intNames{i,1} = xmlstruct.paths(i).attribs.name;
    color = xmlstruct.paths(i).attribs.color; % 1stable/2lost/3replaced/4novel
    swc = str2double(xmlstruct.paths(i).attribs.swctype); % 1isolated/2continuous/3terminal/4isol-cont/5isol-term/6cont-isol/7cont-term
    % FINAL DESIGNATIONS: 1=isolated; 2=continuous; 3=terminal; 4=AL1N
    switch color
        case 'red'
            chngStatus(i,1) = 2;
            nodeStatus(i,1) = swc;
        case 'green'
            chngStatus(i,1) = 4;   
            nodeStatus(i,1) = swc;
        case 'magenta'
            chngStatus(i,1) = 1;
            if swc < 4
                nodeStatus(i,1) = swc;
                nodeStatusChng(i,1) = swc;
            else
                switch swc
                    case 4
                        nodeStatus(i,1) = 1;
                        nodeStatusChng(i,1) = 2;
                    case 5
                        nodeStatus(i,1) = 1;
                        nodeStatusChng(i,1) = 3;
                    case 6
                        nodeStatus(i,1) = 2;
                        nodeStatusChng(i,1) = 1;
                    case 7
                        nodeStatus(i,1) = 2;
                        nodeStatusChng(i,1) = 3;
                end
            end
        case 'cyan'
            chngStatus(i,1) = 1;
            if swc < 4
                nodeStatus(i,1) = swc;
                nodeStatusChng(i,1) = 0;
            else
                switch swc
                    case 5
                        nodeStatus(i,1) = 3;
                        nodeStatusChng(i,1) = 1;
                    case 7
                        nodeStatus(i,1) = 3;
                        nodeStatusChng(i,1) = 2;
                end
            end
        case 'blue'
            chngStatus(i,1) = 1;
            if swc < 4
                nodeStatus(i,1) = 0;
                nodeStatusChng(i,1) = swc;
            else
                switch swc 
                    case 4
                        nodeStatus(i,1) = 4;
                        nodeStatusChng(i,1) = 4;
                    case 5
                        nodeStatus(i,1) = 0;
                        nodeStatusChng(i,1) = 4;
                    case 6
                        nodeStatus(i,1) = 4;
                        nodeStatusChng(i,1) = 0;
                end
            end
        case 'white'
            chngStatus(i,1) = 1;
            if swc < 4
                nodeStatus(i,1) = 4;
                nodeStatusChng(i,1) = swc;
            else
                switch swc
                    case 4
                        nodeStatus(i,1) = 1;
                        nodeStatusChng(i,1) = 4;
                    case 5
                        nodeStatus(i,1) = 2;
                        nodeStatusChng(i,1) = 4;
                    case 6
                        nodeStatus(i,1) = 3;
                        nodeStatusChng(i,1) = 4;
                end
            end
        otherwise
            chngStatus(i,1) = NaN;
            fprintf('FYI, %s did not have a color assigned. Value is NaN. /n',intNames{i,1});
    end
end

SheathData = table(intNames, chngStatus, nodeStatus, nodeStatusChng);

% replStatus parsing 1stable/2lost/3replaced/4novel
status = {'stbl','lost','chng','novl'};
Data = struct;
for k = 1:4
    if k == 3
        continue
    end
    % total num ints of status
    Data.(status{k}).total = sum(chngStatus(:) == k);
    % all int data for each status
    Data.(status{k}).ints = SheathData(SheathData.chngStatus == k,:);
    % num ints of status that are undetermined
    Data.(status{k}).unkn = sum((SheathData.chngStatus(:) == k) & (SheathData.nodeStatus == 0));
    % num ints of status that are isolated
    Data.(status{k}).isol = sum((SheathData.chngStatus(:) == k) & (SheathData.nodeStatus == 1));
    % num ints of status that are terminal
    term = sum((SheathData.chngStatus(:) == k) & (SheathData.nodeStatus == 3));
    % num ints of status that are continuous
    cont = sum((SheathData.chngStatus(:) == k) & (SheathData.nodeStatus == 2));
    % num ints of status that have at least 1 neighbor
    Data.(status{k}).al1n = sum((SheathData.chngStatus(:) == k) & (SheathData.nodeStatus == 4)) + term + cont;
end
Data.chng= NaN(4);
Data.chng(1,1) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 0));
Data.chng(2,2) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 1) & (SheathData.nodeStatusChng == 1));
Data.chng(2,3) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 1) & (SheathData.nodeStatusChng == 3));
Data.chng(2,4) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 1) & (SheathData.nodeStatusChng == 2));
Data.chng(2,5) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 1) & (SheathData.nodeStatusChng == 4));

Data.chng(3,2) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 3) & (SheathData.nodeStatusChng == 1));
Data.chng(3,3) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 3) & (SheathData.nodeStatusChng == 3));
Data.chng(3,4) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 3) & (SheathData.nodeStatusChng == 2));
Data.chng(3,5) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 3) & (SheathData.nodeStatusChng == 4));

Data.chng(4,2) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 2) & (SheathData.nodeStatusChng == 1));
Data.chng(4,3) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 2) & (SheathData.nodeStatusChng == 3));
Data.chng(4,4) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 2) & (SheathData.nodeStatusChng == 2));
Data.chng(4,5) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 2) & (SheathData.nodeStatusChng == 4));

Data.chng(5,2) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 4) & (SheathData.nodeStatusChng == 1));
Data.chng(5,3) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 4) & (SheathData.nodeStatusChng == 3));
Data.chng(5,4) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 4) & (SheathData.nodeStatusChng == 2));
Data.chng(5,5) = sum((SheathData.chngStatus == 1) & (SheathData.nodeStatus == 4) & (SheathData.nodeStatusChng == 4));

al1n = Data.chng(3:5,:);
Data.chngtot = [sum(Data.chng(1,:),'omitnan');
                sum(Data.chng(2,:),'omitnan');
                sum(al1n(:),'omitnan')];
Data.chngtot = [Data.chngtot; sum(Data.chngtot)];

% nodeStatus parsing 1isolated/2continuous/3terminal/4AL1N
% 1stable/2lost/3replaced/4novel
s = SheathData.chngStatus;
Data.bsln.unkn = sum(SheathData.nodeStatus == 0 & (s==1 | s==2 | s==3));
Data.bsln.isol = sum(SheathData.nodeStatus == 1 & (s==1 | s==2 | s==3));
term = sum(SheathData.nodeStatus == 3 & (s==1 | s==2 | s==3));
cont = sum(SheathData.nodeStatus == 2 & (s==1 | s==2 | s==3));
Data.bsln.al1n = sum(SheathData.nodeStatus == 4 & (s==1 | s==2 | s==3)) + term + cont;
Data.bsln.total = Data.bsln.unkn + Data.bsln.isol + Data.bsln.al1n;

Data.last.unkn = sum(SheathData.nodeStatus == 0 & (s==4)) + sum(SheathData.nodeStatusChng == 0 & (s==1));
Data.last.isol = sum(SheathData.nodeStatus == 1 & (s==4)) + sum(SheathData.nodeStatusChng == 1 & (s==1));
term = sum(SheathData.nodeStatus == 3 & (s==4)) + sum(SheathData.nodeStatusChng == 3 & (s==1));
cont = sum(SheathData.nodeStatus == 2 & (s==4)) + sum(SheathData.nodeStatusChng == 2 & (s==1));
Data.last.al1n = sum(SheathData.nodeStatus == 4 & (s==4)) + sum(SheathData.nodeStatusChng == 4 & (s==1)) + term + cont;
Data.last.total = Data.last.unkn + Data.last.isol + Data.last.al1n;
end
