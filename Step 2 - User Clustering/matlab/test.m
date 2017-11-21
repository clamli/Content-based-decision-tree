% rating_matrix = load('../data/sparse_matrix_ml-latest.mat');
% rating_matrix = rating_matrix.UI_matrix(1:size(rating_matrix.UI_matrix,1),:);
% [userNum, itemNum] = size(rating_matrix);
% 
% startPos = 1;
% endPos = int32(userNum*0.1);
% rating_matrix = rating_matrix(startPos:endPos,:);
% i = rating_matrix(10638,:);
% j = rating_matrix(210,:);
% m = dist0d(i, j)

dist2d(1)