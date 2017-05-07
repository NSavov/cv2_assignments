% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

% This function is broken up in 4 parts that correspond with the ones 
% mentioned in the 1.1 implementation section of the assignment.
function [ transformed_source, R, t, errors ] = icp_algorithm(Source_pc, Source_normals, Target_pc, Target_normals, threshold, sampling_technique, sample_size)
    iter = 0;
    plot3d_pointcloud(Source_pc, Target_pc, strcat('icp_pointcloud_', sampling_technique, '_iter', int2str(iter)));
    % step 1 
    n_dims = size(Source_pc, 1);
    R = eye(n_dims);
    t = zeros([n_dims,1]);
    Source_pc_sampled = get_sample(Source_pc, Source_normals, sampling_technique, sample_size);
    Target_pc_sampled = get_sample(Target_pc, Target_normals, sampling_technique, sample_size);
    Closest_points_pc = get_closest_point_to_target(Source_pc_sampled, Target_pc_sampled, R, t);
    errors = get_rms_error(Source_pc_sampled, Closest_points_pc, R, t);
    iter = iter + 1;
    is_error_decreasing_above_threshold = true;
    
    fig = [];
    % icp algorithm
    while is_error_decreasing_above_threshold
        % step 2
        Source_pc_sampled = get_sample(Source_pc, Source_normals, sampling_technique, sample_size);
        Target_pc_sampled = get_sample(Target_pc, Target_normals, sampling_technique, sample_size);
        Closest_points_pc = get_closest_point_to_target(Source_pc_sampled, Target_pc_sampled, R, t);
        
        % step 3
        [R, t] = get_rotation_and_translation_matrix(Source_pc_sampled, Closest_points_pc);
        
        % step 4
        errors = [errors, get_rms_error(Source_pc_sampled, Closest_points_pc, R, t)];
        fig = plot_error(errors, fig);
        if (errors(end) + threshold >= errors(end-1))
            is_error_decreasing_above_threshold = false;
        end
        iter = iter + 1;
    end
    
    % Apply the obtained transformation to transform the source to the
    % target
    transformed_source = R*Source_pc + t;
    plot_error(errors, fig, strcat('icp_error_', sampling_technique, '_iter', int2str(iter)));
    plot3d_pointcloud(transformed_source, Target_pc, strcat('icp_pointcloud_', sampling_technique, '_iter', int2str(iter)));
    
    global param_is_plotting
    if param_is_plotting
        close all;
    end
end

