item_id_random = randperm(44480);

train = item_id_random(1:31136);
test = item_id_random(31137:end);

load('sub_rating_matrix1.mat')
UI_Matrix = single(full(sub_rating_matrix));

%% title
load('title_matrix_44480_44480.mat')
rs = calInput( UI_Matrix, title_matrix, train, test );
save('title.mat', 'rs', '-v7.3');
rs = callInput_denominator( UI_Matrix, title_matrix, train, test );
save('title_den.mat', 'rs', '-v7.3');
clear title_matrix
disp('title done!')

%% tag
load('tag_matrix_44480_44480.mat')
rs = calInput( UI_Matrix, tag_matrix, train, test );
save('tag.mat', 'rs', '-v7.3');
rs = callInput_denominator( UI_Matrix, tag_matrix, train, test );
save('tag_den.mat', 'rs', '-v7.3');
clear tag_matrix
disp('tag done!')

%% year
load('year_matrix_44480_44480.mat')
rs = calInput( UI_Matrix, year_matrix, train, test );
save('year.mat', 'rs', '-v7.3');
rs = callInput_denominator( UI_Matrix, year_matrix, train, test );
save('year_den.mat', 'rs', '-v7.3');
clear year_matrix
disp('year done!')

%% genre
load('genre_matrix_44480_44480.mat')
rs = calInput( UI_Matrix, genre_matrix, train, test );
save('genre.mat', 'rs', '-v7.3');
rs = callInput_denominator( UI_Matrix, genre_matrix, train, test );
save('genre_den.mat', 'rs', '-v7.3');
clear genre_matrix
disp('genre done!')

%% real rating
real_rating = UI_Matrix(UI_Matrix(:, test)~=0);
save('real_rating.mat', 'real_rating', '-v7.3');
disp('real rating done!')
