function [J, grad] = cost_func(obj, Y, R, rank, lambda )
%   J:      cost
%   grad:   gradient
    
    [item_num, user_num] = size(R);
    item_vectors = reshape(obj(1:item_num * rank),       item_num, rank);
    user_vectors = reshape(obj(item_num * rank + 1:end), user_num, rank);
%     disp('reshape DONE')
    
    temp = R .* (item_vectors * user_vectors' - Y);
%     disp('temp DONE')
    
    J = 1/2 * sum(sum(temp.^2))...
		+ lambda/2 * sum(sum(user_vectors.^2)) ...
		+ lambda/2 * sum(sum(item_vectors.^2));
%     disp('J DONE')
    
    item_grad =  temp  * user_vectors + lambda * item_vectors;
    user_grad =  temp' * item_vectors + lambda * user_vectors;
%     disp('Grad DONE')
    
    grad = [item_grad(:); user_grad(:)];
%     disp('cost function DONE')
end

