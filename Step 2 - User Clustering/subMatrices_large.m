%% load 
% sparse_matrix_ml-20m.mat

%%
[userNum, itemNum] = size(UI_matrix);

% random_index = single(randperm(itemNum));
% train_list = random_index(1 : round(itemNum * 0.7));
% test_list  = random_index(round(itemNum * 0.7) + 1 : end);
% 
% save('../20m tree/train_list.mat', 'train_list');
% save('../20m tree/test_list.mat', 'test_list');
% load('data/train_list.mat');
% load('data/test_list.mat');
divident = 1/3;
rating_matrix_train = UI_matrix(:, train_list);
rating_matrix_test = UI_matrix(:, test_list);
startPos = 1;
endPos = int32(userNum * divident);
disp(full(sum(sum(rating_matrix_train~=0)))/1000000);
for i = 1:3
    disp([num2str(i), 'th:'])
    disp(['startPos: ', num2str(startPos)])
    disp(['endPos: ', num2str(endPos)])
    UI_matrix_train = rating_matrix_train(startPos:endPos,:); 
    save(['../1m tree/UI_matrix_', num2str(i), '_train.mat'], 'UI_matrix_train');
    UI_matrix_test = rating_matrix_test(startPos:endPos,:); 
    save(['../1m tree/UI_matrix_', num2str(i), '_test.mat'], 'UI_matrix_test');

    startPos = endPos + 1;
    if i == 2        
        endPos = userNum;
    else
        endPos = endPos + int32(userNum * divident);
    end
    disp('save DONE');
end