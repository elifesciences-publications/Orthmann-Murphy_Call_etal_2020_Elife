function [IntersectionDistribution, ProcessLengths, sheathIndex, procIndex] = calcIntersectionsXMLtimepoint( xmlstruct , Compiled_Data, smoothed )
    if nargin == 1
        Compiled_Data.d00.Sheath_Info.intNames = {};
        smoothed = 1;
    end
    tableData = parseData(xmlstruct, smoothed);   
    traceNames = tableData{:,1};
    traceLengths = cell2mat(tableData{:,2});
    traceColors = tableData{:,3};
    traceSWCs = tableData{:,4};
    % PREALLOCATE VARIABLES
    intNames = {};
    intersections = [];
    intLengths = [];
    fLnth = [];
    cLnth = [];
    node_class = [];
    isbridgecnctd = [];
    hasmltprocs = [];
    pnode1coords = {};
    pnode2coords = {};
    % makes a sorted list of sheath numbers and finds the largest number
    % assigned during tracing (to catch missing sheath numbers)
    if ~isempty(Compiled_Data.d00.Sheath_Info.intNames)
        name = Compiled_Data.d00.Sheath_Info.intNames{end};
        lastSheathNum = str2double(name(2:end));
        lastSheathName = name;
        sheathIndex = find(~contains(traceNames,'Path'));  
    else %called for first timepoint
        sheathIndex = find(~contains(traceNames,'Path'));  
        sheathTraceSize = size(sheathIndex,1);
        sheathNames = traceNames(sheathIndex);
        sheathNumVector = [];
        for i = 1:sheathTraceSize
            namelist = sheathNames{i,1};
            sheathNumVector = [sheathNumVector; str2double(namelist(2:3))];
        end
        lastSheathNum = max(sheathNumVector);
        lastSheathName = ['s', num2str(lastSheathNum, '%02u')]; 
    end
    
    % PARSE CYTOPLASMIC PROCESSES
    procIndex = find(~contains(traceNames,'s')); 
    procNames = traceNames(procIndex);
    procLengths = traceLengths(procIndex);
   
    
    %combines fragments of sheaths together and calculates relative location
    %of cytoplasmic intersection
    searchName = 's01';
    counter = 1;
    isFound = ~isempty(find(contains(traceNames,searchName), 1));
    while ~isFound
        counter = counter + 1; 
        searchName = ['s', num2str(counter, '%02u')]; 
        isFound = ~isempty(find(contains(traceNames,searchName), 1));
    end
    while isFound     
        intSegs_index = find(contains(traceNames,searchName));
        intNames{end+1} = searchName;
        getpnodecoords; % internal function, below, to find coords of sheath ends, to use in vector plot
        %parses the sheath segments and gets the total sheath length
        if any(contains(traceColors(intSegs_index),'yellow'))
            if size(intSegs_index,1) == 1 
                intLengths = [intLengths; traceLengths(intSegs_index)];
                intersections = [intersections; NaN];
                fLnth = [fLnth;NaN];
                cLnth = [cLnth;NaN];
                hasmltprocs = [hasmltprocs; NaN];
            elseif any(contains(traceNames(intSegs_index),'a'))
                intLengths = [intLengths; sum(traceLengths(intSegs_index))];
                intersections = [intersections; NaN];
                fLnth = [fLnth;NaN];
                cLnth = [cLnth;NaN];
                hasmltprocs = [hasmltprocs; NaN];
            else
                calc_2SegInts;
                intersections(end) = NaN;
                hasmltprocs = [hasmltprocs; NaN];
            end
        % exclude "clipped" sheaths (but keep length, although
        % underestimated)
