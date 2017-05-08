function [ pointview ] = chain( img_paths, start_index, end_index, trials, outlier_threshold, sample_count )
%CHAIN Summary of this function goes here
%   Detailed explanation goes here

    im1 = imread(img_paths{start_index});
    pointview = [];
    tracked_descriptors = [];
    match_threshold = 1.5;

    [f1, d1] = vl_sift(single(im1), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);

    for img_n = {img_paths{1+start_index:end_index}}
        im2 = imread(img_n{1});

        [f2, d2] = vl_sift(single(im2), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
        [matches, ~] = vl_ubcmatch(d1, d2, match_threshold); 
        [~, inlier_indices] = get_fundamental_matrix(f1, f2, matches, trials, sample_count, outlier_threshold);
        [pointview, tracked_descriptors] = update_pointview_matrix(pointview, tracked_descriptors, inlier_indices);

        f1=f2;
        d1=d2;
    end

end

