%% Load data
% load('sparse_matrix_ml-20m.mat')
load('UI_matrix_train.mat')
% load('UI_matrix_test.mat')
load('train_list.mat')
load('test_list.mat')
% UI_matrix_train = single(full(UI_matrix(:, train_list)));
% clear UI_matrix
% clear UI_matrix;
UI_matrix_train = single(full(UI_matrix_train));
load('item_sim_matrix.mat')
% UI_matrix_test = single(full(UI_matrix_test));
disp('load done!')

%% Parameter setting
K = 20;
% Final_test_matrix = UI_matrix_test;
disp('parameter setting done!')

%% Computing Score for user (Score = [user number, new item number])
Score = (UI_matrix_train * item_sim_matrix(train_list, test_list)) ./... 
            (UI_matrix_train * item_sim_matrix(train_list, test_list));
clear item_sim_matrix;
clear UI_matrix_train;
save('Score.mat', 'Score', '-v7.3');
disp('score computing done!')
        
%% Fill Matrix with active learning
load('sparse_matrix_ml-1m.mat')
load('Score.mat')
load('test_list.mat')
% filled_matrix = single(full(UI_matrix));
% clear UI_matrix
UI_matrix_test = UI_matrix(:, test_list);
UI_matrix(:, test_list) = 0;
% filled_matrix(:, train_list) = UI_matrix_train;
% clear UI_matrix_train;
for i = 1:size(test_list, 2)
%     user_exist_rating_ind = UI_matrix_test(:, i);
    [~, ind] = sort(Score(:, i), 'descend');
    if K < size(ind, 1)
        topK = ind(1:K);
    else
        topK = ind;
    end
    UI_matrix(topK, test_list(i)) = UI_matrix_test(topK, i);
    UI_matrix_test(topK, i) = 0;
end
save('UI_matrix_filled_MF.mat', 'UI_matrix', '-v7.3');
disp('fill matrix done!')

clear UI_matrix_test;
clear Score;
nnzero = sum(sum(UI_matrix~=0));
[nnind1, nnind2] = find(UI_matrix~=0);

% load('nnind1.mat');
% load('nnind2.mat');
% load('nnzero');
MF_matrix = single(zeros(nnzero, 3));
% load('sparse_matrix_ml-20m.mat')
% disp('load done!')

for i = 1:nnzero
    if rem(i,10000) == 0
        disp(i)
    end
    MF_matrix(i, :) = [nnind2(i)-1, nnind1(i)-1, single(full(UI_matrix(nnind1(i), nnind2(i))))];
end
% filled_matrix = [UI_matrix_train, filled_matrix];
%clear UI_matrix_train;
save('MF_matrix_input.mat', 'MF_matrix', '-v7.3');
disp('save file done!')

% filled_matrix = [UI_matrix_train, UI_matrix_test];
% Final_test_matrix = UI_matrix_test;
% rmse = zeros(1, size(lambdas, 2));

%% Train with Matrix Factorization
% rank = 10;
% lambdas = [5];     
% for i = 1:size(lambdas, 2)       
%     P = mf_resys_func(filled_matrix, filled_matrix~=0, rank, lambdas(i));
% %     left_bound = size(train_list, 2) + 1;
% %     right_bound = size(train_list, 2) + size(test_list,2);
%     P_test = P(:, test_list);
%     %clear P;
%     P_test(P_test>5) = 5;
%     P_test(P_test<0) = 0;
% %     P = P';
% %     P(P>5) = 5;
% % 	P(P<0) = 0;
%     RMSE = (sum(sum(((UI_matrix_test~=0).*P_test - UI_matrix_test).^2)) / sum(sum(UI_matrix_test~=0)))^0.5;
%     Precision = sum(sum(P_test>3 & UI_matrix_test>3)) / sum(sum(UI_matrix_test>3));
%     fprintf('lambdas: %f           RMSE: %.2f        Precision: %.4f\n', lambdas(i), RMSE, Precision);
%     rmse(i) = RMSE;
% end









