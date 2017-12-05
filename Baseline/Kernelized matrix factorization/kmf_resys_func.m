function [ P ] = kmf_resys_func( Y, R, rank, lambda, lambda_i, item_sim_matrix, test_list)
% matrix factorization for recommender systems

    [user_num, item_num] = size(R);    
    % initialization 
    item_vectors = randn(item_num, rank);
    user_vectors = randn(user_num, rank);
    init_val = [item_vectors(:); user_vectors(:)];

    maxiter = 200;

    options = optimset('GradObj', 'on', 'MaxIter', maxiter);
    tic;
    vec_obj = kmf_fmincg (@(x)(kmf_cost_func(x, Y, R, rank, lambda, lambda_i, item_sim_matrix)), init_val, options);
    toc;

    item_vectors = reshape(vec_obj(1 : item_num * rank),        item_num, rank);
    user_vectors = reshape(vec_obj(item_num * rank + 1 : end),  user_num, rank);

    P = user_vectors * (item_vectors(test_list, :))'; % + repmat(Ymean,1,user_num);
end

