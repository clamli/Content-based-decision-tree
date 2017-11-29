function [ result ] = calInput( UI_Matrix, sim_matrix, train, test )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    rs = (UI_Matrix(:, train)*sim_matrix(train, test)) .* (UI_Matrix(:, test)~=0);
    result = rs(UI_Matrix(:, test)~=0);

end

