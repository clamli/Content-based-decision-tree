rating_matrix = load('../data/sparse_matrix_ml-latest.mat');
rating_matrix = rating_matrix.content(1:size(rating_matrix.content,1),:);
[userNum, itemNum] = size(rating_matrix);
rating_matrix_tenth = rating_matrix(1:int32(userNum*0.1),find(sum(rating_matrix)));

mean_all = sum(rating_matrix_tenth, 2) ./ sum(rating_matrix_tenth~=0, 2);
mean_all = single(full(mean_all));
disp('done');
save('../data/mean_all.mat', 'mean_all');