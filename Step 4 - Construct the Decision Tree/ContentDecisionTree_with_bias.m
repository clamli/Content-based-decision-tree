classdef ContentDecisionTree<handle

    properties
        % U*I Rating sparse Matrix
        UI_matrix;    
        generated_rating_matrix;
        
        % Similarity Matrix
        item_sim_matrix;    % Similarity Matrix for movie genres
        
        % Similarity Parameters
        alpha_genre;
        alpha_tag;
        alpha_title;
        alpha_year;   
        
        % Tree Info
        cur_depth = 1;
        cur_node = 1;
        node_num = 0;
        depth_threshold;
        user_cluster;         % Cell
        candi_user_num = 0;   % Candidata user number
        % user_id;            % Array
        split_cluster;        % Cell {
                              %     [cluster ind 1]
                              %     [cluster ind 2/3/4]                              
                              % }
        tree;                 % Array of movie index  [....]
        tree_bound;           % Node bound for each level of the tree, Cell
        interval_bound;       % Bound for each node's interval
        user_cluster_id;      % Id of user clusters in the cell
        global_mean;          % Global mean of ratings
        UI_matrix_with_item_bias;            % UI rating after minusing Item bias
    end
    
    methods
        function loadUIRatingMatrix(obj)
            UI_matrix_str = load('./UI_matrix_train.mat');
            obj.UI_matrix = single(full(UI_matrix_str.UI_matrix_train));
            item_num = size(obj.UI_matrix, 2);
            user_num = size(obj.UI_matrix, 1);
            obj.tree = uint32(linspace(1, item_num, item_num));
            obj.tree_bound{obj.cur_depth} = {[1, item_num]};
            obj.global_mean = sum(sum(obj.UI_matrix)) / sum(sum(obj.UI_matrix~=0));
            % obj.user_id = uint32(linspace(1, user_num, user_num));
            item_bias = (sum(obj.UI_matrix, 1) + 7*obj.global_mean) ./ (7+sum(obj.UI_matrix~=0, 1));
            item_bias = repmat(item_bias, user_num, 1);
            obj.UI_matrix_with_item_bias = obj.UI_matrix - item_bias;
            clear item_bias;
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
            year_sim_matrix = Year_str.year_matrix;
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
        function setSimilarityParams(obj, param1, param2, param3, param4, flag)
            if flag == 0
                obj.alpha_genre = param1;
                obj.alpha_tag = param2;
                obj.alpha_title = param3;
                obj.alpha_year = param4;
                obj.loadSimilarityMatrix();
            else
                similarity_matrix_str = load('item_sim_matrix_2590_2590.mat');
                obj.item_sim_matrix = similarity_matrix_str.item_sim_matrix_training;
                clear similarity_matrix_str;
            end
        end
        function setDepthThreshold(obj, threshold)
            obj.depth_threshold = threshold;
            for i = 0:obj.depth_threshold-1
                obj.node_num = obj.node_num + 3^i;
            end
        end
        function loadUserCluster(obj)
            user_cluster_str = load('./clusters_overlap.mat');
            obj.user_cluster = user_cluster_str.clusters;
            clear user_cluster_str
            obj.user_cluster_id = uint32(linspace(1, size(obj.user_cluster, 2), size(obj.user_cluster, 2)));
            for i = 1:size(obj.user_cluster, 2)
                obj.candi_user_num = obj.candi_user_num + size(obj.user_cluster{i}, 2);
            end
        end
        function init(obj)
            obj.loadUIRatingMatrix();
            disp('Load UI_matrix done!');
       
            obj.loadUserCluster();
            disp('Load User Cluster Done!');
            
            obj.generated_rating_matrix = (obj.UI_matrix(:, :) == 0) .* (obj.UI_matrix(:, :)*obj.item_sim_matrix(:, :));
            obj.generated_rating_matrix = (obj.generated_rating_matrix) ./ ((obj.UI_matrix(:, :) ~= 0) * obj.item_sim_matrix(:, :));
%             obj.generated_rating_matrix = 0.5*obj.generated_rating_matrix;
            disp('Generated Matrix Done!');
        end
        
        
        
        function generateDecisionTree(obj, tree_bound_for_node, candidate_user_cluster_id, candidate_user_num)
            num_candidate_cluster = size(candidate_user_cluster_id, 2);
            % fprintf('level %d:\n', obj.cur_depth);
            
            % Termination condition
            obj.cur_depth = obj.cur_depth + 1;
            if (obj.cur_depth > obj.depth_threshold) || (num_candidate_cluster == 0)
                return
            end
            
            % Calculation Preparation
            id_array = zeros(1, candidate_user_num);
            index_cell = cell(1, num_candidate_cluster);
            item_in_node = obj.tree(tree_bound_for_node(1):tree_bound_for_node(2));
            front = 1;
            for i = 1:num_candidate_cluster
                userid = obj.user_cluster{candidate_user_cluster_id(i)};
                rear = size(userid, 2) + front - 1;
                index_cell{i} = linspace(front, rear, size(userid, 2)); 
                id_array(front:rear) = userid;
                front = rear + 1;
            end
            %fprintf('    Preparation finished!\n');
            
            %% Calculate Score            
