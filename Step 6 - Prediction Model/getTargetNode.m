function [ test_item_node_id, UI_matrix_test] = getTargetNode( ...
            RMSE_without_queried_ratings,...
            user_cluster,...
            UI_matrix_test,...
            item_cluster_rating_matrix,...
            split_cluster, ...
            tree_bound, ...
            interval_bound, traditionFDT)
   
    test_item_num = size(item_cluster_rating_matrix, 2);
    depth = size(split_cluster, 2);
    test_item_node_id = cell(size(1, test_item_num));
    
    for i = 1 : test_item_num
        ind = 1;
        level = 1;
        for j = 1 : depth            
            mean_ = item_cluster_rating_matrix(split_cluster{j}(ind), i);
            if RMSE_without_queried_ratings == 1
                query_matrix = UI_matrix_test(user_cluster{split_cluster{j}(ind)}, i);
                UI_matrix_test(user_cluster{split_cluster{j}(ind)}(query_matrix~=0), i) = 0;
            end
            if traditionFDT
                if mean_ <= 3 && mean_ > 0
                    next_ind = (ind-1) * 3 + 1;
                    if tree_bound{j+1}{next_ind}(1) <= tree_bound{j+1}{next_ind}(2)
                        ind = next_ind;
                    else
                        break;
                    end
                elseif mean_ > 3 && mean_ <= 5
                    next_ind = (ind-1) * 3 + 2;
                    if tree_bound{j+1}{next_ind}(1) <= tree_bound{j+1}{next_ind}(2)
                        ind = next_ind;
                    else
                        break;
                    end
                elseif mean_ == 0
                    next_ind = (ind-1) * 3 + 3;
                    if tree_bound{j+1}{next_ind}(1) <= tree_bound{j+1}{next_ind}(2)
                        ind = next_ind;
                    else
                        break;
                    end
                end   
            else
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
            end
            level = level + 1;
        end
        test_item_node_id{i} = [level, ind];
    end
end

