addpath code/chaining
addpath code/fundamental_matrix
addpath code/helper
addpath code/plotting_and_printing
addpath code/structure_from_motion
run ./vlfeat/toolbox/vl_setup.m

% chaining hyper-parameters
trials = 100; 
outlier_threshold = 0.1;
sample_count = 8;

img_names = get_image_names_from_directory('data/', 'png');
start_index = 1;
end_index = size(img_names, 2);

% create a binary matrix that keeps track of all the keypoints that remain
% in consequative frames.
[pointview_mask, pointview] = chain( img_names,start_index, end_index, trials, outlier_threshold, sample_count );
% visualize this matrix
plot_pointview_matrix( pointview_mask )
figure()
plot_pointview_matches(pointview, pointview_mask, 4)
save('pointview_t0.1.mat', 'pointview_mask', 'pointview')
