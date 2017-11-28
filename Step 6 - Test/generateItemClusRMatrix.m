function [ item_cluster_rating_matrix ] = generateItemClusRMatrix( user_cluster, item_sim_matrix, test_UI_matrix )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    item_cluster_rating_matrix = zeros(size(user_cluster, 2), size(test_UI_matrix, 2));   % (clusters, items)
    
    for i = 1:size(user_cluster, 2)
        item_rating_for_one_cluster = test_UI_matrix(user_cluster{i}, :) + ...
            (test_UI_matrix(user_cluster{i}, :) == 0) .* ...
            ((test_UI_matrix(user_cluster{i}, :) * item_sim_matrix(:, :)) ./ ...
            (test_UI_matrix(user_cluster{i}, :)~=0 * item_sim_matrix(:, :)));
        item_cluster_rating_matrix(i, :) = mean(item_rating_for_one_cluster, 1);
    end

end

