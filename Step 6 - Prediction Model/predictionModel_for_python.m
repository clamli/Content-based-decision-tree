%% Load
% load dt_model
% load UI_matrix_train & UI_matrix_test
% load item_sim_matrix
% load train_list & test_list

%% Options
% Traditional FDT model without score, using like dislike & unknown interval
FDT_mode = 0;
% Traditional FDT MF contruction method. Build MF on each level
Multiple_MF_mode = 1;
% Train MF with score
MF_with_score_mode = 0;
% Calculate RMSE without ratings obtained from query process.
RMSE_without_queried_ratings_mode = 1;
% Weight of score
weight = 0.01;
% Index of user subset
subsetNum = 1;
% Dataset selected
name = '1m';
if strcmp(name, '20m')
    subset_userNum = 13849;
else
    subset_userNum = 2014;
end
%% Outload dtmodel file
tree = dtmodel.tree;
lr_bound = cell(1, length(dtmodel.tree_bound));
for i = 1 : length(dtmodel.tree_bound)
    lr_bound{i} = cell2mat(dtmodel.tree_bound{i});
end
save('treeFile/tree.mat', 'tree')
save('treeFile/lr_bound.mat', 'lr_bound')

%%	Pre-process
totalDepth = length(dtmodel.tree_bound);
[user_num, item_num_test] = size(UI_matrix_test);

cluster_matrix = generateItemClusRMatrix(...
    FDT_mode, dtmodel.user_cluster,...
    item_sim_matrix(test_list, test_list), weight,...
    single(full(UI_matrix_test)));
prediction_model = cell(2, totalDepth);
if Multiple_MF_mode
    for Depth = 1 : totalDepth
        pseudo_items = zeros(1, 0);
        all_nodes = dtmodel.tree_bound{Depth};
        for i = 1 : length(all_nodes)
            if all_nodes{i}(1) <= all_nodes{i}(2)
                pseudo_items = [pseudo_items; all_nodes{i}];
            end
        end
        pseudo_itemNum = size(pseudo_items, 1);
        prediction_model{1, Depth} = cell(pseudo_itemNum, 1);
        for i = 1 : pseudo_itemNum
           prediction_model{1, Depth}{i, 1} =  pseudo_items(i, :);
        end
    end
end

for chosenDepth = 1:totalDepth
    disp(['Current depth: ', num2str(chosenDepth)])
    %% Get Leaf nodes of Decision Tree
    if Multiple_MF_mode
        pseudo_items = prediction_model{1, chosenDepth};
    else
        pseudo_items = traverseTree(dtmodel.tree_bound, 1, 1, 0, chosenDepth)';
    end

    %% Form pseudo_matrix
    if MF_with_score_mode
        %% Use score or real rating to train MF
        UI_matrix_train = single(full(UI_matrix_train));
        score_matrix_train = (UI_matrix_train == 0)...
            .* (UI_matrix_train       * item_sim_matrix(train_list, train_list));
        score_matrix_train = UI_matrix_train + score_matrix_train ./ ...
              ((UI_matrix_train ~= 0) * item_sim_matrix(train_list, train_list));
        [pseudo_matrix, pseudo_items] = getPseudo_matrix(...
                            pseudo_items, score_matrix_train); 
    else
        [pseudo_matrix, pseudo_items] = getPseudo_matrix(...
                            pseudo_items, UI_matrix_train); 
    end
    if Multiple_MF_mode
        prediction_model{1, chosenDepth} = pseudo_items;
    end    
    
    %% Find target node
    if FDT_mode
        interval_bound = [];
    else
        interval_bound = {dtmodel.interval_bound{1:chosenDepth - 1}};
    end
    
    [targetNode, ~, rated_user] = getTargetNode(...
         RMSE_without_queried_ratings_mode, dtmodel.user_cluster,...
         UI_matrix_test, cluster_matrix,...
         {dtmodel.split_cluster{1 : chosenDepth - 1}},...
         {dtmodel.tree_bound{1 : chosenDepth}}, ...
         interval_bound, FDT_mode);
    for i = 1 : length(rated_user)
        if ~isempty(rated_user{i})
            for j = 1:length(rated_user{i})
                rated_user{i}(j) = rated_user{i}(j) + (subsetNum - 1) * subset_userNum;
            end
        end
    end
    save(['treeFile/targetNode_', num2str(chosenDepth), '.mat'], 'targetNode')
    save(['treeFile/rated_user_', num2str(chosenDepth), '.mat'], 'rated_user')
end



