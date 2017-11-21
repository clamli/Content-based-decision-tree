rating_matrix = load('../data/sparse_matrix_ml-latest.mat');
rating_matrix = rating_matrix.UI_matrix(1:size(rating_matrix.UI_matrix,1),:);
[userNum, itemNum] = size(rating_matrix);

startPos = 1;
endPos = int32(userNum*0.1);
for i = 1:10
    disp([num2str(i), 'th:'])
    disp(['startPos: ', num2str(startPos)])
    disp(['endPos: ', num2str(endPos)])
    decentralized_matrix = rating_matrix(startPos:endPos,:);
    startPos = endPos + 1;
    if i == 9        
        endPos = userNum;
    else
        endPos = endPos + int32(userNum*0.1);
    end
    mean_all = sum(decentralized_matrix, 2) ./ sum(decentralized_matrix~=0, 2);
    mean_all = single(full(mean_all));
%     save('../data/mean_all.mat', 'mean_all');
    disp('mean_all DONE');

    decentralized_matrix = single(full(decentralized_matrix));
    disp('decentralized_matrix 1 DONE');

    decentralized_matrix = sparse(double(decentralized_matrix - ...
                (decentralized_matrix~=0) .* repmat(mean_all, 1, itemNum)));
    disp('decentralized_matrix 2 DONE');
    save(['../data/decentralized_matrix_', num2str(i), '.mat'], 'decentralized_matrix');
    disp('save DONE');
end
