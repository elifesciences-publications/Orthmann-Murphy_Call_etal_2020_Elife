% with structs you want to access things by dot notation, so to access the
% x points, the command would be pStruct.path(1).points.x; the code isn't
% perfect and could probably use some tweaking to clean it up, but it works

%UPDATED 2/22/18 CLC - added smoothing function

function xmlstruct = parseXML(filename)
    tree = xmlread(filename);
    
    xmlstruct = struct('samplespacing',struct([]),'imagesize',struct([]),...
        'paths',[]);
    tracings = tree.getElementsByTagName('tracings').item(0);
    
    xmlstruct.samplespacing = parseAttributes(tracings.getElementsByTagName('samplespacing').item(0));
    xmlstruct.imagesize = parseAttributes(tracings.getElementsByTagName('imagesize').item(0));
    
    % get all path data
    list = tree.getElementsByTagName('path');
    numPaths = list.getLength;
    
    for i=1:numPaths
       xmlstruct.paths(i).attribs = parseAttributes(list.item(i-1)); %since starting with Java, item list starts at 0 in xml file, but matlab list (i) starts at 1
       pnts = list.item(i-1).getElementsByTagName('point');
       numPoints = pnts.getLength;
       pntlist = zeros(5000,6);
       for j=1:numPoints
           pntAttribs = parseAttributes(pnts.item(j-1));
           pnttemp = [str2double(pntAttribs.x) str2double(pntAttribs.xd)... %keep all points so it can be imported back into SNT
               str2double(pntAttribs.y) str2double(pntAttribs.yd) str2double(pntAttribs.z)...
               str2double(pntAttribs.zd)];
           pntlist(j,:) = pnttemp;
       end
       pntlist(~any(pntlist,2),:) = [];
       xmlstruct.paths(i).points = struct('x',pntlist(:,1),'xd',pntlist(:,2),'y',pntlist(:,3),...
           'yd',pntlist(:,4),'z',pntlist(:,5),'zd',pntlist(:,6));
       span = 51;
       method = 'moving';
       xs = smooth(xmlstruct.paths(i).points.xd, span, method);
       ys = smooth(xmlstruct.paths(i).points.yd, span, method);
       zs = smooth(xmlstruct.paths(i).points.zd, span, method);
       smoothed = [xs,ys,zs];
       xmlstruct.paths(i).points.smoothed = smoothed;
       b_real_coords = smoothed(2:end,:);
       a_real_coords = smoothed(1:end-1,:);
       xmlstruct.paths(i).attribs.reallength_smoothed = sum(sqrt(sum((b_real_coords-a_real_coords).^2,2)));
   end
end  %the XML tree is now transformed into a MATLAB structure

% ----- Local function PARSEATTRIBUTES -----
function attributes = parseAttributes(theNode)
% Create attributes structure.

    attributes = [];
    if theNode.hasAttributes
       theAttributes = theNode.getAttributes;
       numAttributes = theAttributes.getLength;
       names = {};
       values = {};
       for count = 1:numAttributes
          attrib = theAttributes.item(count-1);
          names{count} = char(attrib.getName);
          values{count} = char(attrib.getValue);
       end
       
       attributes = cell2struct(values,names,2);
    end
end
