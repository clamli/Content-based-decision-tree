rating_matrix = load('../data/sparse_matrix_ml-latest.mat');
rating_matrix = rating_matrix.content(1:size(rating_matrix.content,1),:);
[userNum, ~] = size(rating_matrix);
decentralized_matrix = rating_matrix(1:int32(userNum*0.1),find(sum(rating_matrix)));
[~, itemNum] = size(decentralized_matrix);
clear rating_matrix

mean_all = sum(decentralized_matrix, 2) ./ sum(decentralized_matrix~=0, 2);
mean_all = single(full(mean_all));
save('../data/mean_all.mat', 'mean_all');
disp('mean_all DONE');

decentralized_matrix = single(full(decentralized_matrix));
disp('decentralized_matrix 1 DONE');

decentralized_matrix = sparse(double(decentralized_matrix - (decentralized_matrix~=0) .* repmat(mean_all, 1, itemNum)));
disp('decentralized_matrix 2 DONE');
save('../data/decentralized_matrix.mat', 'decentralized_matrix');
disp('save DONE');