function [ pointview, tracked_points ] = chain( img_paths, start_index, end_index, trials, outlier_threshold, sample_count )
%CHAIN Summary of this function goes here
%   Detailed explanation goes here

    im1 = imread(img_paths{start_index});
    pointview = [];
    tracked_descriptors = [];
    tracked_descriptors_size = 0;
    tracked_points = zeros(0, 2, 0);
    match_threshold = 1.5;

    [f1, d1] = vl_sift(single(im1), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);

    for img_n = {img_paths{1+start_index:end_index}}
        im2 = imread(img_n{1});

        [f2, d2] = vl_sift(single(im2), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
        [matches, ~] = vl_ubcmatch(d1, d2, match_threshold); 
        [~, inlier_indices] = get_fundamental_matrix(f1, f2, matches, trials, sample_count, outlier_threshold);
        [pointview, tracked_descriptors] = update_pointview_matrix(pointview, tracked_descriptors, inlier_indices);
        
        tracked_points(:, 1:2, end+1:end+size(tracked_descriptors,1)-tracked_descriptors_size) = 0;
        tracked_points(end+1, 1:2, :) = 0;
        tracked_points(end, 1:2, tracked_descriptors(tracked_descriptors>0)) = f1(1:2,tracked_descriptors(tracked_descriptors>0));
        tracked_descriptors_size = size(tracked_descriptors, 1);
        f1=f2;
        d1=d2;
    end

    tracked_points(:, 1:2, end+1:end+size(tracked_descriptors,1)-tracked_descriptors_size) = 0;
    tracked_points(end+1, 1:2, :) = 0;
    tracked_points(end, 1:2, tracked_descriptors(tracked_descriptors>0)) = f1(1:2,tracked_descriptors(tracked_descriptors>0));
    
end

