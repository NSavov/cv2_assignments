% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function [ total ] = get_points_indices_divided_in_bins(normals, num_bins)
% divides the 3d space in [num_bins] bins and categorises each point by
% it's normals in one of these bins.
    num_dims = size(normals,1);
    num_points = size(normals, 2);
    % as the 3d space is part of 3 x 1d spaces, each subspace can be
    % divided in the nth root of num_bins in order to obtain the required
    % num_bins as n_bins_per_dim^3 then becomes num_bins.
    bins_per_dims = floor(nthroot(num_bins, num_dims));
    histogram_bins_per_dim = zeros(num_dims, num_points);
    edges = -1:2/bins_per_dims:1;
    total = zeros(num_points, 1);
    % divide each dimension in bins, then use a number system similar to
    % the binary number representation but with a different base system to
    % obtain the actual bin number that ranges from 1:(num_bins + 1)
    for x = 1:num_dims
        data = normals(x,:);
        histogram_bins_per_dim(x, :) = discretize(data, edges);
        total = total + bins_per_dims^(x-1) * (discretize(data, edges)'-1);
    end
    total = total + 1;
end

