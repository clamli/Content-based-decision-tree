% load('../data/dtmodel1.mat')

% pseudo_items_cell = cell(1,)
level = 1;
nodeNum = 1;
isParentCounted = 0;
pseudo_items = traverseTree(dtmodel.tree_bound, level, 1, 0)';

load('../../Step 2 - User Clustering/data/UI_matrix_1.mat');

[user_num, ~] = size(UI_matrix);
item_num = length(pseudo_items);
pseudo_matrix = zeros(user_num, item_num);

for i = 1:item_num
    range = pseudo_items{i};
    psudo_item = full(UI_matrix(:,range(1):range(2)));
    pseudo_matrix(:, i) = sum(psudo_item, 2) ./ (sum(psudo_item~=0, 2) + 1e-9);
end

Y = pseudo_matrix;
R = Y~=0;

[item_num, user_num] = size(R);
lambda = 10;
rank = 70;

disp('MF start:')
P = mf_resys_func(Y, R, rank, lambda);

pred_index = R;%setdiff(find(R), find(L_train));

% prediction error
pred_matrix             = zeros(size(P));
pred_matrix(pred_index) = round(P(pred_index));

pred_error = norm(pred_matrix(pred_index) - Y(pred_index), 2)^2 ...
            / norm(Y(pred_index),2)^2;
rmse_error = (norm(pred_matrix(pred_index) - Y(pred_index), 2)^2 / length(pred_index))^0.5;        
fprintf('\n\nNormalization prediction error = %.4f\n', pred_error);       
fprintf('\n\nRMSE predication error = %.4f\n', rmse_error);







