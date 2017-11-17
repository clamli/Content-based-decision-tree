rating_matrix = load('sparse_matrix_ml-latest.mat');

[rowNum, colNum] = size(rating_matrix.content);

rating_matrix_tenth = full(rating_matrix.content(2:int32(rowNum * 0.1),find(sum(rating_matrix.content))));

mean_all = sum(rating_matrix_tenth, 2) ./ sum(rating_matrix_tenth~=0, 2);

disp('done');
% for n = 1 : int32(rowNum * 0.1) - 1
%     if mod(n, 100)==0
%         disp(n)
%     end
%     row = rating_matrix_tenth(n,:);
%     mean_all(1,n) = mean(row(row~=0));
% end
save('mean_all.mat', 'mean_all');