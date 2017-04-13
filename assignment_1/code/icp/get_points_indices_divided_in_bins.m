function [ total ] = get_points_indices_divided_in_bins(normals, num_bins)
%GET_POINTS_DIVIDED_IN_BINS Summary of this function goes here
%   Detailed explanation goes here
    num_dims = size(normals,1);
    num_points = size(normals, 2);
    bins_per_dims = floor(nthroot(num_bins, num_dims));
    histogram_bins_per_dim = zeros(num_dims, num_points);
    edges = -1:2/bins_per_dims:1;
    total = zeros(num_points, 1);
    for x = 1:num_dims
        data = normals(x,:);
        histogram_bins_per_dim(x, :) = discretize(data, edges);
        total = total + bins_per_dims^(x-1) * (discretize(data, edges)'-1);
    end
    
    total = total + 1;
end

