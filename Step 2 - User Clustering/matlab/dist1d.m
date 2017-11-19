function [distance] = dist1d(index_i, dencentralized_rm)

[userNum, ~] = size(dencentralized_rm);
i = single(full(dencentralized_rm(index_i,:)));
% disp('i DONE')
lap_all = dencentralized_rm .* sparse(repmat(i, userNum, 1)~=0);
clear dencentralized_rm
% disp('lap_all 1 DONE')
lap_all = single(full(lap_all));
% disp('lap_all 2 DONE')
pcc_n = i * lap_all';
% disp('pcc 1 DONE')
pcc_d = ((i.^2 * (lap_all'~=0)) .* sum(lap_all.^2, 2)').^0.5 + 1e-9;
% disp('pcc 2 DONE')
pcc = pcc_n ./ pcc_d;
% disp('pcc 3 DONE')
distance = -pcc + 1;
% disp('distance DONE')