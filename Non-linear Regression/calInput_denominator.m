function [ result ] = calInput_denominator( UI_Matrix, sim_matrix, train, test )

rs = ((UI_Matrix(:, train)~=0) * sim_matrix(train, test)) .* (UI_Matrix(:, test)~=0);
result = rs(UI_Matrix(:, test)~=0);

end

