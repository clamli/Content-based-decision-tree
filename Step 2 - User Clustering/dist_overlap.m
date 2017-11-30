function [] = dist_overlap(matrixNum)
all_rm = load(['../data/UI_matrix_', num2str(matrixNum), '_train.mat']);
all_rm = all_rm.UI_matrix;

all_rm = single(full(all_rm));
disp('all DONE')

nomi = all_rm * all_rm';
disp('nomi DONE')

deno_1 = sum(all_rm.^2, 2);
clear all_rm
disp('deno_1 DONE')

deno_2 = (deno_1 * deno_1').^0.5;
clear deno_1
disp('deno_2 DONE')

distance =  - nomi ./ deno_2;
clear nomi
clear deno_2
disp('distance DONE')

save(['../data/overlap_', num2str(matrixNum), '.mat'],...
'distance');
disp('save DONE');
    