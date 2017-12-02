
lambdas = [0.01,0.02,0.04,0.08,0.16,0.32,0.64,1.28,2.56,5.12,10.24,20.48,40.96,81.92];

% load('../../Step 2 - User Clustering/data/UI_matrix_1.mat');
load('../data/data_full.mat');
load('../data/test_all.mat');
load('../data/train_all.mat');
R = L_train;
Y = Rating_train;

% index = single(find(UI_matrix));
% random_index = single(randperm(length(index)));
% train = index(random_index(1 : int32(length(index) * 0.8)));
% test = index(random_index(int32(length(index) * 0.8) + 1:end));
% 
% Y = zeros(size(UI_matrix));
% Y(train) = UI_matrix(train);
% Y = single(Y);
% Y = sparse(Y);

% test_Y = zeros(size(UI_matrix));
% test_Y(test) = UI_matrix(test);
% test_Y = single(test_Y);
% test_Y = sparse(test_Y);

error_rate = zeros(length(lambdas),1);
disp('matrix split DONE')

for i=1:length(lambdas)
    lambda = lambdas(i);
    
    % cross validation    

    [item_num,user_num] = size(Y);
    %lambda = 0.02;
    feat_num = 10;

    P = mf_resys_func(Y, Y~=0, feat_num, lambda);
    
%     error_rate(i) = sum(sum((test_R.*P - test_Y).^2))/sum(sum(test_Y.^2));
    error_rate(i) = (sum(sum(((test_Y~=0).*P - test_Y).^2)) / length(find(test_Y)))^0.5;    
    
    fprintf('lambda %f | RMSE: %f\n',lambda, error_rate(i));
end
plot(lambdas, error_rate,'-o');
ylabel('RMSE');
xlabel('\lambda');
set(gca, 'xscale', 'log');
set(gcf, 'Color' , 'w'  );

%export_fig lambda_select.eps

