%% Load
% load item_sim_matrix
% load train_list test_list
% load UI_matrix_train & UI_matrix_test

%% Calculate ratings
UI_matrix_train = single(full(UI_matrix_train));
UI_matrix_test = single(full(UI_matrix_test));
P_test = (UI_matrix_train * item_sim_matrix(train_list, test_list))...
            ./ ...
         ((UI_matrix_train~=0) * item_sim_matrix(train_list, test_list));
     
rmse = (sum(sum(((P_test .* (UI_matrix_test~=0)) - UI_matrix_test).^2))/sum(sum(UI_matrix_test~=0)))^0.5