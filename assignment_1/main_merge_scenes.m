addpath(genpath('code'))

%define parameters of the merging
scenes_dir = strcat('data');
file_ext = '*.pcd';

enable_plotting = false;

frame_sampling_rates = {1 2 4 10};%step for iterating through the frames
pose_estimation_types = {'prev_frame', 'all_frames'};%choices are: 'prev_frame' (apply icp on the previous frame and the current frame)
                                                  %'all_frames' (apply icp on the previous result pointcloud and the current frame)

icp_threshold = 0;
icp_sampling_technique = 'uniformspatial'; 
icp_sample_size = 0.0065;
merge_sample_size = 0.002;

for pose_estimation_type = pose_estimation_types
    pose_estimation_type = pose_estimation_type{1};
    
    for frame_sampling_rate = frame_sampling_rates
        frame_sampling_rate = frame_sampling_rate{1};
        %getting the point clouds
        frame_files = dir(fullfile(scenes_dir, file_ext));
        frame_files = frame_files (1:2:end);

        %sample frames
        frame_files = frame_files(1:frame_sampling_rate:end);

        %perform the merging of the frames
        [result_cloud, score] = merge_frames(scenes_dir, frame_files, pose_estimation_type, icp_threshold, icp_sampling_technique, icp_sample_size, merge_sample_size, true, enable_plotting);

        pcshow(pointCloud(result_cloud'))
        filename = char(strcat('test_results', filesep, pose_estimation_type, '_', icp_sampling_technique, '_', 'step',string(frame_sampling_rate),'_','score', string(score), '.fig'));
        savefig(filename)
    end
end


