addpath(genpath('code'))
addpath('plotting_code')

%define parameters of the merging
scenes_dir = strcat('data');
file_ext = '*.pcd';

pose_estimation_type = 'all_frames'; %choices are: 'prev_frame' (apply icp on the previous frame and the current frame)
                                                  %'all_frames' (apply icp on the previous result pointcloud and the current frame)
                           
frame_sampling_rate = 2;   %step for iterating through the frames
icp_threshold = 0;
icp_sampling_technique = 'uniformspatial'; 
icp_sample_size = 0.0046;

%getting the point clouds
frame_files = dir(fullfile(scenes_dir, file_ext));
frame_files = frame_files (1:2:end);

%perform the merging of the frames
result_cloud = merge_frames(scenes_dir, frame_files, frame_sampling_rate, pose_estimation_type, icp_threshold, icp_sampling_technique, icp_sample_size, true);
pcshow(pointCloud(result_cloud'))

