% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function [ R, t ] = get_rotation_and_translation_matrix(Source_pc, Target_pc)
    % the calculations below are based on this paper:
    % Least-Squares Rigid Motion Using SVD
    % setup for computing rotation and translation
    mu_s = mean(Source_pc, 2);
    mu_t = mean(Target_pc, 2); 
    Source_pc = Source_pc - mu_s;
    Target_pc = Target_pc - mu_t;
    
    % computing the rotation    
    S = Source_pc * Target_pc';
    [U,~,V] = svd(S);
    Temp = eye(size(V,2));
    Temp(end, end) = det(V*U');
    R = V*Temp*U';
    t = mu_t - R*mu_s;
end

