% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function [ Source_pc, Source_normals, Target_pc, Target_normals ] = equalize_point_count(Source_pc, Source_normals, Target_pc, Target_normals)
%GET_EQUAL_AMOUNT_OF_POINTS_FROM_PC Summary of this function goes here
%   Detailed explanation goes here
    num_point_base = size(Source_pc, 2);
    num_point_target = size(Target_pc, 2);
    cap = min(num_point_base, num_point_target);
    
    rd_indices_b = randperm(num_point_base);
    rd_indices_b = rd_indices_b(1:cap);
    Source_pc = Source_pc(:, rd_indices_b);
    Source_normals = Source_normals(:, rd_indices_b);
    
    rd_indices_t = randperm(num_point_target);
    rd_indices_t = rd_indices_t(1:cap);
    Target_pc = Target_pc(:, rd_indices_t);
    Target_normals = Target_normals(:, rd_indices_t);
end

