function [ P, user_vectors ] = mf_resys_func( Y, R, rank, lambda)
% matrix factorization for recommender systems

    [item_num, user_num] = size(R);    
    % initialization 
    item_vectors = randn(item_num, rank);
    user_vectors = randn(user_num, rank);
    init_val = [item_vectors(:); user_vectors(:)];

    maxiter = 100;

    options = optimset('GradObj', 'on', 'MaxIter', maxiter);
    tic;
    vec_obj = mf_fmincg (@(x)(mf_cost_func(x, Y, R, rank, lambda)), init_val, options);
    toc;

    item_vectors = reshape(vec_obj(1 : item_num * rank),        item_num, rank);
    user_vectors = reshape(vec_obj(item_num * rank + 1 : end),  user_num, rank);

    P = item_vectors * user_vectors'; % + repmat(Ymean,1,user_num);
end

