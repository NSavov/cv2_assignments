function [ error ] = get_rms_error(Source_pc, Target_pc, R, t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    Transformed_source_pc = Source_pc'*R + t';
    error = sum(sqrt(sum((Transformed_source_pc - Target_pc').^2, 2))); % eq. 1 of assignment1
end

