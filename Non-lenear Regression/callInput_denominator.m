function [ result ] = callInput_denominator( UI_Matrix, sim_matrix, train, test )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    rs = ((UI_Matrix(:, train)~=0)*sim_matrix(train, test)) .* (UI_Matrix(:, test)~=0);
    result = rs(rs~=0)';

end

