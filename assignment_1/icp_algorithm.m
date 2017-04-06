function [ T ] = icp_algorithm(Source_pc, Target_pc, sampling_technique, threshold)
%UNTITLED Summary of this function goes here
%
    % step 1 
    % initializing variables
    Source_pc(size(Source_pc,1)+1,:) = 1;
    Target_pc(size(Target_pc,1)+1,:) = 1;
    n_dims = size(Source_pc, 1);
    R = eye(n_dims);
    t = zeros([n_dims,1]);
    is_error_decreasing_above_threshold = true;
    prev_error = inf; 
    
    % icp algorithm
    while is_error_decreasing_above_threshold
        % step 2
        Closest_points_pc = get_closest_point_to_target(Source_pc, Target_pc, sampling_technique, R, t);
        [R, t] = get_rotation_and_translation_matrix(Source_pc, Closest_points_pc);
        
        % step 4
        current_error = get_rms_error(Source_pc, R, t);
        current_error
        if (current_error > prev_error - threshold)
            is_error_decreasing_above_threshold = false; 
        else
             prev_error = current_error;
         end
    end
end

