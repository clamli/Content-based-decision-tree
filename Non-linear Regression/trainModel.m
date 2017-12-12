name = '1m';

A_title = load(['data/', name, '/title.mat']);
A_title = A_title.title;
B_title = load(['data/', name, '/title_den.mat']);
B_title = B_title.title_den;

A_tag = load(['data/', name, '/tag.mat']);
A_tag = A_tag.tag;
B_tag = load(['data/', name, '/tag_den.mat']);
B_tag = B_tag.tag_den;

A_year = load(['data/', name, '/year.mat']);
A_year = A_year.year;
B_year = load(['data/', name, '/year_den.mat']);
B_year = B_year.year_den;

A_genre = load(['data/', name, '/genre.mat']);
A_genre = A_genre.genre;
B_genre = load(['data/', name, '/genre_den.mat']);
B_genre = B_genre.genre_den;

realRatings  = load(['data/', name, '/real_rating.mat']);
realRatings = realRatings.real_rating;
tbl = table(A_title, A_tag, A_year, A_genre,...
            B_title, B_tag, B_year, B_genre, realRatings);
modelfun = @(b,x)(b(1).*x(:,1) + b(2).*x(:,2) +  b(3).*x(:,3) +  b(4).*x(:,4))...
                                     ./...
                 (b(1).*x(:,5) + b(2).*x(:,6) +  b(3).*x(:,7) +  b(4).*x(:,8) + 1e-9);
beta0 = [50 1 1 1];
mdl = fitnlm(tbl,modelfun,beta0)

%% Test with specific params
x = [A_title, A_tag, A_year, A_genre,...
            B_title, B_tag, B_year, B_genre, realRatings];
params = table2array(mdl.Coefficients(:,1));
save(['data/', name, '/params_3.mat'], 'params');
modelfun = (params(1).*x(:,1) + params(2).*x(:,2) +  params(3).*x(:,3) +  params(4).*x(:,4))...
                                     ./...
                 (params(1).*x(:,5) + params(2).*x(:,6) +  params(3).*x(:,7) +  params(4).*x(:,8));
rmse = (sum((realRatings - modelfun).^2)/length(realRatings)).^0.5

%% Generate resulting 
%% load
% load four feature similarity
% load params
%%
item_sim_matrix = params(1) * title_matrix +...
             params(2) * tag_matrix +...
             params(3) * year_matrix +...
             params(4) * genre_matrix;
save(['../', name, ' tree/item_sim_matrix_3.mat'], 'item_sim_matrix')
