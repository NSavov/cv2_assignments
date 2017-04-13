function [ output_args ] = merge_frames( frames_dir, frame_files, frame_sampling_rate,pose_estimation_type, icp_threshold, icp_sampling_technique, icp_sample_size )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%iterate through all the files

    % frames = zeros(im_size(1), im_size(2), size(files,1), 'uint8');
    %convert to gray if they are rgb

    frame_prev = readPcd(fullfile(frames_dir, frame_files(1).name));
    frame_prev = remove_background(frame_prev);
    
    for i = 1+frame_sampling_rate:frame_sampling_rate:size(frame_files,1)
        frame_new = readPcd(fullfile(frames_dir, frame_files(i).name));
        frame_new = remove_background(frame_new);
        
        [transformed_frame_new, ~, ~, ~] = icp_algorithm(frame_new, frame_prev, icp_threshold, icp_sampling_technique, icp_sample_size);
        result_pc = merge(result_pc, transformed_frame_new);
        
        switch pose_estimation_type
            case 'prev_frame'
                frame_prev = frame_new;
            case 'all_frames'
                frame_prev = result_pc;
        end
    end
end