%         elseif any(contains(traceColors(intSegs_index),'black'))
%             calc_2SegInts;
%             intersections(end) = NaN;
%             fLnth(end) = NaN;
%             cLnth(end) = NaN;
%             hasmltprocs = [hasmltprocs; 0];
        % determine if sheath is connected by >1  cytoplasmic process
        elseif any(contains(traceColors(intSegs_index),'white'))
            hasmltprocs = [hasmltprocs; 1];
            if size(intSegs_index,1) == 1
                intersections = [intersections; NaN];
                fLnth = [fLnth;NaN];
                cLnth = [cLnth;NaN];
                intLengths = [intLengths; traceLengths(intSegs_index)];
            else
                calc_2SegInts;
            end
            intersections(end) = NaN;
        elseif size(intSegs_index,1) == 1
            intersections = [intersections; 0];
            fLnth = [fLnth;NaN];
            cLnth = [cLnth;NaN];
            intLengths = [intLengths; traceLengths(intSegs_index)];
            hasmltprocs = [hasmltprocs; 0];
        elseif length(intSegs_index) > 1 && ...
                any(contains(traceNames(intSegs_index),'a'))
            intLengths = [intLengths; sum(traceLengths(intSegs_index))];
            intersections = [intersections; 0];
            fLnth = [fLnth;NaN];
            cLnth = [cLnth;NaN];
            hasmltprocs = [hasmltprocs; 0];
        else
            calc_2SegInts;
            hasmltprocs = [hasmltprocs; 0];
        end
        % determine if sheath segments are heminodes or contribute to nodes
            %1= at least 1 heminode
            %2= at least 1 node
            %3= isolated sheath
            %4= terminal sheath
            %5= continuous sheath
        node_classes = str2double(traceSWCs(intSegs_index));
        if sum(node_classes) == 3
            node_class = [node_class; 1];
        elseif sum(node_classes) == 4
            node_class = [node_class; 2];
        elseif sum(node_classes) == 6 || sum(node_classes == 1)
            node_class = [node_class; 3];
        elseif sum(node_classes) == 7 || sum(node_classes == 2)
            node_class = [node_class; 4];
        elseif sum(node_classes) == 8 || sum(node_classes == 5)
            node_class = [node_class; 5]; %#ok<*AGROW>
        else
            node_class = [node_class; NaN];
        end
        % determine if sheath is connected by paranodal bridge
        if any(contains(traceColors(intSegs_index),'orange')) || any(contains(traceColors(intSegs_index),'#ffc800'))
            isbridgecnctd = [isbridgecnctd; 1];
        else
            isbridgecnctd = [isbridgecnctd; 0];
        end
        % reset the counter and get a new searchName
        counter = counter + 1; 
        searchName = ['s', num2str(counter, '%02u')]; 
        if counter > lastSheathNum
            break
        end
        %catches instances when the sheath number is skipped and continues
        %searching for additional sheaths
%         if ~any(contains(traceNames,searchName)) && searchName > lastSheathNum
%             searchName = searchName;
%         else
        if any(contains(traceNames,searchName))
            searchName = searchName;
        elseif ~any(contains(traceNames,searchName))...
                && any(contains(Compiled_Data.d00.Sheath_Info.intNames,searchName))
            warning('Sheath %s is not present in this timepoint.\n',searchName);
            intNames{end+1} = searchName;
            intersections = [intersections; NaN];
            intLengths = [intLengths; 0];
            fLnth = [fLnth;NaN];
            cLnth = [cLnth;NaN];
            node_class = [node_class; NaN];
            isbridgecnctd = [isbridgecnctd; NaN];
            hasmltprocs = [hasmltprocs; NaN];
            pnode1coords = [pnode1coords; NaN];
            pnode2coords = [pnode2coords; NaN];
            while ~any(contains(traceNames,searchName))
                counter = counter + 1;
                if counter > lastSheathNum %prevent infinite loop if last sheath is lost
                    break
                end
                searchName = ['s', num2str(counter, '%02u')];
                if ~any(contains(traceNames,searchName))...
                        && any(contains(Compiled_Data.d00.Sheath_Info.intNames,searchName))
                    warning('Sheath %s is not present in this timepoint.\n',searchName);
                    intNames{end+1} = searchName;
                    intersections = [intersections; NaN];
                    intLengths = [intLengths; 0];
                    fLnth = [fLnth;NaN];
                    cLnth = [cLnth;NaN];
                    node_class = [node_class; NaN];
                    isbridgecnctd = [isbridgecnctd; NaN];
                    hasmltprocs = [hasmltprocs; NaN];
                    pnode1coords = [pnode1coords; NaN];
                    pnode2coords = [pnode2coords; NaN];
                end
            end
        else
            msg1 = ['Could not find sheath ',num2str(counter)];
            msg3 = ['Last sheath number traced: ',num2str(lastSheathNum)];
            fprintf([msg1,'\n', msg3,'\n']);
            while ~any(contains(traceNames,searchName))
                counter = counter + 1;
                if counter > lastSheathNum
                    break
                end
                searchName = ['s', num2str(counter, '%02u')];
            end
        end  
        isFound = any(contains(traceNames,searchName));
    end
