item_id_random = randperm(44480);

train = item_id_random(1:round(44480 * 0.7));
save('data/train.mat', 'train', '-v7.3');
test = item_id_random(round(44480 * 0.7) + 1:end);
save('data/test.mat', 'test', '-v7.3');

load('../Step 2 - User Clustering/data/sparse_matrix_ml-latest.mat')
startPos = 1;
endPos = round(270896*0.1);
UI_matrix = single(full(UI_matrix(startPos : endPos, :)));
% Eliminate users who don't have rating within train items.
UI_matrix = UI_matrix(sum(UI_matrix(:, train),2)~=0, :);
%% title
load('data/title_matrix_44480_44480.mat')
rs = calInput_nominator( UI_matrix, title_matrix, train, test );
save('data/title.mat', 'rs', '-v7.3');
rs = calInput_denominator( UI_matrix, title_matrix, train, test );
save('data/title_den.mat', 'rs', '-v7.3');
clear title_matrix
disp('title done!')

%% tag
load('data/tag_matrix_44480_44480.mat')
rs = calInput_nominator( UI_matrix, tag_matrix, train, test );
save('data/tag.mat', 'rs', '-v7.3');
rs = calInput_denominator( UI_matrix, tag_matrix, train, test );
save('data/tag_den.mat', 'rs', '-v7.3');
clear tag_matrix
disp('tag done!')

%% year
load('data/year_matrix_44480_44480.mat')
rs = calInput_nominator( UI_matrix, year_matrix, train, test );
save('data/year.mat', 'rs', '-v7.3');
rs = calInput_denominator( UI_matrix, year_matrix, train, test );
save('data/year_den.mat', 'rs', '-v7.3');
clear year_matrix
disp('year done!')

%% genre
load('data/genre_matrix_44480_44480.mat')
rs = calInput_nominator( UI_matrix, genre_matrix, train, test );
save('data/genre.mat', 'rs', '-v7.3');
rs = calInput_denominator( UI_matrix, genre_matrix, train, test );
save('data/genre_den.mat', 'rs', '-v7.3');
clear genre_matrix
disp('genre done!')

%% real rating
UI_matrix_test = UI_matrix(:, test);
real_rating = UI_matrix_test(UI_matrix_test~=0);
save('data/real_rating.mat', 'real_rating', '-v7.3');
disp('real rating done!')
