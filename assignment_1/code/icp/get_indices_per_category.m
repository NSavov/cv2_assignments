% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function [ output ] = get_indices_per_category(points_divided_into_bins, unique_bins)
% helper function of get_informed_sample
    output = cell([size(unique_bins, 1), 1]);
    num = 0;
    for bin = unique_bins'
        num = num + 1;
        output{num} = find(points_divided_into_bins == bin);
    end
end

