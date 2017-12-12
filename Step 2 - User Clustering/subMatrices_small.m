rating_matrix = load('data/sparse_matrix_ml-1m.mat');
rating_matrix = rating_matrix.UI_matrix;
[userNum, itemNum] = size(rating_matrix);

random_index = single(randperm(itemNum));
train_list = random_index(1 : round(itemNum * 0.7));
test_list  = random_index(round(itemNum * 0.7) + 1 : end);

save('data/1m/train_list.mat', 'train_list');
save('data/1m/test_list.mat',   'test_list');
% load('data/train_list.mat');
% load('data/test_list.mat');

UI_matrix = rating_matrix(:, train_list);
UI_matrix_test      = rating_matrix(:, test_list);
disp(full(sum(sum(UI_matrix_test~=0)))/1000000);

save('data/1m/UI_matrix_train.mat', 'UI_matrix_train');
save('data/1m/UI_matrix_test.mat', 'UI_matrix_test');
disp('save DONE');