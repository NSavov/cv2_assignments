function [ R, t ] = icp_algorithm(Source_pc, Target_pc, threshold, sampling_technique)
%UNTITLED Summary of this function goes here
%   
    iter = 0;
    our_plot3d(Source_pc, Target_pc, strcat(sampling_technique, '_iter', iter))
    % step 1 
    % initializing variables
    Source_pc(size(Source_pc,1)+1,:) = 1;
    Target_pc(size(Target_pc,1)+1,:) = 1;
    n_dims = size(Source_pc, 1);
    R = eye(n_dims);
    t = zeros([n_dims,1]);
    
    Closest_points_pc = get_closest_point_to_target(Source_pc, Target_pc, sampling_technique, R, t);
    error_over_time = get_rms_error(Source_pc, Closest_points_pc, R, t);
    iter = iter + 1;
    is_error_decreasing_above_threshold = true;
    
    fig_handle_error = [];
    % icp algorithm
    while is_error_decreasing_above_threshold
        % step 2
        Closest_points_pc = get_closest_point_to_target(Source_pc, Target_pc, sampling_technique, R, t);
        
        % step 3
        [R, t] = get_rotation_and_translation_matrix(Source_pc, Closest_points_pc);
        
        % step 4
        error_over_time = [error_over_time, get_rms_error(Source_pc, Closest_points_pc, R, t)];
        fig_handle_error = plot_error(fig_handle_error, error_over_time);
        if (error_over_time(end) + threshold >= error_over_time(end-1))
            is_error_decreasing_above_threshold = false;
        end
        iter = iter + 1;
    end
    transformed_source = R*Source_pc + t;
    our_plot3d(transformed_source, Target_pc, strcat(sampling_technique, '_iter', iter))
end

