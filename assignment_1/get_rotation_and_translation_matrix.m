function [ R, t ] = get_rotation_and_translation_matrix(U, V, Source_pc, Target_pc)
%GET_ROTATION_AND_TRANSLATION_MATRIX Summary of this function goes here
%   Detailed explanation goes here
    R = U*V';
    % assumption that the translation can be calculated by the difference
    % in centre of mass
    mu_b = mean(Source_pc, 2);
    mu_t = mean(Target_pc, 2); 
    t = mu_b - R*mu_t;
end

