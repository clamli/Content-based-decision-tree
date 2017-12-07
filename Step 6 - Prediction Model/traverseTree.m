function [ pseudo_items ] =...
   traverseTree(...
    tree_bound, level, nodeNum,...
    isParentCounted, desiredDepth)
pseudo_items = cell(1, 0);
emptyNum = 0;
if level == 1
    parentNode = tree_bound{1, 1};
else
    parentNode = tree_bound{1,level}{nodeNum};
end
for i = 3 * nodeNum - 2 : 3 * nodeNum    
    currentNode = tree_bound{1,level + 1}{i};
    if (currentNode(1,1) - currentNode(1,2) == 1)
        emptyNum = emptyNum + 1;
    end
end
for i = 3 * nodeNum - 2 : 3 * nodeNum
    currentNode = tree_bound{1,level + 1}{i};
    % empty node    
    if (currentNode(1,1) - currentNode(1,2) == 1)
        if isParentCounted == 0 && emptyNum ~= 2
            pseudo_items = [pseudo_items, parentNode];
            isParentCounted = 1;
        else
            continue
        end
    elseif level < desiredDepth - 1    
        pseudo_items = [pseudo_items, traverseTree(tree_bound, level + 1, i, 0, desiredDepth)];
    % leaf node
    else 
        pseudo_items = [pseudo_items, currentNode];
    end
end

