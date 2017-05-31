addpath code/chaining
addpath code/fundamental_matrix
addpath code/helper
addpath code/plotting_and_printing
addpath code/structure_from_motion
run ./vlfeat/toolbox/vl_setup.m

% parameter settings of RANSAC
trials = 300; 
outlier_threshold = 1;
sample_count = 20;

% loop over all image pairs
img_names = get_image_names_from_directory('data/', 'png');
offset = 0;
im1 = imread(img_names{1+offset});
descriptor_list = {};
for img_n = {img_names{2+offset:end}}
    clf
    im2 = imread(img_n{1});
    % obtain SIFT feature matches between conseq. frames
    [f1, d1, f2, d2, matches] = get_sift(im1, im2);
    % obtain the fundamental matrix by using ransac that maximises inliers
    [F, inlier_indices] = get_fundamental_matrix(f1, f2, matches, trials, sample_count, outlier_threshold);
    
    im1 = im2;
    % show resulting epipolar lines, note that there are still 4 possible
    % configuration of epipolar lines possible with this F matrix (see report)
    selected_matches = matches(:,inlier_indices(1:8));
    plot_transformations( F, selected_matches, f1, f2, im1, im2)
    pause(0.001)
end