%% Load
% load dt_model
% load UI_matrix_train & UI_matrix_test
% load item_sim_matrix
% load test_list

chosenDepth = 3;
%% Find target node
% item_cluster_rating_matrix = generateItemClusRMatrix(...
%     dtmodel.user_cluster,...
%     item_sim_matrix(test_list, test_list),...
%     single(full(UI_matrix_test)));
test_item_node_id  =getTargetNode(...
     item_cluster_rating_matrix,...
     {dtmodel.split_cluster{1:chosenDepth - 1}},...
     {dtmodel.tree_bound{1:chosenDepth}}, ...
     {dtmodel.interval_bound{1:chosenDepth - 1}});
 
%% Get Leaf nodes of Decision Tree
pseudo_items = traverseTree(dtmodel.tree_bound, 1, 1, 0, chosenDepth)';

[user_num, ~] = size(UI_matrix_train);
pseudo_item_num = length(pseudo_items);
pseudo_matrix = zeros(user_num, pseudo_item_num);

%% Form pseudo_matrix
for i = 1:pseudo_item_num
    range = pseudo_items{i};
    pseudo_items{i} = num2str(pseudo_items{i});
    pseudo_item = full(UI_matrix_train(:,range(1):range(2)));
    pseudo_matrix(:, i) = sum(pseudo_item, 2) ./ (sum(pseudo_item~=0, 2) + 1e-9);
end

%% Train reg param 
UI_matrix_test = single(full(UI_matrix_test));
[user_num, item_num_test] = size(UI_matrix_test);
lambdas = [%0.000625, 0.00125, 0.0025, ...
           0.005, 0.01,  0.02,  0.04,  0.08, ...
           0.16,  0.32,  0.64,  1.28,  2.56, ...
           5.12, 10.24, 20.48, 40.96, 81.92];
error_rate = zeros(length(lambdas),1);

for i = 1 : length(lambdas)
    %% Generate MF Model
    lambda = lambdas(i);    
    rank = 100;
    disp('MF start:')
    chosen_train = pseudo_matrix;
    chosen_test  = UI_matrix_test;
    P = mf_resys_func(chosen_train, chosen_train~=0, rank, lambda);
    P(P>5) = 5;
    P(P<0) = 0;
    %% Calculate RMSE on Test Set
    P_test = single(zeros(size(chosen_test)));
    for j = 1 : item_num_test
        level = test_item_node_id{j}(1);
        nodeId = test_item_node_id{j}(2); 
        pseudo_item = dtmodel.tree_bound{level}(nodeId);
        m = find(ismember(pseudo_items, num2str(pseudo_item{1})));
        P_test(:, j) = P(:, m);
    end
    P_test = P_test .* (chosen_test~=0);
    rmse_error =...
      (sum(sum((P_test - chosen_test).^2)) / sum(sum((chosen_test~=0))))^0.5;
    error_rate(i) = rmse_error;    
    
    fprintf('lambda %f | RMSE: %f\n',lambda, error_rate(i));
end

%% Save and plot
plot(lambdas, error_rate,'-o');
title(['Normal pcc clustering on tenth of 26m dataset, level ', num2str(chosenDepth)])
ylabel('RMSE');
xlabel('\lambda');
set(gca, 'xscale', 'log');
set(gcf, 'Color' , 'w'  );
save(['../20m tree/error_rate_depth_', num2str(chosenDepth), '.mat'], 'error_rate');



