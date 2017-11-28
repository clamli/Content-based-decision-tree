% load('../../data/dtmodel.mat')
load('../../../Step 2 - User Clustering/data/UI_matrix_1_train.mat');
load('../../../Step 2 - User Clustering/data/UI_matrix_test.mat');
load('../../data/test_item_node_id.mat');

%%%%%%%%%%%%%%%%% Get Leaf nodes of Decision Tree %%%%%%%%%%%%%%%%%%%%%
pseudo_items = traverseTree(dtmodel.tree_bound, 1, 1, 0)';

[user_num, ~] = size(UI_matrix);
pseudo_item_num = length(pseudo_items);
pseudo_matrix = zeros(user_num, pseudo_item_num);

for i = 1:pseudo_item_num
    range = pseudo_items{i};
    pseudo_items{i} = num2str(pseudo_items{i});
    pseudo_item = full(UI_matrix(:,range(1):range(2)));
    pseudo_matrix(:, i) = sum(pseudo_item, 2) ./ (sum(pseudo_item~=0, 2) + 1e-9);
end
%%%%%%%%%%%%%%%%% Train reg param %%%%%%%%%%%%%%%%%%%%%
UI_matrix_test_1 = single(full(UI_matrix_test(1 : 27090,:)));
[user_num, item_num_test] = size(UI_matrix_test_1);
lambdas = [0.01, 0.02, 0.04, 0.08, ...
           0.16, 0.32, 0.64, 1.28, ...
           2.56, 5.12, 10.24, 20.48, ...
           40.96,81.92];
error_rate = zeros(length(lambdas),1);
for i=1:length(lambdas)
    %%%%%%%%%%%%%%%%% Generate MF Model %%%%%%%%%%%%%%%%%%%%%
    lambda = lambdas(i);    
    rank = 70;
    disp('MF start:')
    P = mf_resys_func(pseudo_matrix, pseudo_matrix~=0, rank, lambda);
    %%%%%%%%%%%%%%%%% Calculate RMSE on Test Set %%%%%%%%%%%%%%%%%%%%%
    P_test = single(zeros(size(UI_matrix_test_1)));
    for i = 1 : item_num_test
        level = test_item_node_id{i}(1);
        nodeId = test_item_node_id{i}(2); 
        pseudo_item = dtmodel.tree_bound{level}(nodeId);
        j = find(ismember(pseudo_items,num2str(pseudo_item{1})));
        P_test(:, i) = P(:, j);
    end
    P_test = P_test .* (UI_matrix_test_1~=0);
    rmse_error =...
      (sum(sum((P_test - UI_matrix_test_1).^2)) / sum(sum((UI_matrix_test_1~=0))))^0.5;
    error_rate(i) = rmse_error;    
    
    fprintf('lambda %f | RMSE: %f\n',lambda, error_rate(i));
end
plot(lambdas, error_rate,'-o');
ylabel('RMSE');
xlabel('\lambda');
set(gca, 'xscale', 'log');
set(gcf, 'Color' , 'w'  );

clear pseudo_matrix




