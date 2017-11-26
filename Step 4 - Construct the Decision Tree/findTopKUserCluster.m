function [ sub_user_cluster_cell ] = findTopKUserCluster( user_cluster_cell, rating_matrix, k )
% rating_matrix is a single matrix, not sparse matrix
%   Detailed explanation goes here
    user_rating_num = sum(rating_matrix~=0, 2);      % (user number, 1)
    user_cluster_rating_avg_num = single(zeros(size(user_cluster_cell)));     % (1, cluster num)
    
    for i = 1:size(user_cluster_cell, 2)
        user_cluster_rating_avg_num(i) = mean(user_rating_num(user_cluster_cell{i}));
    end
    
    [user_cluster_rating_avg_num, ind] = sort(user_cluster_rating_avg_num, 'descend');
    res_ind = single(zeros(size(ind)));
    cnt = 1;
    for i = 1:size(ind, 2)
        if size(user_cluster_cell{ind(i)}, 2) >= 20
            res_ind(cnt) = ind(i);
            cnt = cnt + 1;
        end
    end
    if cnt > k
        sub_user_cluster_cell = user_cluster_cell(res_ind(1:k));
    else
        sub_user_cluster_cell = [];
    end
end

