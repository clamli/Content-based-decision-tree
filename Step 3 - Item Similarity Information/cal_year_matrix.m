function [ year_matrix ] = cal_year_matrix( year )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    row = size(year, 2);
    year_matrix = zeros(row, row, 'single');
    i = 0;
    j = 0;
    for i = 1:row
        if mod(i, 1000) == 0
            disp(i);
        end
        for j = 1:row
            if j < i
                year_matrix(i, j) = year_matrix(j, i);
            else
                year_matrix(i, j) = 1 / (1 + abs(year(i)-year(j)));
            end
        end
    end              
end

