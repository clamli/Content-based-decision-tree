rating_matrix = load('../data/sparse_matrix_ml-latest.mat');
rating_matrix = rating_matrix.content(1:size(rating_matrix.content,1),:);
mean_all = load('../data/mean_all.mat');
mean_all = single(full(mean_all.mean_all));
[userNum, itemNum] = size(rating_matrix);
rating_matrix_tenth = single(full(rating_matrix(1:int32(userNum*0.1),find(sum(rating_matrix)))));
clear rating_matrix

ppc_i = ones(size(rating_matrix_tenth,1),1) .* -1;

i = full(rating_matrix_tenth(3425,:));
i_full = repmat(full(i),size(rating_matrix_tenth,1),1);
lap = i_full~=0 .* rating_matrix_tenth~=0;

lap_i = i_full              .* lap;
clear i_full
clear i
lap_j = rating_matrix_tenth .* lap;
lap_i = lap_i - lap_i~=0 .* mean_all(3425,1);
lap_j = lap_j - lap_j~=0 .* repmat(mean_all,1,size(rating_matrix_tenth,2));

ppc_i = sum(lap, 2)~=0 .* ppc_i;
ppc_i = sum(lap_i, 2)~=0 .* ppc_i;
ppc_i = sum(lap_j, 2)~=0 .* ppc_i;
ppc_i~=0;

ppc = sum(lap_i(ppc_i~=0,:) .* lap_j(ppc_i~=0,:), 2)/((sum(lap_i(ppc_i~=0,:).^2, 2) * sum(lap_j(ppc_i~=0,:).^2, 2)).^0.5);


dist_i = zeros(size(rating_matrix_tenth,1),1);