load('data/sparse_matrix_ml-latest.mat');
load('data/item_sim_matrix_31136_31136.mat')
[userNum, itemNum] = size(UI_matrix);

% random_index = single(randperm(itemNum));
% train_list = random_index(1 : round(itemNum * 0.7));
% test_list  = random_index(round(itemNum * 0.7) + 1 : end);
% 
% save('../data/train_list.mat', 'train_list');
% save('../data/test_list.mat', 'test_list');

load('data/train_list.mat');
load('data/test_list.mat');
UI_matrix_train = UI_matrix(:, train_list);

startPos = 1;
endPos = int32(userNum*0.1);
for i = 1:10
    disp([num2str(i), 'th:'])
    disp(['startPos: ', num2str(startPos)])
    disp(['endPos: ', num2str(endPos)])
	UI_matrix = UI_matrix_train(startPos:endPos,:);
    startPos = endPos + 1;
    if i == 9        
        endPos = userNum;
    else
        endPos = endPos + int32(userNum*0.1);
    end
    %% fill with score
    generated_rating_matrix = ...
        (UI_matrix == 0) .* (UI_matrix * item_sim_matrix);
    generated_rating_matrix = ...
        (generated_rating_matrix) ./ ((UI_matrix ~= 0) * item_sim_matrix);
    disp('fill score DONE');
    
    %% decentralize
    decentralized_matrix = generated_rating_matrix + UI_matrix;
    clear UI_matrix
    clear generated_rating_matrix
    
    mean_all = sum(decentralized_matrix, 2) ./ sum(decentralized_matrix~=0, 2);
    mean_all = single(full(mean_all));
    disp('mean_all DONE');

    decentralized_matrix = single(full(decentralized_matrix));
    disp('decentralized_matrix 1 DONE');

    decentralized_matrix = sparse(double(decentralized_matrix - ...
                (decentralized_matrix~=0) .* repmat(mean_all, 1, itemNum)));
    disp('decentralized_matrix 2 DONE');
    save(['data/decentralized/decentralized_matrix_', num2str(i), '.mat'], 'decentralized_matrix');
    disp('save DONE');
end
