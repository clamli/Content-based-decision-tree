load('../data/train_all.mat');

Y = Rating_train;
R = Y~=0;

[item_num, user_num] = size(R);
lambda = 10;
rank = 10;

P = mf_resys_func(Y, R, rank, lambda);

load('../data/data_full.mat');

pred_index = setdiff(find(R), find(L_train));

% prediction error
pred_matrix             = zeros(size(P));
pred_matrix(pred_index) = round(P(pred_index));

pred_error = norm(pred_matrix(pred_index) - Y(pred_index), 2)^2 ...
            / norm(Y(pred_index),2)^2;
rmse_error = (norm(pred_matrix(pred_index) - Y(pred_index), 2)^2 / length(pred_index))^0.5;        
fprintf('\n\nNormalization prediction error = %.4f\n', pred_error);       
fprintf('\n\nRMSE predication error = %.4f\n', rmse_error);






