%% Load
% load four feature similarity matrix
name = '1m';
load(['../Step 2 - User Clustering/data/sparse_matrix_ml-',...
        name, '.mat'])
[~, itemNum] = size(UI_matrix);

item_id_random = randperm(itemNum);

train = item_id_random(1:round(itemNum * 0.7));
save(['data/', name, '/train.mat'], 'train', '-v7.3');
test = item_id_random(round(itemNum * 0.7) + 1:end);
save(['data/', name, '/test.mat'], 'test', '-v7.3');

% For large dataset, pick 10% users here.
% For 1m dataset, pick all the users
UI_matrix = single(full(UI_matrix));
% Eliminate users who don't have rating within train items.
UI_matrix = UI_matrix(sum(UI_matrix(:, train),2)~=0, :);
%% title
rs = calInput_nominator( UI_matrix, title_matrix, train, test );
save(['data/', name, '/title.mat'], 'rs', '-v7.3');
rs = calInput_denominator( UI_matrix, title_matrix, train, test );
save(['data/', name, '/title_den.mat'], 'rs', '-v7.3');
clear title_matrix
disp('title done!')

%% tag
rs = calInput_nominator( UI_matrix, tag_matrix, train, test );
save(['data/', name, '/tag.mat'], 'rs', '-v7.3');
rs = calInput_denominator( UI_matrix, tag_matrix, train, test );
save(['data/', name, '/tag_den.mat'], 'rs', '-v7.3');
clear tag_matrix
disp('tag done!')

%% year
rs = calInput_nominator( UI_matrix, year_matrix, train, test );
save(['data/', name, '/year.mat'], 'rs', '-v7.3');
rs = calInput_denominator( UI_matrix, year_matrix, train, test );
save(['data/', name, '/year_den.mat'], 'rs', '-v7.3');
clear year_matrix
disp('year done!')

%% genre
rs = calInput_nominator( UI_matrix, genre_matrix, train, test );
save(['data/', name, '/genre.mat'], 'rs', '-v7.3');
rs = calInput_denominator( UI_matrix, genre_matrix, train, test );
save(['data/', name, '/genre_den.mat'], 'rs', '-v7.3');
clear genre_matrix
disp('genre done!')

%% real rating
UI_matrix_test = UI_matrix(:, test);
real_rating = UI_matrix_test(UI_matrix_test~=0);
save(['data/', name, '/real_rating.mat'], 'real_rating', '-v7.3');
disp('real rating done!')
