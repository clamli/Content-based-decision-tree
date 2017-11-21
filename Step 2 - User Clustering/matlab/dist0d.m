function [distance] = dist0d(i, j)

lap = find(i .* j);
if size(lap, 2) == 0
    ppc = 0;
else
    lap_i = i(:,lap) - sum(i)/sum(i~=0);
    lap_j = j(:,lap) - sum(j)/sum(j~=0);
    if sum(lap_i(:))==0 || sum(lap_j(:))==0
        ppc = 0;
    else
        ppc = sum(lap_i .* lap_j)/((sum(lap_i.^2) * sum(lap_j.^2)).^0.5 + 1e-9);
    end
end
% end
distance = 1 - ppc;