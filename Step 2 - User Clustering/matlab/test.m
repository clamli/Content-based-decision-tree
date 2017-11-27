% dist2d(1)
% dist2d(2)
% dist2d(3)
% dist2d(4)
% dist2d(5)
% dist2d(6)
% dist2d(7)
% dist2d(8)
% dist2d(9)
% dist2d(10)

load('../data/UI_matrix_1_train.mat')
zero_users = find(sum(UI_matrix, 2)==0);

user_cluster_cell = k_medoid(distance, 1);
for i = 1:length(user_cluster_cell)
    for j = 1:length(user_cluster_cell{i})
        if ismember(user_cluster_cell{i}(j), zero_users)
        	user_cluster_cell{i}...
                (user_cluster_cell{i}==user_cluster_cell{i}(j))...
                =[0];
        end
    end
end

for i = 1:length(user_cluster_cell)
    user_cluster_cell{i}...
    (user_cluster_cell{i}==0)=[];
end

save('../data/user_cluster_cell.mat', 'user_cluster_cell');