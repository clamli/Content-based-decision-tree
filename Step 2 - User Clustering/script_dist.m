% distance = dist_overlap(UI_matrix_train);
distance = dist_pcc_score(decentralized_matrix);
save('distance_pcc_score.mat', 'distance')