function [ targetNodes, UI_matrix_test, rated_user] = getTargetNode( ...
            RMSE_without_queried_ratings_mode,...
            user_cluster,...
            UI_matrix_test,...
            cluster_matrix,...
            split_cluster, ...
            tree_bound, ...
            interval_bound, FDT_mode)
   
    test_item_num = size(cluster_matrix, 2);
    depth = size(split_cluster, 2);
    targetNodes = cell(1, test_item_num);
    rated_user = cell(1, test_item_num);
    for i = 1 : test_item_num
        ind = 1;
        level = 1;
        for j = 1 : depth            
            mean_ = cluster_matrix(split_cluster{j}(ind), i);
            if RMSE_without_queried_ratings_mode == 1
                cluster_ids = user_cluster{split_cluster{j}(ind)};
                query_matrix = UI_matrix_test(cluster_ids, i)~=0;
                rated_user{i} = [rated_user{i} cluster_ids(query_matrix)];
            end
            if FDT_mode
                if mean_ > 3 && mean_ <= 5
                    next_ind = (ind-1) * 3 + 1;
                    if tree_bound{j+1}{next_ind}(1) <= tree_bound{j+1}{next_ind}(2)
                        ind = next_ind;
                    else
                        break;
                    end
                elseif mean_ <= 3 && mean_ > 0 
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
        targetNodes{i} = [level, ind];
    end
end

