function [ result_pc ] = merge_frames( frames_dir, frame_files, frame_sampling_rate,pose_estimation_type, icp_threshold, icp_sampling_technique, icp_sample_size )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    final_R = eye(3);
    final_t = [0; 0; 0];

    frame_prev = readPcd(fullfile(frames_dir, frame_files(1).name))';
    frame_prev = frame_prev(1:3, :);
    frame_prev = remove_nan(frame_prev, []);
    [frame_prev, ~] = remove_background(frame_prev, []);

    result_pc = frame_prev;
    
    for i = 1+frame_sampling_rate:frame_sampling_rate:50%size(frame_files,1)
        frame_files(i).name
        frame_new = readPcd(fullfile(frames_dir, frame_files(i).name))';
        frame_new = frame_new(1:3, :);
        frame_new = remove_nan(frame_new, []);

        [frame_new, ~]= remove_background(frame_new, []);
%         pcshow(pointCloud(frame_new'))
%         hold on
%         figure()

        
%         [transformed_frame_new, ~, ~, ~] = icp_algorithm(frame_new, [],frame_prev , [], icp_threshold, icp_sampling_technique, icp_sample_size);
% %         pcshow(pointCloud([transformed_frame_new frame_prev]'))
%         result_pc = merge(result_pc, transformed_frame_new);
% %         result_pc = get_sample(result_pc, [], 'uniform', 3*size(result_pc, 2)/4);
        
        [~, R,t, ~] = icp_algorithm(frame_prev, [], frame_new, [], icp_threshold, icp_sampling_technique, icp_sample_size);
        
        result_pc = R*result_pc + t;
        final_R = final_R*R;
        final_t = final_t + t;

%         switch pose_estimation_type
%             case 'prev_frame'
%                 result_pc = R*result_pc + t;
%                 frames_to_merge =  frame_new;
%             case 'all_frames'
%                 result_pc = R*result_pc + t;
%                 frames_to_merge = frame_new;
%         end
        
        result_pc = merge(result_pc, frame_new);

        switch pose_estimation_type
            case 'prev_frame'
                frame_prev = frame_new;
            case 'all_frames'
                frame_prev = result_pc;
        end
        
        
%         figure()
    end
    result_pc = pinv(final_R)*(result_pc-final_t);
end

