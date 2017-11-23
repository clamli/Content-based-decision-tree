function [J,grad] = cost_func(obj, Y, R, rank, lambda )
%   J:      cost
%   grad:   gradient
    
    [item_num, user_num] = size(R);
    item_vectors = reshape(obj(1:item_num * rank),       item_num, rank);
    user_vectors = reshape(obj(item_num * rank + 1:end), user_num, rank);
            
    J = 1/2 * sum(sum((R .* (item_vectors * user_vectors'-Y)).^2))...
            + lambda/2 * sum(sum(user_vectors.^2)) ...
            + lambda/2 * sum(sum(item_vectors.^2));

    item_grad =  R .* (item_vectors * user_vectors' - Y)   * user_vectors + lambda * item_vectors;
    user_grad = (R .* (item_vectors * user_vectors' - Y))' * item_vectors + lambda * user_vectors;

    grad = [item_grad(:); user_grad(:)];
end

