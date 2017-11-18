rating_matrix = load('../data/sparse_matrix_ml-latest.mat');
rating_matrix = rating_matrix.content(1:size(rating_matrix.content,1),:);
mean_all = load('../data/mean_all.mat');
mean_all = mean_all.mean_all;
[userNum, itemNum] = size(rating_matrix);
rating_matrix_tenth = rating_matrix(1:int32(userNum*0.1),find(sum(rating_matrix)));

userDist_m = zeros(int32(rowNum * 0.1),int32(rowNum * 0.1));
totalNum = int32(rowNum * 0.1)^2
k = 0
for i = 1 : int32(rowNum * 0.1) - 1
    for j = 1 : int32(rowNum * 0.1) - 1
        if mod(k, 1000)==0
            disp(k)
        end
        k = k + 1;
        userDist_m(i,j) = dist(rating_matrix_tenth(i,:),rating_matrix_tenth(j,:), mean_all(1,i), mean_all(1,j));
    end
end
