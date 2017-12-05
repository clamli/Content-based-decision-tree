% Load Data
load('UI_matrix_train.mat')
load('UI_matrix_test.mat')
load('item_sim_matrix_3700_3700.mat')
load('test_list.mat')
UI_matrix_train = single(full(UI_matrix_train));
UI_matrix_test = single(full(UI_matrix_test));
item_sim_matrix = item_sim_matrix / max(max(item_sim_matrix));

%% Train with Matrix Factorization
rank = 100;
lambdas = [5]; 
lambdas_i = [5];
filled_matrix = [UI_matrix_train, zeros(size(UI_matrix_test))];
for i = 1:size(lambdas, 2)       
    P = kmf_resys_func(filled_matrix, filled_matrix~=0, rank, lambdas(i), lambdas_i(i), item_sim_matrix, test_list);
    P(P>5) = 5;
	P(P<0) = 0;
    RMSE = (sum(sum(((UI_matrix_test~=0).*P - UI_matrix_test).^2)) / sum(sum(UI_matrix_test~=0)))^0.5;
    fprintf('lambdas: %f                 RMSE: %.2f\n', lambdas(i), RMSE);
end