intNames = intNames';
    function calc_2SegInts
        c_index = contains(traceNames(intSegs_index),'c'); 
        c_seg = sum(traceLengths(intSegs_index(c_index))); 
        f_index = contains(traceNames(intSegs_index),'f'); 
        f_seg = sum(traceLengths(intSegs_index(f_index))); 
        segs = [c_seg,f_seg];
        shortestSeg = min(segs);
        longestSeg = max(segs);
        fLnth = [fLnth; f_seg];
        cLnth = [cLnth; c_seg];
        intersections = [intersections; shortestSeg/(shortestSeg + longestSeg)*100];
        intLengths = [intLengths; shortestSeg + longestSeg];
    end
    function getpnodecoords
        coords = [];
        for p = 1:length(intSegs_index)
            coords = [coords; xmlstruct.paths(intSegs_index(p)).points.smoothed(1,:)];
            coords = [coords; xmlstruct.paths(intSegs_index(p)).points.smoothed(end,:)];
        end
        coords = unique(coords,'rows');
        for p = 1:size(coords,1)
            base = coords(p,:);
            for t = 1:size(coords,1)
                test = coords(t,:);
                dists(p,t) = calcEuclid(base,test);
            end
        end
        [~,I] = max(dists(:));
        [row, col] = ind2sub(size(dists),I);
        pnode1coords = [pnode1coords; {coords(row,:)}];
        pnode2coords = [pnode2coords; {coords(col,:)}];
    end
IntersectionDistribution = table(intNames, intersections, intLengths, fLnth, cLnth, node_class, isbridgecnctd, hasmltprocs, pnode1coords, pnode2coords);
ProcessLengths = table(procNames, procLengths);
end


%----Local Function----
function [ parsedData ] = parseData(xmlstruct, smoothed)

    %get length of paths list
    numPaths = size(xmlstruct.paths,2); 
    traceName = {};
    traceLength = {};

    for i = 1:numPaths
        temp = xmlstruct.paths(i).attribs.name;
        traceName{i,1} = temp;
        if smoothed == 1
            lengthtype = 'reallength_smoothed';
        elseif smoothed == 0
            lengthtype = 'reallength';
        end
        if ~ischar(xmlstruct.paths(i).attribs.(lengthtype))
            temp2=xmlstruct.paths(i).attribs.(lengthtype);
            traceLength{i,1}=temp2;
        else
            temp2 = str2double(xmlstruct.paths(i).attribs.(lengthtype));
            traceLength{i,1} = temp2;
        end
        temp3 = xmlstruct.paths(i).attribs.color;
        traceColor{i,1} = temp3;
        temp4 = xmlstruct.paths(i).attribs.swctype;
        traceSWC{i,1} = temp4;
    end
parsedData = {traceName,traceLength,traceColor,traceSWC};
end
