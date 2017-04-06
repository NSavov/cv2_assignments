function [ error ] = get_rms_error(Transformed_source_pc, Target_pc, R, t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    Transformed_source_pc = R*Transformed_source_pc + t;
    Transformed_source_pc = Transformed_source_pc';
    num_elems = size(Transformed_source_pc, 1);
    error =  sqrt(1/num_elems * sum(sqrt(sum((Transformed_source_pc - Target_pc').^2, 1)))); % eq. 1 of assignment1
end

