all = load('../data/decentralized_matrix.mat');
all = all.decentralized_matrix;

% distance = dist1d(1244, rating_matrix_tenth, mean_all)
% 
all = single(full(all));
disp('all DONE')

pcc_n = all * all';
disp('pcc_n DONE')

all_2 = all.^2 * (all'~=0);
clear all
disp('all_2 DONE')

pcc_d = all_2 .* all_2' + 1e-9;
clear all_2
disp('pcc_d DONE')

pcc = pcc_n ./ pcc_d;
disp('pcc 3 DONE')

distance = -pcc + 1;
disp('distance DONE')