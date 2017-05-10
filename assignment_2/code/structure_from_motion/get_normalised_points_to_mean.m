function [ normalised_points ] = get_normalised_points_to_mean( original_points )
%GET_NORMALISED_POINTS_TO_MEAN Summary of this function goes here
%   Detailed explanation goes here

    normalised_points = original_points - sum(original_points);
end

