addpath code/chaining
addpath code/fundamental_matrix
addpath code/helper
addpath code/plotting_and_printing
addpath code/structure_from_motion
run ./vlfeat/toolbox/vl_setup.m

trials = 100; 
outlier_threshold = 1;
sample_count = 8;

img_names = get_image_names_from_directory('data/', 'png');
offset = 0;
im1 = imread(img_names{1+offset});
match_list = {};
pointview = [];

[f1, d1] = vl_sift(single(im1), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
for img_n = {img_names{2+offset:end}}
    clf
    im2 = imread(img_n{1});
%     [f1, d1, f2, d2, matches] = get_sift(im1, im2);

    % plot_features(f1, im1)
    [f2, d2] = vl_sift(single(im2), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
    threshold = 1.5;
    [matches, ~] = vl_ubcmatch(d1, d2, threshold); 

    [F, inlier_indices] = get_fundamental_matrix(f1, f2, matches, trials, sample_count, outlier_threshold);
    match_list{end+1} = {f1, d1};
    % im1 = im2;
    % end
%     selected_matches = matches(:,inlier_indices(1:8));
%     plot_transformations( F, selected_matches, f1, f2, im1, im2)
%     
    imshow(pointview)
    pause
    
    [pointview, tracked_descriptors] = update_pointview_matrix(pointview, tracked_descriptors, inlier_indices);
    
    im1=im2;
    f1=f2;
    d1=d2;
%     point_view_matrix = construct_pointview_matrix(match_list, size(img_names, 2));
end
