% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function [ result_pc, score ] = merge_frames( frames_dir, frame_files, pose_estimation_type, icp_threshold, icp_sampling_technique, icp_sample_size, merge_sample_size, circular_score, show_plot)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
   
    %reading the first frame and
    frame_prev = read_point_cloud(fullfile(frames_dir, frame_files(1).name))';
    frame_prev = frame_prev(1:3, :);
    frame_prev = remove_nan(frame_prev, []);
    [frame_prev, ~] = remove_background(frame_prev, []);
    frame_first_original = frame_prev;
    frame_first = frame_prev;
    frame_new = frame_first;

    % adding it to the final cloud
    result_pc = frame_prev;
    score = 0;
    
    if show_plot
        figure()
    end
    
    for i = 2:size(frame_files,1)
        %reading and processing the new frame
        disp(strcat('Current frame: ', frame_files(i).name))
        frame_new = read_point_cloud(fullfile(frames_dir, frame_files(i).name))';
        frame_new = frame_new(1:3, :);
        frame_new = remove_nan(frame_new, []);
        [frame_new, ~]= remove_background(frame_new, []);
        
        %match new frame to the previous one with ICP 
        [~, R,t, error] = icp_algorithm(frame_new, [],frame_prev , [], icp_threshold, icp_sampling_technique, icp_sample_size);
        
        score = score + error(end);
        %transform the final cloud to the position of the new frame
        result_pc = (pinv(R)*(result_pc-t));
        frame_first = (pinv(R)*(frame_first-t));

        %merge the cloud and the new frame by applying uniform spatial
        %sampling on
        result_pc = merge(result_pc, frame_new, merge_sample_size);

        %show creation of the result pointcloud with each frame
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
    
    %move the final cloud to the first frame position
    [~, R,t, ~] = icp_algorithm(frame_first, [],frame_first_original , [], icp_threshold, icp_sampling_technique, icp_sample_size);
    result_pc = (R)*result_pc + t;
    
    result_pc = remove_background(result_pc, []);
    
    %compute the difference between the first and last frame if circular is
    %set, then normalize
    normalizer = size(frame_files,1);
    if circular_score
        Closest_points_pc = get_closest_point_to_target(frame_first, frame_new, eye(3), [0;0;0]);
        score = score + get_rms_error(frame_first, Closest_points_pc, eye(3), [0;0;0]);
        normalizer = normalizer + 1;
    end
    
    score = score/normalizer;
end

