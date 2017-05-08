% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function [ Closest_points_pc ] = get_closest_point_to_target(Source_pc, Target_pc, R, t)
% uses knn search that by default uses the kdtree which has O = log(n)
    Source_pc = R*Source_pc + t;
    Closest_points_pc_ind = knnsearch(Target_pc', Source_pc');
    Closest_points_pc = Target_pc(:,Closest_points_pc_ind);
end

