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
    
    Closest_points_pc = get_closest_point_to_target(Source_pc, Target_pc, sampling_technique, R, t);
    error_over_time = [get_rms_error(Source_pc, Closest_points_pc, R, t)];
    is_error_decreasing_above_threshold = true;
    
    fig_handle = [];
    % icp algorithm
    while is_error_decreasing_above_threshold
        % step 2
        Closest_points_pc = get_closest_point_to_target(Source_pc, Target_pc, sampling_technique, R, t);
        
        % step 3
        [R, t] = get_rotation_and_translation_matrix(Source_pc, Closest_points_pc);
        
        % step 4
        error_over_time = [error_over_time, get_rms_error(Source_pc, Closest_points_pc, R, t)];
        if (error_over_time(end) > (error_over_time(end-1) - threshold))
            is_error_decreasing_above_threshold = false;
            fig_handle = our_regression_plot(fig_handle, error_over_time);
        end
    end
end

