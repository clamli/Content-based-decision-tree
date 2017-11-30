function [ test_item_node_id ] = getTargetNode( item_cluster_rating_matrix, split_cluster, tree_bound, interval_bound )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    test_item_num = size(item_cluster_rating_matrix, 2);
    split_cluster_num = size(split_cluster, 2);
    test_item_node_id = cell(size(1, test_item_num));
    

    for i = 1:test_item_num
        ind = 1;
        level = 1;
        for j = 1:split_cluster_num            
            mean_ = item_cluster_rating_matrix(split_cluster{j}(ind), i);
            interval1 = interval_bound{j}{ind}(1);
            interval2 = interval_bound{j}{ind}(2);
            if mean_ <= interval1
                next_ind = (ind-1) * 3 + 1;
                if tree_bound{j+1}{next_ind}(1) <= tree_bound{j+1}{next_ind}(2)
                    ind = next_ind;
                else
                    break;
                end
            elseif mean_ > interval1 && mean_ <= interval2
                next_ind = (ind-1) * 3 + 2;
                if tree_bound{j+1}{next_ind}(1) <= tree_bound{j+1}{next_ind}(2)
                    ind = next_ind;
                else
                    break;
                end
            elseif mean_ > interval2
                next_ind = (ind-1) * 3 + 3;
                if tree_bound{j+1}{next_ind}(1) <= tree_bound{j+1}{next_ind}(2)
                    ind = next_ind;
                else
                    break;
                end
            end   
            level = level + 1;
        end
        test_item_node_id{i} = [level, ind];
    end
    

end

