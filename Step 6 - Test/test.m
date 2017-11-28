item_sim_matrix = item_sim_matrix_44480_44480(test_list,test_list);
clear item_sim_matrix_44480_44480

UI_matrix_test_1 = UI_matrix_test( 1:27090,:);
clear UI_matrix_test

item_cluster_rating_matrix =...
     generateItemClusRMatrix( chosen_user_cluster_cell, item_sim_matrix, single(full(UI_matrix_test_1)));
 
 save('data/item_cluster_rating_matrix.mat', 'item_cluster_rating_matrix')
 
%%%%%%%%% Correct generateItemClusRMatrix function, save here
%  function [ item_cluster_rating_matrix ] = generateItemClusRMatrix( user_cluster, item_sim_matrix, test_UI_matrix )
% %UNTITLED Summary of this function goes here
% %   Detailed explanation goes here
%     item_cluster_rating_matrix = zeros(size(user_cluster, 2), size(test_UI_matrix, 2));   % (clusters, items)
%     for i = 1:size(user_cluster, 2)
%         disp(i)
%         cluster = test_UI_matrix(user_cluster{i}, :);
%         score_sum =  cluster     * item_sim_matrix;
%         sim_sum = (cluster~=0) * item_sim_matrix;
%         item_rating_for_one_cluster = cluster + (cluster==0) .* (score_sum ./ sim_sum);
%         item_cluster_rating_matrix(i, :) = mean(item_rating_for_one_cluster, 1);
%     end
% end