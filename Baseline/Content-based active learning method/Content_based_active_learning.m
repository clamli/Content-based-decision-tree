%% Load data
load('UI_matrix_train.mat')
load('UI_matrix_test.mat')
load('train_list.mat')
load('test_list.mat')
load('item_sim_matrix_3700_3700.mat')
UI_matrix_train = single(full(UI_matrix_train));
UI_matrix_test = single(full(UI_matrix_test));

%% Parameter setting
K = 20;
Final_test_matrix = UI_matrix_test;

%% Computing Score for user (Score = [user number, new item number])
Score = (UI_matrix_train * item_sim_matrix(train_list, test_list)) ./... 
            ((UI_matrix_train~=0) * item_sim_matrix(train_list, test_list));
        
        
%% Fill Matrix with active learning
filled_matrix = zeros(size(UI_matrix_train, 1), (size(UI_matrix_train, 2) + size(UI_matrix_test, 2)));
filled_matrix(:, train_list) = UI_matrix_train;
for i = 1:size(Score, 2)
    user_exist_rating_ind = find(UI_matrix_test(:, i)~=0);
    [~, ind] = sort(Score(user_exist_rating_ind, i), 'descend');
    if K < size(ind, 1)
        topK = user_exist_rating_ind(ind(1:K));
    else
        topK = user_exist_rating_ind(ind);
    end
    filled_matrix(topK, test_list(i)) = UI_matrix_test(topK, i);
    Final_test_matrix(topK, i) = 0;
end

%% Train with Matrix Factorization
rank = 100;
lambdas = [0.000625, 0.00125, 0.0025, ...
           0.005, 0.01,  0.02,  0.04,  0.08, ...
           0.16,  0.32,  0.64,  1.28,  2.56, ...
           5.12, 10.24, 20.48, 40.96, 81.92];     
for i = 1:size(lambdas, 2)       
    P = mf_resys_func(filled_matrix, filled_matrix~=0, rank, lambdas(i));
    P_test = P(:, test_list);
    P_test(P_test>5) = 5;
    P_test(P_test<0) = 0;
    RMSE = (sum(sum(((Final_test_matrix~=0).*P_test - Final_test_matrix).^2)) / sum(sum(Final_test_matrix~=0)))^0.5;
    fprintf('lambdas: %f                 RMSE: %.2f\n', lambdas(i), RMSE);
end









