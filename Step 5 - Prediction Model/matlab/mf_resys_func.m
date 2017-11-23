function [ P ] = mf_resys_func( Y, R, rank, lambda)
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
%   solve the following objective function by the gradient descent:
%
%   [item_vectors, user_vectors] =
%       argmin_{item_vectors,user_vectors} 1/2||R.*(Y - item_vectors'*user_vectors)||_F^2 + lambda/2(||item_vectors||_F^2 + ||user_vectors||_F^2)
%
%   where item_vectors, user_vectors are the latent feature matrices
%
%   item_vectors:          item_num x rank
%   user_vectors:      user_num x rank
%   Y(ratings): item_num x user_num
%
%   P:          rating matrice
%

    [item_num, user_num] = size(R);    

    % mean normalization: for new users
%     Ymean = zeros(item_num, 1);
%     Ynorm = zeros(item_num,user_num);
%     for i = 1:item_num
%         idx = find(R(i, :) == 1);
%         Ymean(i) = mean(Y(i, idx));
%         Ynorm(i, idx) = Y(i, idx) - Ymean(i);
%     end
%     Y = Ynorm;

    % initialization 
    item_vectors = randn(item_num, rank);
    user_vectors = randn(user_num, rank);
    init_val = [item_vectors(:); user_vectors(:)];

    maxiter = 100;

    options = optimset('GradObj', 'on', 'MaxIter', maxiter);
    tic;
    vec_obj = fmincg (@(x)(cost_func(x, Y, R, rank, lambda)), init_val, options);
    toc;

    item_vectors = reshape(vec_obj(1 : item_num * rank),        item_num, rank);
    user_vectors = reshape(vec_obj(item_num * rank + 1 : end),  user_num, rank);

    P = item_vectors * user_vectors'; % + repmat(Ymean,1,user_num);
end

