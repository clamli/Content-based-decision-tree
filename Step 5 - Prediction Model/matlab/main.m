% matrix factorization for recommender systems
%   @author: Junhao Hua
%   @email:  huajh7@gmail.com
%
%   create time: 2015/2/27
%   last update: 2015/2/27
%
%   reference: Koren, Yehuda, Robert Bell, and Chris Volinsky.
%           "Matrix factorization techniques for recommender systems."
%           Computer 8 (2009): 30-37.
%

load('train_all.mat');

Y = Rating_train;
R = Y~=0;

[item_num, user_num] = size(R);
lambda = 10;
rank = 10;

P = mf_resys_func(Y, R, rank, lambda);

fid = fopen('pred_ratings.txt','wt');
 
% for i=1:user_num
%     for j=1:item_num
%         if R(j,i) == 1
%             entry = Y(j,i);
%         else
%             entry = round(P(j,i));
%         end
%         fprintf(fid,'%d %d %d\n',i,j,entry);
%     end
% end
% fclose(fid);

load('data_full.mat');

pred_index = setdiff(find(R), find(L_train));

% prediction error
pred_matrix             = zeros(size(P));
pred_matrix(pred_index) = round(P(pred_index));

pred_error = norm(pred_matrix(pred_index) - Y(pred_index), 2)^2 ...
            / norm(Y(pred_index),2)^2;
rmse_error = (norm(pred_matrix(pred_index) - Y(pred_index), 2)^2 / length(pred_index))^0.5;        
fprintf('\n\nNormalization prediction error = %.4f\n', pred_error);       
fprintf('\n\nRMSE predication error = %.4f\n', rmse_error);






