addpath code

%define parameters of the merging
scenes_dir = strcat('..', filesep, 'data');
file_ext = '*.pcd';

pose_estimation_type = 'prev_frame'; %choices are: 'prev_frame' (apply icp on the previous frame and the current frame)
                           %             'all_frames' (apply icp on the previous result pointcloud and the current frame)
                           
frame_sampling_rate = 1;   %step for iterating through the frames
icp_threshold = 0.001;
icp_sampling_technique = 'random';
icp_sample_size = 3000;

%TODO: data should be collected in advance - also collect normals and/or use
%depth map (depth2cloud dir) - not sure how to use these yet though
frame_files = dir(fullfile(scenes_dir, file_ext));

%perform the merging of the frames
[pointCloud] = merge_frames(scenes_dir, frame_files, frame_sampling_rate, pose_estimation_type, icp_threshold, icp_sampling_technique, icp_sample_size);

