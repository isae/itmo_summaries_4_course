
% 
%    %example from book
%   H = [ 
%       1 1 0 0 1 1
%       0 0 1 0 1 1 
%       0 1 0 1 0 1
%       ]
%  
%   Gbin = [
%       1 1 0 1 0 0
%       0 1 1 1 1 0
%       0 0 0 1 1 1
%       ]
%  
% 
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
% make node id in graph by its layer and syndrome



%uhique id for graph node by layer and syndrom 
nodeId = @(layer, syndrome) bitor(bitshift(layer,r), bin2word(syndrome));

nodeId2layer = @(nId) bitshift(nId, -r);
nodeId2syndWord = @(nId) bitand(nId, 2^r-1);

%get syndrom str by nodeId
tail = @(str, len) str(end - len + 1: end);
nodeLable = @(nId) tail([repmat('0', 1, r), dec2bin(nodeId2syndWord(nId))], r);


%generate code prefixes
codePrefixes = cell(1, maxLayer);
for i = 0 : n
    codePrefixes{i + 1} = unique(CODEinBin(:, 1:i), 'rows');
end;


%unique id for code prefix
prefixId = @(prefix) bitor(bitshift(length(prefix) ,n),bin2word(prefix));
prefSyndroms = cell(size(codePrefixes));
prefId2syndMap = containers.Map('KeyType', 'double', 'ValueType', 'any');

for layer = 1:maxLayer
    % part of H matrix
    Hpref = H(:, 1:(layer - 1));
    layPrefSize = size(codePrefixes{layer}, 1);

    %preallocate space for syndroms
    prefSyndroms{layer} = zeros(layPrefSize, r);

    % calculate syndrom for each prefix
    for layPrefIndex = 1 : layPrefSize
        pref = codePrefixes{layer}(layPrefIndex, :);
        synd = mod(pref * Hpref', 2);
        prefSyndroms{layer}(layPrefIndex, :) = synd;
        prefId2syndMap(prefixId(pref)) = synd;
    end;
end;




%get syndrom by prefix
pref2synd = @(pref) prefId2syndMap(prefixId(pref));

%get nodeId in graph by prefix syndrom
pref2nodeId = @(pref) nodeId(length(pref) + 1, pref2synd(pref));


% structure for graph eges
% size will grow in future
inIds   = zeros(1, 0);
outIds  = inIds;
weights = inIds;


% for each prefix length L add edge from prefix syndrom node to syndrom node of length (L - 1)
% there will be many repeated edges, so we need to delete dublicates after

% generate graph nodes from last layer no first
edgeIndex = 1; % next edgeIndex to generate
for minusLayer = -maxLayer: -2
    layer = -minusLayer;
    layPrefSize = size(codePrefixes{layer}, 1);
    % calculate syndrom for each prefix
    for layPrefIndex = 1 : layPrefSize;
        prefix     = codePrefixes{layer}(layPrefIndex, :);
        prevPrefix = prefix(1:end - 1);
        weight     = prefix(end);

        %generate edge from prev index syndrom to current index syndrom with weigh of last bit
        inIds(edgeIndex)   = pref2nodeId(prevPrefix);
        outIds(edgeIndex)  = pref2nodeId(prefix);
        weights(edgeIndex) = weight;

        edgeIndex = edgeIndex + 1;
    end;
end;

%delete duplicates
UniqueEdges = unique([inIds; outIds; weights]', 'rows')';
inIds   = UniqueEdges(1,:);
outIds  = UniqueEdges(2,:);
weights = UniqueEdges(3,:);

nodeIdsSet = unique([inIds, outIds]);
newIds = 1:length(nodeIdsSet);
nodeLables = arrayfun(nodeLable, nodeIdsSet, 'UniformOutput', false);


if not(exist('digraph')) 
    error('No digraph function. Seems that you have matlab older than 2015b, or have no graph toolbox')
end;

graphWithEmptyNodes = digraph(inIds, outIds, weights);

%remove empty nodes
gridGraph = rmnode(graphWithEmptyNodes, setdiff(1:max(nodeIdsSet), nodeIdsSet));

layers = nodeId2layer(nodeIdsSet);
syndWords = nodeId2syndWord(nodeIdsSet);
yData = ones(size(syndWords)) * 2^r  - syndWords;

gridPlot = plot(gridGraph,...
    'LineWidth', 2, ...
    'MarkerSize', 10, ...
    'NodeColor', 'b', ...
    'XData', layers, ...
    'YData', yData, ...
    'EdgeLabel', gridGraph.Edges.Weight,...
    'NodeLabel', nodeLables);



%collor edges
EdgeColor = zeros(size(weights, 2), 3);
onesEdgesIndexes  = find(weights==1);
zerosEdgesIndexes = find(weights==0);
EdgeColor(onesEdgesIndexes, :) = repmat([1 0 0], size(onesEdgesIndexes, 2), 1);
EdgeColor(zerosEdgesIndexes, :) = repmat([0 0 1], size(onesEdgesIndexes, 2), 1);
gridPlot.EdgeColor = EdgeColor;

















































