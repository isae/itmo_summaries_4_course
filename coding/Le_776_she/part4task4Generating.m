

%   %example from book
%  H = [ 
%      1 1 0 0 1 1
%      0 0 1 0 1 1 
%      0 1 0 1 0 1
%      ]
% 
%  Gbin = [
%      1 1 0 1 0 0
%      0 1 1 1 1 0
%      0 0 0 1 1 1
%      ]
%  Gmsf = Gbin;

 


  %code from chapter 2
  H = [ 
        0     1     1     0     1     1     0     1     0     0
        1     1     1     1     0     0     0     0     0     0
        1     0     0     1     0     1     0     1     1     1
        0     0     1     1     1     0     1     1     0     1
      ]
  
  Gbin = [ 
           1     1     0     0     0     0     1     1     0     0
           0     0     0     0     0     0     1     0     1     1
           0     1     1     0     0     0     1     0     0     0
           0     1     0     1     0     0     0     1     0     0
           0     0     0     0     1     0     0     1     1     0
           0     0     0     0     0     1     1     1     0     0
         ]

        
% convert generating matrix by msm manualy
% this different for others matrixes
G0 = Gbin
G1 = mod([G0(1, :); G0(3:6, :); G0(2, :)], 2)
G2 = mod([G1(1:2, :); G1(3, :) + G1(2,:); G1(4:end, :)], 2)
G3 = mod([G2(1:2, :); G2(3, :) + G2(5,:); G2(4:end, :)], 2)
Gmsf = mod([G3(1, :) + G3(3,:) + G3(5,:);  G3(2:end, :)], 2)

% 
[k, n] = size(Gbin)
R=k/n % code speed
r = n - k
M=2^k % number of codewords

%generating matring in word form
Gword=bin2word(Gbin);
CODEinWord=g2code(Gword);
CODEinBin=word2bin(CODEinWord);

maxLayer = n + 1;

%grid by generating matrix



% check that Gmsf is correct
if length(find(mod(Gmsf*H', 2))) > 0 
    error('Gmsf is not ortogonal to H');
end;

GmsfRows = num2cell(Gmsf, 2)
RowsNonZeroIndexes = cellfun(@find, GmsfRows, 'UniformOutput', false)

firstActive = cellfun(@min, RowsNonZeroIndexes)';
lastActive = cellfun(@max, RowsNonZeroIndexes)' - 1 ;

if length(firstActive) ~= length(unique(firstActive))
    error('minActive not unique. G is not in MSF')
end;

if length(lastActive) ~= length(unique(lastActive))
    error('lastActive not unique. G is not in MSF')
end;



layerActive = cell(1, maxLayer);
layerActive{1} = []; %nothing active on first layer

%add add row to active list for each layer where it is active
for rowInd = 1:k
    range = (firstActive(rowInd):lastActive(rowInd)) + 1;
    for activeInLayer = range
        layerActive{activeInLayer}(end + 1) = rowInd;
    end;
end;

%num of nodes in layer
layerActiveSize = cellfun(@(x) size(x, 2), layerActive)
maxLayerActive = max(layerActiveSize);
layerSizes = 2.^ layerActiveSize;

%uhique id for graph node by layer and avtiveVals 
nodeId = @(layer, activeVals) bitor(bitshift(layer,maxLayerActive), bin2word([0, activeVals]));
nodeId2layer = @(nId) bitshift(nId, -maxLayerActive);
nodeId2activeValsWord = @(nId) bitand(nId, 2^maxLayerActive-1);


% structure for graph eges
% size will grow in future
fromIds   = zeros(1, 0);
toIds  = fromIds;
weights = fromIds;

%generate edges  by layer from first
for fromLayer = 1:(maxLayer - 1)

    %calculate data common for this edge layer
    toLayer   = fromLayer + 1;

    fromActive = layerActive{fromLayer};
    toActive   = layerActive{toLayer};

    allActive = unique([fromActive, toActive])

    %indexes of from/to Active
    [~, fromActiveValsIndexes] = find(ismember(allActive, fromActive));
    [~, toActiveValsIndexes]   = find(ismember(allActive, toActive));

    subG = Gmsf(allActive, fromLayer);

    allActiveNum = length(allActive);
    for allActiveValsWord = 0:2^allActiveNum-1
        allActiveVals = word2bin(allActiveValsWord, allActiveNum);

        fromActiveVals = allActiveVals(fromActiveValsIndexes);
        toActiveVals   = allActiveVals(toActiveValsIndexes);


        fromIds(end + 1) = nodeId(fromLayer, fromActiveVals);
        toIds(end + 1)   = nodeId(toLayer,   toActiveVals);
        weights(end + 1) = mod(allActiveVals * subG, 2);

    end;
end;

%I think there will be no duplicate edges but try to delete them for sure
%delete duplicates
UniqueEdges = unique([fromIds; toIds; weights]', 'rows')';
fromIds   = UniqueEdges(1,:);
toIds  = UniqueEdges(2,:);
weights = UniqueEdges(3,:);


edgeNum = length(fromIds);


%get active vals str by nodeId
tail = @(str, len) str(end - len + 1: end);
nodeLable = @(nId) flip(tail([repmat('0', 1, r), dec2bin(nodeId2activeValsWord(nId))], layerActiveSize(nodeId2layer(nId))));

nodeIdsSet = unique([fromIds, toIds]);
nodeLables = arrayfun(nodeLable, nodeIdsSet, 'UniformOutput', false);

if not(exist('digraph')) 
    error('No digraph function. Seems that you have matlab older than 2015b, or have no graph toolbox')
end;

graphWithEmptyNodes = digraph(fromIds, toIds, weights);

%remove empty nodes
gridGraph = rmnode(graphWithEmptyNodes, setdiff(1:max(nodeIdsSet), nodeIdsSet));

layers = nodeId2layer(nodeIdsSet);
actValWords = nodeId2activeValsWord(nodeIdsSet);
yData = ones(size(actValWords)) * 2^maxLayerActive - bin2dec(nodeLables)';




    %'Layout', 'layered', ...
gridPlot = plot(gridGraph,...
    'LineWidth', 2, ...
    'MarkerSize', 10, ...
    'NodeColor', 'b', ...
    'XData', layers, ...
    'YData', yData, ...
    'EdgeLabel', gridGraph.Edges.Weight,...
    'NodeLabel', nodeLables);
 

%generate layer lables

active2label = @(x) strcat('m_{', num2str(x), '}');

layerLables = cellfun(@ (x) arrayfun(active2label, fliplr(x), 'UniformOutput', false), layerActive, 'UniformOutput', false);
layerLables = cellfun( @strjoin, layerLables, 'UniformOutput', false);


%draw layer lables
for layer = 1:maxLayer
    lab = texlabel(layerLables(layer));
    text(layer - 0.2, 2 ^ maxLayerActive + 0.3, lab);
end;


%collor edges
EdgeColor = zeros(size(weights, 2), 3);
onesEdgesIndexes  = find(weights==1);
zerosEdgesIndexes = find(weights==0);
EdgeColor(onesEdgesIndexes, :) = repmat([1 0 0], size(onesEdgesIndexes, 2), 1);
EdgeColor(zerosEdgesIndexes, :) = repmat([0 0 1], size(onesEdgesIndexes, 2), 1);
gridPlot.EdgeColor = EdgeColor;



 



        









