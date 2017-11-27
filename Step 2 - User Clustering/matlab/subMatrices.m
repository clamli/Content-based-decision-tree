rating_matrix = load('../data/sparse_matrix_ml-latest.mat');
rating_matrix = rating_matrix.UI_matrix;
[userNum, itemNum] = size(rating_matrix);

random_index = single(randperm(itemNum));
train_list = random_index(1 : round(itemNum * 0.7));
test_list  = random_index(round(itemNum * 0.7) + 1 : end);

save('../data/train_list.mat', 'train_list');
save('../data/test_list.mat', 'test_list');

rating_matrix_train = rating_matrix(:, train_list);
UI_matrix_test      = rating_matrix(:, test_list);
startPos = 1;
endPos = int32(userNum*0.1);
save('../data/UI_matrix_test.mat', 'UI_matrix_test');
disp(full(sum(sum(UI_matrix_test~=0)))/27000000);
for i = 1:10
    disp([num2str(i), 'th:'])
    disp(['startPos: ', num2str(startPos)])
    disp(['endPos: ', num2str(endPos)])
    UI_matrix = rating_matrix_train(startPos:endPos,:); 
    save(['../data/UI_matrix_', num2str(i), '_train.mat'], 'UI_matrix');
    
    startPos = endPos + 1;
    if i == 9        
        endPos = userNum;
    else
        endPos = endPos + int32(userNum*0.1);
    end
    disp('save DONE');
end