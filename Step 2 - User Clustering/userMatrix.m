rating_matrix = load('sparse_matrix_ml-latest.mat');
[rowNum, colNum] = size(rating_matrix.content);
rating_matrix_tenth = full(rating_matrix.content(2:int32(rowNum * 0.1),find(sum(rating_matrix.content))));
userDist_m = zeros(int32(rowNum * 0.1),int32(rowNum * 0.1));
totalNum = int32(rowNum * 0.1)^2
k = 0
for i = 1 : int32(rowNum * 0.1) - 1
    for j = 1 : int32(rowNum * 0.1) - 1
        if mod(k, 1000)==0
            disp(k)
        end
        k = k + 1;
        userDist_m(i,j) = dist(rating_matrix_tenth(i,:),rating_matrix_tenth(j,:));
    end
end
