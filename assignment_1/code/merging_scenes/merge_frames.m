function [ result_pc ] = merge_frames( frames_dir, frame_files, frame_sampling_rate,pose_estimation_type, icp_threshold, icp_sampling_technique, icp_sample_size, show_plot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
%     frame_files = circshift(frame_files,40);

    %reading the first frame and
    frame_prev = readPcd(fullfile(frames_dir, frame_files(1).name))';
    frame_prev = frame_prev(1:3, :);
    frame_prev = remove_nan(frame_prev, []);
    [frame_prev, ~] = remove_background(frame_prev, []);

    % adding it to the final cloud
    result_pc = frame_prev;
    
    for i = 1+frame_sampling_rate:frame_sampling_rate:size(frame_files,1)
        %reading and processing the new frame
        disp(strcat('Current frame: ', frame_files(i).name))
        frame_new = readPcd(fullfile(frames_dir, frame_files(i).name))';
        frame_new = frame_new(1:3, :);
        frame_new = remove_nan(frame_new, []);
        [frame_new, ~]= remove_background(frame_new, []);
        
        %match new frame to the previous one with ICP 
        [~, R,t, ~] = icp_algorithm(frame_new, [],frame_prev , [], icp_threshold, icp_sampling_technique, icp_sample_size);
        
        %transform the final cloud to the position of the new frame
        result_pc = (pinv(R)*(result_pc - t));

        %merge the cloud and the new frame by applying uniform spatial
        %sampling on
        result_pc = merge(result_pc, frame_new);

        if show_plot
            source_pc = pointCloud(result_pc');
            target_pc = pointCloud(frame_new');

            pcshow(source_pc)
            hold on
            pcshow(target_pc)
            hold off

            pause(0.0001)
        end
        
        switch pose_estimation_type
            case 'prev_frame'
                frame_prev = frame_new;
            case 'all_frames'
                frame_prev = result_pc;
        end
        
    end
%     result_pc = pinv(final_R)*(result_pc-final_t);
end

