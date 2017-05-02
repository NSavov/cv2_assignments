function [ fm ] = get_fundamental_matrix( im1, im2 )
%GET_FUNDAMENTAL_MATRIX Summary of this function goes here
%   Detailed explanation goes here
    [f1, d1] = vl_sift(single(im1));
    [f1, d1] = remove_sift_descriptors_in_background(f1, d1, im1);
    visualize_features(f1, im1)
    [f2, d2] = vl_sift(single(im2));
    [f2, d2] = remove_sift_descriptors_in_background(f2, d2, im2);
    threshold = 1.5; % default is 1.5
    [matches, ~] = vl_ubcmatch(d1, d2, threshold); 
    
    trials = 1000; 
    sample_count = 100;
    [transformation_m, inlier_count, inlier_indices] = ransac(f1, f2, matches, trials, sample_count);
    plot_matching_descriptors(im1, im2, matches(:, inlier_indices), f1, f2, 'test')
    pause
    fm = [];
end

