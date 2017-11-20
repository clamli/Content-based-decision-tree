function [ cosine_similarity ] = cosine_similarity( content )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    cosine_similarity = (content * content') ./ (sqrt(sum(content.^2, 2)) * sqrt(sum((content').^2, 1)));
end

