function [ R, t ] = icp_algorithm(Source_pc, Target_pc, threshold, sampling_technique, sample_size)
%UNTITLED Summary of this function goes here
%   
    iter = 0;
    plot3d_pointcloud(Source_pc, Target_pc, strcat('icp_pointcloud_', sampling_technique, '_iter', int2str(iter)))
    % step 1 
    % initializing variables
    Source_pc(end+1,:) = 1;
    Target_pc(end+1,:) = 1;
    n_dims = size(Source_pc, 1);
    R = eye(n_dims);
    t = zeros([n_dims,1]);
    
    Closest_points_pc = get_closest_point_to_target(Source_pc, Target_pc, sampling_technique, R, t);
    errors = get_rms_error(Source_pc, Closest_points_pc, R, t);
    iter = iter + 1;
    is_error_decreasing_above_threshold = true;
    
    fig = [];
    % icp algorithm
    while is_error_decreasing_above_threshold
        % step 2
        Closest_points_pc = get_closest_point_to_target(Source_pc, Target_pc, sampling_technique, R, t);
        
        % step 3
        [R, t] = get_rotation_and_translation_matrix(Source_pc, Closest_points_pc);
        
        % step 4
        errors = [errors, get_rms_error(Source_pc, Closest_points_pc, R, t)];
        [fig] = plot_error(errors, fig);
        if (errors(end) + threshold >= errors(end-1))
            is_error_decreasing_above_threshold = false;
        end
        iter = iter + 1;
    end
    transformed_source = R*Source_pc + t;
    plot_error(errors, fig, strcat('icp_error_', sampling_technique, '_iter', int2str(iter)));
    plot3d_pointcloud(transformed_source, Target_pc, strcat('icp_pointcloud_', sampling_technique, '_iter', int2str(iter)))
    close all;
end

