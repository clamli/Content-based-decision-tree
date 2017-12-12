%% load
% load UI_matrix_train
% load similarity matrix
% load train_list
UI_matrix = single(full(UI_matrix_train)); 
[userNum, itemNum] = size(UI_matrix);
item_sim_matrix = item_sim_matrix(train_list, train_list);

%% fill with score
score_matrix = ...
    (UI_matrix == 0) .* (UI_matrix * item_sim_matrix);
score_matrix = ...
    (score_matrix) ./ ((UI_matrix ~= 0) * item_sim_matrix);
disp('fill score DONE');

%% decentralize
decentralized_matrix = score_matrix + UI_matrix;

mean_all = sum(decentralized_matrix, 2) ./ sum(decentralized_matrix~=0, 2);
disp('mean_all DONE');

decentralized_matrix = decentralized_matrix - repmat(mean_all, 1, itemNum);
disp('decentralized_matrix DONE');
save(['../20m tree/cluster/decentralized_matrix.mat'], 'decentralized_matrix');
disp('save DONE');
