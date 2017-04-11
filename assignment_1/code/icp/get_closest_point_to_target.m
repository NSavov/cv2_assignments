function [ Closest_points_pc ] = get_closest_point_to_target(Source_pc, Target_pc, R, t)
%FIND_CLOSEST_POINT_TO_TARGET Summary of this function goes here
%   Detailed explanation goes here
    Source_pc = R*Source_pc + t;
    Closest_points_pc_ind = knnsearch(Target_pc', Source_pc');
    Closest_points_pc = Target_pc(:,Closest_points_pc_ind);
end

