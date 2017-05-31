function [ pointview_mask, pointview ] = chain( img_paths, start_index, end_index, trials, outlier_threshold, sample_count )
%CHAIN Summary of this function goes here
%   Detailed explanation goes here
    im1 = imread(img_paths{start_index});
    pointview_mask = [];
    tracked_descriptors = [];
    pointview = [];
    match_threshold = 1.5;

    [f1, d1] = vl_sift(single(im1), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);

    for img_i = 1+start_index:end_index
        
        %read the image
        img_n = {img_paths{img_i}};
        im2 = imread(img_n{1});

        %find tracked matches
        [f2, d2] = vl_sift(single(im2), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
        [matches, ~] = vl_ubcmatch(d1, d2, match_threshold); 
        [~, inlier_indices] = get_fundamental_matrix(f1, f2, matches, trials, sample_count, outlier_threshold);
        
        %update the pointview matrix
        [pointview_mask,pointview, tracked_descriptors] = update_pointview_matrix(pointview_mask, pointview, tracked_descriptors, inlier_indices, matches, f1, f2);
        
        %prepare for next iteration
        f1=f2;
        d1=d2;
    end

end

