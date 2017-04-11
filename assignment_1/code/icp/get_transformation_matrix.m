function [ T ] = get_transformation_matrix(Source_pc, Closest_points_pc)
%GET_TRANSFORMATION_MATRIX Summary of this function goes here
%   Detailed explanation goes here
    T = Closest_points_pc*pinv(Source_pc);
end

