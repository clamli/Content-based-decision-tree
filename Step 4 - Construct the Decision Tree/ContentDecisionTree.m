classdef ContentDecisionTree

    properties
        % U*I Rating sparse Matrix
        UI_matrix;    
        
        % Similarity Matrix
        item_sim_matrix;    % Similarity Matrix for movie genres
        
        % Similarity Parameters
        alpha_genre;
        alpha_tag;
        alpha_title;
        alpha_year;   
        
        % Tree Info
        cur_depth = 0;
        depth_threshold;
        user_cluster;         % Cell
        split_cluster;        % Cell {
                              %     [cluster ind 1]
                              %     [cluster ind 2/3/4]                              
                              % }
        tree;                 % Array of movie index  [....]
        tree_bound;           % Node bound for each level of the tree, Cell
        user_cluster_number   % Number of user clusters in the cell
    end
    
    methods
        function loadUIRatingMatrix(obj)
            UI_matrix_str = load('');
            obj.UI_matrix = UI_matrix_str.UI_matrix;
        end
        function loadSimilarityMatrix(obj)      
            Genre_str = load('./genre_matrix_44480_44480.mat');     % Load Genre Matrix Struct
            genre_sim_matrix = Genre_str.genre_matrix;
            clear Genre_str;
            Tag_str = load('./tag_matrix_44480_44480.mat');       % Load Tag Matrix Struct
            tag_sim_matrix = Tag_str.tag_matrix;
            clear Tag_str;
            Title_str = load('./title_matrix_44480_44480.mat');     % Load Genre Matrix Struct
            title_sim_matrix = Title_str.title_matrix;
            clear Title_str;
            Year_str = load('./year_matrix_44480_44480.mat');      % Load Genre Matrix Struct
            year_sim_matrix = Year_str.title_matrix;
            clear Year_str;
            obj.item_sim_matrix = ...
                obj.alpha_genre*genre_sim_matrix + ...
                    obj.alpha_tag*tag_sim_matrix + ...
                        obj.alpha_title*title_sim_matrix + ...
                            obj.alpha_year*year_sim_matrix;
            clear genre_sim_matrix;
            clear tag_sim_matrix;
            clear title_sim_matrix;
            clear year_sim_matrix;
        end
        function setSimilarityParams(obj, param1, param2, param3, param4)
            obj.alpha_genre = param1;
            obj.alpha_tag = param2;
            obj.alpha_title = param3;
            obj.alpha_year = param4;
            obj.loadSimilarityMatrix();
        end
        function setDepthThreshold(obj, threshold)
            obj.depth_threshold = threshold;
        end
        function loadUserCluster(obj)
            user_cluster_str = load('./user_cluster_cell.mat');
            obj.user_cluster = user_cluster_str.user_cluster_cell;
            clear user_cluster_str
            obj.user_cluster_number = size(obj.user_cluster, 2);
        end
        function init(obj)
            obj.loadUIRatingMatrix();
            disp('Load UI_matrix done!');
       
            obj.loadUserCluster();
            disp('Load User Cluster Done!');
        end
        
        
        
        function generateDecisionTree(obj, tree_bound_for_node, candidate_user_cluster_id)
            obj.cur_depth = obj.cur_depth + 1;
            num_candidate_cluster = size(candidate_user_cluster_id, 2);
            
            % Termination condition
            obj.cur_depth = obj.cur_depth + 1;
            if (obj.cur_depth > obj.depth_threshold) || (num_candidate_cluster == 0)
                return
            end
            
            % Find best split user cluster
            min_error = -1;
            min_usr_cluster_id;
            min_item_average_rating;
            item_in_node = obj.tree(tree_bound_for_node(1):tree_bound_for_node(2));
            for i = 1:num_candidate_cluster
                userid_in_cluster = obj.user_cluster{candidate_user_cluster_id(i)};
                %% Calculate Score
                % Get user rating matrix for this node
                user_rating_matrix = single(full(...
                                        obj.UI_matrix(...
                                            userid_in_cluster, :)));

                % Generated Rating Matrix
                generated_rating_matrix = (user_rating_matrix(:, item_in_node) == 0) .* (user_rating_matrix*obj.item_sim_matrix(:, item_in_node));
                generated_rating_matrix = (generated_rating_matrix' / diag(sum(user_rating_matrix ~= 0, 2)))';
                         
                % Whole Rating Matrix
                rating_for_item_in_node = user_rating_matrix(:, item_in_node) + generated_rating_matrix;
                clear generated_rating_matrix;
                clear user_rating_matrix;

                %% Calculate Error
                item_average_rating = mean(rating_for_item_in_node, 1);     
                dislike_array = rating_for_item_in_node(:, item_average_rating < 2.5);
                mediocre_array = rating_for_item_in_node(:, item_average_rating >= 2.5 & item_average_rating <= 3.5);
                like_array = rating_for_item_in_node(:, item_average_rating > 3.5);
                clear rating_for_item_in_node;
                error = sum(sum(dislike_array.^2, 2)-(sum(dislike_array, 2).^2)/size(dislike_array, 2)) + ...
                    sum(sum(mediocre_array.^2, 2)-(sum(mediocre_array, 2).^2)/size(mediocre_array, 2)) + ...
                    sum(sum(like_array.^2, 2)-(sum(like_array, 2).^2)/size(like_array, 2));
                if min_error == -1 || error < min_error
                    min_error = error;
                    min_usr_cluster_id = i;
                    min_item_average_rating = item_average_rating;
                end
            end
            clear item_average_rating;
            
            %% Assign Children Node
            dislike_array = item_in_node(min_item_average_rating < 2.5);
            mediocre_array = item_in_node(min_item_average_rating >= 2.5 & min_item_average_rating <= 3.5);
            like_array = item_in_node(min_item_average_rating > 3.5);
            obj.tree(tree_bound_for_node(1):tree_bound_for_node(2)) = [dislike_array, mediocre_array, like_array];
            bound1 = tree_bound_for_node(1)+size(dislike_array, 2)-1;
            bound2 = bound1 + size(mediocre_array, 2);
            bound3 = bound2 + size(like_array, 2);
            if size(obj.tree_bound, 2) < obj.cur_depth
                obj.tree_bound{obj.cur_depth} = [tree_bound_for_node(1), bound1];
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound1+1, bound2]];
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound2+1, bound3]];
            else
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [tree_bound_for_node(1), bound1]];
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound1+1, bound2]];
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound2+1, bound3]];
            end
            
            %% Child Nodes Recursion
            candidate_user_cluster_id(min_usr_cluster_id) = [];
            obj.generateDecisionTree(obj.tree_bound{obj.cur_depth}(end-2), candidate_user_cluster_id);    % dislike node
            obj.generateDecisionTree(obj.tree_bound{obj.cur_depth}(end-1), candidate_user_cluster_id);    % mediocre node
            obj.generateDecisionTree(obj.tree_bound{obj.cur_depth}(end), candidate_user_cluster_id);      % like node
        end
    end
    
end