%             % Generated Rating Matrix
%             generated_rating_matrix = (obj.UI_matrix(id_array, item_in_node) == 0) .* (obj.UI_matrix(id_array, :)*obj.item_sim_matrix(:, item_in_node));
%             % generated_rating_matrix = (generated_rating_matrix' / diag(sum(obj.UI_matrix(id_array, :) ~= 0, 2)))';
%             generated_rating_matrix = (generated_rating_matrix) ./ ((obj.UI_matrix(id_array, :) ~= 0) * obj.item_sim_matrix(:, item_in_node));
            
            rating_for_item_in_node = obj.UI_matrix(id_array, item_in_node) + obj.generated_rating_matrix(id_array, item_in_node);
            % clear generated_rating_matrix;
            % save('./rating_for_item_in_node.mat', 'rating_for_item_in_node', '-v7.3');
            % fprintf('    Calculate score finished!\n');
               
            %% Calculate Error
            tmp_UI_matrix_in_node = obj.UI_matrix_with_item_bias(:, item_in_node);
            min_error = -1;
            for i = 1:num_candidate_cluster
                item_average_rating = mean(rating_for_item_in_node(index_cell{i}, :), 1);
                [~, ind] = sort(item_average_rating);
                interval1 = item_average_rating(ind(round(size(ind, 2)/3)));
                interval2 = item_average_rating(ind(round(2*size(ind, 2)/3))); 
                dislike_array = tmp_UI_matrix_in_node(:, item_average_rating <= interval1);
                mediocre_array = tmp_UI_matrix_in_node(:, item_average_rating > interval1 & item_average_rating <= interval2);
                like_array = tmp_UI_matrix_in_node(:, item_average_rating > interval2);                
                error = sum(sum(dislike_array.^2, 2)-(sum(dislike_array, 2).^2)./(sum(dislike_array~=0, 2)+1e-9)) + ...
                    sum(sum(mediocre_array.^2, 2)-(sum(mediocre_array, 2).^2)./(sum(mediocre_array~=0, 2)+1e-9)) + ...
                    sum(sum(like_array.^2, 2)-(sum(like_array, 2).^2)./(sum(like_array~=0, 2)+1e-9));
%                 fprintf('cluster id: %d\n', i);
%                 fprintf('index_cell: %d\n', size(index_cell{i}));
%                 fprintf('%.2f        %.2f\n', error, min_error);
                % fprintf('%d, %d, %d\n', size(dislike_array, 2), size(mediocre_array, 2), size(like_array, 2));
                if min_error == -1 || error < min_error
                    min_error = error;
                    min_interval1 = interval1;
                    min_interval2 = interval2;
                    min_usr_cluster_id = i;
                    min_item_average_rating = item_average_rating;
                end
            end
            clear tmp_UI_matrix_in_node;
            %fprintf('    Calculate error finished!\n');
            clear rating_for_item_in_node;
            clear item_average_rating;
            
            
            %% Assign Children Node
            %disp(min_item_average_rating);
            %disp(size(item_in_node));
            dislike_array = item_in_node(min_item_average_rating <= min_interval1);
            mediocre_array = item_in_node(min_item_average_rating > min_interval1 & min_item_average_rating <= min_interval2);
            like_array = item_in_node(min_item_average_rating > min_interval2);
%             disp(size(obj.tree(tree_bound_for_node(1):tree_bound_for_node(2))));
%             disp(size(dislike_array));
%             disp(size(mediocre_array));
%             disp(size(like_array));
            obj.tree(tree_bound_for_node(1):tree_bound_for_node(2)) = [dislike_array, mediocre_array, like_array];
            bound1 = tree_bound_for_node(1)+size(dislike_array, 2)-1;
            bound2 = bound1 + size(mediocre_array, 2);
            bound3 = bound2 + size(like_array, 2);
            if size(obj.tree_bound, 2) < obj.cur_depth
                obj.tree_bound{obj.cur_depth} = {[tree_bound_for_node(1), bound1]};
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound1+1, bound2]];
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound2+1, bound3]];
                obj.split_cluster{obj.cur_depth-1} = candidate_user_cluster_id(min_usr_cluster_id);
                obj.interval_bound{obj.cur_depth-1} = {[min_interval1, min_interval2]};
            else
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [tree_bound_for_node(1), bound1]];
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound1+1, bound2]];
                obj.tree_bound{obj.cur_depth} = [obj.tree_bound{obj.cur_depth}, [bound2+1, bound3]];
                obj.split_cluster{obj.cur_depth-1} = [obj.split_cluster{obj.cur_depth-1}, candidate_user_cluster_id(min_usr_cluster_id)];
                obj.interval_bound{obj.cur_depth-1} = [obj.interval_bound{obj.cur_depth-1}, [min_interval1, min_interval2]];
            end
            %fprintf('    Assign Child Nodes finished!\n');
            
            
            %% Child Nodes Recursion
            candidate_user_num = candidate_user_num - size(index_cell{min_usr_cluster_id}, 2);
            candidate_user_cluster_id(min_usr_cluster_id) = [];
            obj.generateDecisionTree(obj.tree_bound{obj.cur_depth}{end-2}, candidate_user_cluster_id, candidate_user_num);    % dislike node
            obj.cur_depth = obj.cur_depth - 1;
            obj.generateDecisionTree(obj.tree_bound{obj.cur_depth}{end-1}, candidate_user_cluster_id, candidate_user_num);    % mediocre node
            obj.cur_depth = obj.cur_depth - 1;
            obj.generateDecisionTree(obj.tree_bound{obj.cur_depth}{end}, candidate_user_cluster_id, candidate_user_num);      % like node
            obj.cur_depth = obj.cur_depth - 1;
            
            obj.cur_node = obj.cur_node + 3;
            fprintf('Current depth: %d        %.2f%%\n', obj.cur_depth, 100*obj.cur_node/obj.node_num);
        end
        
        function buildTree(obj)
            obj.generateDecisionTree(obj.tree_bound{1}{1}, obj.user_cluster_id, obj.candi_user_num);
        end
    end
    
end

