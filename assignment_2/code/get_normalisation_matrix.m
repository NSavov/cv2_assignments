function [ T ] = get_normalisation_matrix( p1, p2 )
%GET_NORMALISATION_MATRIX Summary of this function goes here
%   Detailed explanation goes here
    n = size(p1, 1);
    cpx = [p1(:, 1);p2(:, 1)];
    cpy = [p1(:, 2);p2(:, 2)];
    mx = sum(cpx) / n;
    my = sum(cpy) / n;
    d = sum(sqrt( (cpx - mx).^2 + (cpy-my).^2)) / n;
    T = zeros([3,3]);
    T(1,1) = sqrt(2) / d;
    T(2,2) = sqrt(2) / d;
    T(3,3) = 1;
    T(1,3) = -mx*sqrt(2) / d;
    T(2,3) = -my*sqrt(2) / d;
end

