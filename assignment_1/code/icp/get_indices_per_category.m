function [ output ] = get_indices_per_category(points_divided_into_bins, unique_bins)
%GET_INDICES_PER_CATEGORY Summary of this function goes here
%   Detailed explanation goes here
    output = cell([size(unique_bins, 1), 1]);
    num = 0;
    for bin = unique_bins'
        num = num + 1;
        output{num} = find(points_divided_into_bins == bin);
    end
end

