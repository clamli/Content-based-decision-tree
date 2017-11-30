function [ result ] = calInput_nominator( UI_Matrix, sim_matrix, train, test )

rs = (UI_Matrix(:, train)*sim_matrix(train, test)) .* (UI_Matrix(:, test)~=0);
result = rs(UI_Matrix(:, test)~=0);

end

