function [pseudo_matrix, pseudo_items] = getPseudo_matrix(pseudo_items, matrix_train)
[user_num, ~] = size(matrix_train);
pseudo_item_num = length(pseudo_items);
pseudo_matrix = zeros(user_num, pseudo_item_num);

for i = 1:pseudo_item_num
    range = pseudo_items{i};
    pseudo_items{i} = num2str(pseudo_items{i});
    pseudo_item = full(matrix_train(:,range(1):range(2)));
    pseudo_matrix(:, i) = sum(pseudo_item, 2) ./ (sum(pseudo_item~=0, 2) + 1e-9);
end
end

