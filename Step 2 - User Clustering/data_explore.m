%%%%%%%%%%%% Explore Item Average Rating %%%%%%%%%%
% mean_ = sum(UI_matrix, 1) ./ sum(UI_matrix~=0, 1);
% mean_ = sort(mean_, 'descend');
% mean_(isnan(mean_)) = [];
% x = linspace(1, size(mean_, 2), size(mean_, 2));
% plot(x, mean_);
% mean_(round(size(mean_, 2)/3))
% mean_(round(size(mean_, 2) * 2/3))

%%%%%%%%%%%% Explore User Average Rating %%%%%%%%%%
mean_ = sum(UI_matrix, 2) ./ sum(UI_matrix~=0, 2);
mean_ = sort(mean_, 'descend');
mean_(isnan(mean_)) = [];
x = linspace(1, size(mean_, 1), size(mean_, 1));
plot(x, mean_);
axis([0 30000 0 6]);
% mean_(round(size(mean_, 2)/3))
% mean_(round(size(mean_, 2) * 2/3))