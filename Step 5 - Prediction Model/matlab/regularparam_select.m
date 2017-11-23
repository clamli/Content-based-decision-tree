
lambdas = [0.01,0.02,0.04,0.08,0.16,0.32,0.64,1.28,2.56,5.12,10.24,20.48,40.96,81.92];

load('../../Step 2 - User Clustering/data/UI_matrix_1.mat');

index = find(UI_matrix);
random_index = randperm(length(index));
train = index(random_index(1 : int32(length(index) * 0.8)));
test = index(random_index(int32(length(index) * 0.8) + 1:end));

Y = zeros(size(UI_matrix));
Y(train) = UI_matrix(train);
Y = sparse(Y);
R = Y~=0;

test_Y = zeros(size(UI_matrix));
test_Y(test) = UI_matrix(test);
test_Y = sparse(test_Y);
test_R = test_Y~=0;

error_rate = zeros(length(lambdas),1);

for i=1:length(lambdas)
    lambda = lambdas(i);
    
    % cross validation    

    [item_num,user_num] = size(R);
    %lambda = 0.02;
    feat_num = 10;

    P = mf_resys_func(Y, R, feat_num, lambda);
    
%     error_rate(i) = sum(sum((test_R.*P - test_Y).^2))/sum(sum(test_Y.^2));
    error_rate(i) = (sum(sum((test_R.*P - test_Y).^2)) / length(find(test_Y)))^0.5;    
    
    fprintf('lambda %f | RMSE: %f\n',lambda, error_rate(i));
end
plot(lambdas, error_rate,'-o');
ylabel('RMSE');
xlabel('\lambda');
set(gca,'xscale','log');
set(gcf, 'Color', 'w');

%export_fig lambda_select.eps

