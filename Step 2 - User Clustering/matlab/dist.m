function [distance] = dist(i, j, mean_i, mean_j)
% size_i = size(find(i),2);
% size_j = size(find(j),2);
% if size_i == 0 || size_j == 0
%     print('cold user!')
%     ppc = 0;
% else

lap = find(i .* j);
if size(lap, 2) == 0
    ppc = 0;
else
    lap_i = i(:,lap) - mean_i;
    lap_j = j(:,lap) - mean_j;
    if sum(lap_i(:))==0 || sum(lap_j(:))==0
        ppc = 0;
    else
        ppc = sum(lap_i .* lap_j)/((sum(lap_i.^2) * sum(lap_j.^2)).^0.5);
    end
end
% end
distance = 1 - ppc;