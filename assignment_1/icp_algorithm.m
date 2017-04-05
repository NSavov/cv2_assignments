function [ A ] = icp_algorithm( sampling_technique, threshold)
%UNTITLED Summary of this function goes here
%
    % initialize R (identiy matrix), t
    % step 1
    R = eye(3);
    t = zeros([3,1]);

    is_error_decreasing_above_threshold = true;
    prev_error = inf; 
    while is_error_decreasing_above_threshold
        % step 2
        A = find_closest_point_to_target(A_base_pc, A_target_pc, sampling_technique);

        % step 3
        [U, S, V] = svd(A);
        
        % step 4
        current_error = rms(A_base, A_target, U, S, V);
        if (current_error > prev_error - threshold)
            is_error_decreasing_above_threshold = false; 
        else
            prev_error = current_error;
        end
    end
end

