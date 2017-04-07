function [ error ] = get_rms_error(source, target, R, t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    source = R*source + t;
    source = source';
    num_elems = size(source, 1);
    error =  sqrt(1/num_elems * sum(sqrt(sum((source - target').^2, 1)))); % eq. 1 of assignment1
end

