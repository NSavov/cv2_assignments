function [ T ] = get_normalisation_matrix( p )
%get_normalisation_matrix improve stability by normalizing
%   pointcloud is moved to have zero mean and sqrt(2) variance. It was
%   shown in literature that this improves the stability and training time
%   of the algorithm.
    n = size(p, 2);
    mx = sum(p(1, :)) / n;
    my = sum(p(2, :)) / n;
    d = sum(sqrt((p(1, :) - mx).^2 + (p(2, :) - my).^2)) / n;
    T = zeros([3,3]);
    T(1,1) = sqrt(2) / d;
    T(2,2) = sqrt(2) / d;
    T(3,3) = 1;
    T(1,3) = -mx*sqrt(2) / d;
    T(2,3) = -my*sqrt(2) / d;
end

