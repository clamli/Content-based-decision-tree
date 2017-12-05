%% Load data
load('UI_matrix_train.mat')
load('UI_matrix_test.mat')
load('train_list.mat')
load('test_list.mat')
load('item_sim_matrix_3700_3700.mat')
UI_matrix_train = single(full(UI_matrix_train));
UI_matrix_test = single(full(UI_matrix_test));
disp('load done!')

%% Parameter setting
K = 20;
Final_test_matrix = UI_matrix_test;
disp('parameter setting done!')

%% Computing Score for user (Score = [user number, new item number])
Score = (UI_matrix_train * item_sim_matrix(train_list, test_list)) ./... 
            ((UI_matrix_train~=0) * item_sim_matrix(train_list, test_list));
clear item_sim_matrix;
disp('score computing done!')
        
%% Fill Matrix with active learning
filled_matrix = zeros(size(UI_matrix_train, 1), size(UI_matrix_test, 2));
% filled_matrix(:, train_list) = UI_matrix_train;
% clear UI_matrix_train;
for i = 1:size(Score, 2)
    user_exist_rating_ind = find(UI_matrix_test(:, i)~=0);
    [~, ind] = sort(Score(user_exist_rating_ind, i), 'descend');
    if K < size(ind, 1)
        topK = user_exist_rating_ind(ind(1:K));
    else
        topK = user_exist_rating_ind(ind);
    end
    filled_matrix(topK, i) = UI_matrix_test(topK, i);
    Final_test_matrix(topK, i) = 0;
end
clear UI_matrix_test;
clear Score;
filled_matrix = [UI_matrix_train, filled_matrix];
clear UI_matrix_train;
disp('fill matrix done!')

%% Train with Matrix Factorization
rank = 100;
lambdas = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];     
for i = 1:size(lambdas, 2)       
    P = mf_resys_func(filled_matrix, filled_matrix~=0, rank, lambdas(i), test_list);
%     P_test = P(:, test_list);
%     clear P;
%     P_test(P_test>5) = 5;
%     P_test(P_test<0) = 0;
%     P = P';
    P(P>5) = 5;
	P(P<0) = 0;
    RMSE = (sum(sum(((Final_test_matrix~=0).*P - Final_test_matrix).^2)) / sum(sum(Final_test_matrix~=0)))^0.5;
    fprintf('lambdas: %f                 RMSE: %.2f\n', lambdas(i), RMSE);
end









