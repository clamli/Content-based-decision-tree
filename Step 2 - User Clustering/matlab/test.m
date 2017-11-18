clear all
rating_matrix = load('../data/sparse_matrix_ml-latest.mat');
rating_matrix = rating_matrix.content(1:size(rating_matrix.content,1),:);
mean_all = load('../data/mean_all.mat');
mean_all = mean_all.mean_all;
[userNum, itemNum] = size(rating_matrix);
rating_matrix_tenth = rating_matrix(1:int32(userNum*0.1),find(sum(rating_matrix)));
clear rating_matrix
[rowNum, colNum] = size(rating_matrix_tenth);
i = single(full(rating_matrix_tenth(3425,:)));
lap_j = rating_matrix_tenth .* sparse(repmat(i, rowNum, 1)~=0);
clear lap
clear rating_matrix_tenth
decenter_i = i - i~=0 .* mean_all(3425,1);
clear i
lap_j = full(lap_j);
lap_j = lap_j - lap_j~=0 .* repmat(mean_all, 1, colNum);
pcc = decenter_i * lap_j.T ./ ((decenter_i.^2 * lap_j.T~=0) * sum(lap_j.^2, 2).T + 1e-9);
% dist_i = zeros(size(rating_matrix_tenth,1),1);