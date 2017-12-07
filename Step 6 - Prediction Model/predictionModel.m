%% Load
% load dt_model
% load UI_matrix_train & UI_matrix_test
% load item_sim_matrix
% load test_list & test_list

%% Options
RMSE_without_queried_ratings_mode = 0;
MF_with_score_mode = 0;
FDT_mode = 1;
Multiple_MF_mode = 1;
Spark_MF_mode = 1;
Outload_mode = 1;

%% Execute once
totalDepth = length(dtmodel.tree_bound);
item_cluster_rating_matrix = generateItemClusRMatrix(...
    FDT_mode, dtmodel.user_cluster,...
    item_sim_matrix(test_list, test_list),...
    single(full(UI_matrix_test)));
prediction_model = cell(2, totalDepth);
if Multiple_MF_mode
    for Depth = 1 : totalDepth
        pseudo_items = zeros(1, 0);
        all_nodes = dtmodel.tree_bound{Depth};
        for i = 1 : length(all_nodes)
            if all_nodes{i}(1) <= all_nodes{i}(2)
                pseudo_items = [pseudo_items; all_nodes{i}];
            end
        end
        prediction_model{1, Depth} = cell(size(pseudo_items, 1), 1);
        for i = 1 : size(pseudo_items, 1)
           prediction_model{1, Depth}{i, 1} =  pseudo_items(i, :);
        end
    end
end
lambdas = [0.005, 0.01,  0.02,  0.04,  0.08, ...
           0.16,  0.32,  0.64,  1.28,  2.56, ...
           5.12, 10.24, 20.48, 40.96, 81.92];
error_rate = zeros(length(lambdas), totalDepth);
for chosenDepth = 1 : totalDepth; 
    %% Find target node
    if FDT_mode
        interval_bound = [];
    else
        interval_bound = {dtmodel.interval_bound{1:chosenDepth - 1}};
    end
    [targetNodes, UI_matrix_test_queried] = ...
         getTargetNode(...
             RMSE_without_queried_ratings_mode, dtmodel.user_cluster,...
             UI_matrix_test, item_cluster_rating_matrix,...
             {dtmodel.split_cluster{1:chosenDepth - 1}},...
             {dtmodel.tree_bound{1:chosenDepth}}, ...
             interval_bound, FDT_mode);

    %% Get Leaf nodes of Decision Tree
    if Multiple_MF_mode
        pseudo_items = prediction_model{1, chosenDepth};
    else
        pseudo_items = traverseTree(dtmodel.tree_bound, 1, 1, 0, chosenDepth)';
    end

    %% Form pseudo_matrix
    if MF_with_score_mode
        %% Use score or real rating to train MF
        UI_matrix_train = single(full(UI_matrix_train));
        score_matrix_train = (UI_matrix_train == 0)...
            .* (UI_matrix_train * item_sim_matrix(train_list, train_list));
        score_matrix_train = (score_matrix_train) ./ ...
            ((UI_matrix_train ~= 0) * item_sim_matrix(train_list, train_list));
        [pseudo_matrix, pseudo_items] = getPseudo_matrix(...
                            pseudo_items, score_matrix_train); 
    else
        [pseudo_matrix, pseudo_items] = getPseudo_matrix(...
                            pseudo_items, UI_matrix_train); 
    end
    if Multiple_MF_mode
        prediction_model{1, chosenDepth} = pseudo_items;
    end
    if Outload_mode
        pseudo_matrix = single(full(pseudo_matrix));
        save(['pseudo_matrix_', num2str(chosenDepth) ,'.mat'], 'pseudo_matrix');
        continue
    end
    %% Train reg param 
    UI_matrix_test_queried = single(full(UI_matrix_test_queried));
    [user_num, item_num_test] = size(UI_matrix_test_queried);
    P_list = cell(1, length(lambdas));
    for i = 1 : length(lambdas)
        %% Generate MF Model
        lambda = lambdas(i);    
        rank = 100;
        disp('MF start:')
        chosen_train = pseudo_matrix;
        chosen_test  = UI_matrix_test_queried;
        if Spark_MF_mode
%             P = P_results{};
        else
            P = mf_resys_func(chosen_train, chosen_train~=0, rank, lambda);
        end
        P(P>5) = 5;
        P(P<0) = 0;
        P_list{i} = P;
        prediction_model{2, chosenDepth} = P;
        %% Calculate RMSE on Test Set
        P_test = single(zeros(size(chosen_test)));
        for j = 1 : item_num_test
            level = targetNodes{j}(1);
            nodeId = targetNodes{j}(2);
            pseudo_item = dtmodel.tree_bound{level}(nodeId);
            if Multiple_MF_mode
                m = find(ismember(prediction_model{1, level}, num2str(pseudo_item{1})));
                P_test(:, j) = prediction_model{2, level}(:, m);
            else
                m = find(ismember(pseudo_items, num2str(pseudo_item{1})));
                P_test(:, j) = P(:, m);
            end
        end
        P_test = P_test .* (chosen_test~=0);
        rmse_error =...
          (sum(sum((P_test - chosen_test).^2)) / sum(sum((chosen_test~=0))))^0.5;
        error_rate(i, chosenDepth) = rmse_error;    

        fprintf('lambda %f | RMSE: %f\n',lambda, error_rate(i, chosenDepth));
    end
    [optimal_lambda ,min_pos] = min(error_rate(:, chosenDepth));
    prediction_model{2, chosenDepth} = P_list{min_pos};
end

%% Save and plot
% plot(lambdas, error_rate,'-o');
% title(['Normal pcc clustering on tenth of 1m dataset, level ', num2str(chosenDepth)])
% ylabel('RMSE');
% xlabel('\lambda');
% set(gca, 'xscale', 'log');
% set(gcf, 'Color' , 'w'  );
% save(['../1m tree/error_rate_depth_', num2str(chosenDepth), '.mat'], 'error_rate');



