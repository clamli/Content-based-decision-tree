%% Load
% load dt_model
% load UI_matrix_train & UI_matrix_test
% load test_item_node_id (target node info);
% load UI_matrix_test
% load item_sim_matrix
% load test_list

%% Train MF on train set
lambdas = [0.01,0.02,0.04,0.08,0.16,0.32,0.64,1.28,2.56,5.12,10.24,20.48,40.96,81.92];
UI_matrix = UI_matrix_train;
index = single(find(UI_matrix));
random_index = single(randperm(length(index)));
train = index(random_index(1 : int32(length(index) * 0.8)));
test = index(random_index(int32(length(index) * 0.8) + 1:end));

Y = zeros(size(UI_matrix));
Y(train) = UI_matrix(train);
Y = single(Y);

test_Y = zeros(size(UI_matrix));
test_Y(test) = UI_matrix(test);
test_Y = single(test_Y);

error_rate = zeros(length(lambdas),1);
disp('matrix split DONE')

for i=1:length(lambdas)
    lambda = lambdas(i);
    
    [item_num, user_num] = size(Y);
    feat_num = 10;

    P = mf_resys_func(Y, Y~=0, feat_num, lambda);
    error_rate(i) = (sum(sum(((test_Y~=0).*P - test_Y).^2)) / length(find(test_Y)))^0.5;    
    
    fprintf('lambda %f | RMSE: %f\n',lambda, error_rate(i));
end
plot(lambdas, error_rate,'-o');
ylabel('RMSE');
xlabel('\lambda');
set(gca, 'xscale', 'log');
set(gcf, 'Color' , 'w'  );

%% Build MF with optimal lambda
lambda_optimal = 7;
P = mf_resys_func(UI_matrix_train, UI_matrix_train~=0, feat_num, lambda_optimal);
P(P<0) = 0;
P(P>5) = 5;

%% Find target node
chosenDepth = 6;
item_cluster_rating_matrix = generateItemClusRMatrix(...
    dtmodel.user_cluster,...
    item_sim_matrix(test_list, test_list),...
    single(full(UI_matrix_test)));

test_item_node_id  =getTargetNode(...
     item_cluster_rating_matrix,...
     {dtmodel.split_cluster{1:chosenDepth - 1}},...
     {dtmodel.tree_bound{1:chosenDepth}}, ...
     {dtmodel.interval_bound{1:chosenDepth}});

%% Calculate ratings
UI_matrix_train = single(full(UI_matrix_train));
P_test = zeros(size(UI_matrix_test));
item_sim_matrix_train_test = item_sim_matrix(train_list,test_list);
for i = 1 : length(test_item_node_id)
    level = test_item_node_id{i}(1);
    nodeId = test_item_node_id{i}(2); 
    pseudo_item = dtmodel.tree_bound{level}(nodeId);
    pseudo_item_UI_matrix = P(:,pseudo_item{1}(1) : pseudo_item{1}(2));
    P_test(:,i) = (pseudo_item_UI_matrix     * item_sim_matrix_train_test(pseudo_item{1}(1) : pseudo_item{1}(2), i))...
              ./ ((pseudo_item_UI_matrix~=0) * item_sim_matrix_train_test(pseudo_item{1}(1) : pseudo_item{1}(2), i));
end

rmse = (sum(sum(((P_test .* (UI_matrix_test~=0)) - UI_matrix_test).^2))/sum(sum(UI_matrix_test~=0)))^0.5