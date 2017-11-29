load('sub_rating_matrix1.mat')
UI_Matrix = single(full(sub_rating_matrix));
load('tag_matrix_44480_44480.mat')
rs1 = (UI_Matrix~=0) .* (UI_Matrix * tag_matrix);
save('rs1.mat', 'rs1', '-v7.3');