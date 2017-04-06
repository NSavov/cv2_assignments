function [ R, t ] = get_rotation_and_translation_matrix(Source_pc, Target_pc)
%GET_ROTATION_AND_TRANSLATION_MATRIX Summary of this function goes here
%   Detailed explanation goes here
    % assumption that the translation can be calculated by the difference
    % in centre of mass
    mu_s = mean(Source_pc, 2);
    mu_t = mean(Target_pc, 2); 
    Source_pc = Source_pc - mu_s;
    Target_pc = Target_pc - mu_t;
    S = Source_pc * Target_pc';
    [U,~,V] = svd(S);
    Something_else = eye(size(V,2));
    Something_else(end, end) = det(V*U');
    R = V*Something_else*U';
    t = mu_t - R*mu_s;
end

