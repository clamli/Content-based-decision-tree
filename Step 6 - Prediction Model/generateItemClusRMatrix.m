function [ item_cluster_rating_matrix ] = generateItemClusRMatrix(...
    traditionFDT, ...
    user_cluster, ...
    item_sim_matrix, ...
    test_UI_matrix )

    item_cluster_rating_matrix = zeros(size(user_cluster, 2), size(test_UI_matrix, 2));   % (clusters, items)
    
    for i = 1:size(user_cluster, 2)
        nominator = (test_UI_matrix(user_cluster{i}, :) * item_sim_matrix(:, :));
        denominator = ((test_UI_matrix(user_cluster{i}, :)~=0) * item_sim_matrix(:, :));
        if traditionFDT
            item_rating_for_one_cluster  = test_UI_matrix(user_cluster{i}, :);
            item_cluster_rating_matrix(i, :) = sum(item_rating_for_one_cluster, 1) ...
                ./ (1e-9 + sum(test_UI_matrix(user_cluster{i}, :)~=0));
        else
            item_rating_for_one_cluster  = test_UI_matrix(user_cluster{i}, :) + 0.01*(test_UI_matrix(user_cluster{i}, :) == 0) .* (nominator ./ denominator);
            item_cluster_rating_matrix(i, :) = sum(item_rating_for_one_cluster, 1) ...
                ./ (sum(0.01*(test_UI_matrix(user_cluster{i}, :)==0), 1) + sum(test_UI_matrix(user_cluster{i}, :)~=0));
        end
    end
end

