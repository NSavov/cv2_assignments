% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function [ error ] = get_rms_error(source, target, R, t)
    % (summed) root mean squared error is calculated by the euclidean 
    % distance between the transformed source, and target. 
    source = R*source + t;
    source = source';
    num_elems = size(source, 1);
    error =  sqrt(1/num_elems * sum(sqrt(sum((source - target').^2, 1)))); % eq. 1 of assignment1
end

