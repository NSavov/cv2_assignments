function [ F ] = get_fundamental_matrix( im1, im2, ransac_iterations, ransac_sample_size, outlier_threshold )
%GET_FUNDAMENTAL_MATRIX Summary of this function goes here
% 
    [f1, d1] = vl_sift(single(im1), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
    % plot_features(f1, im1)
    [f2, d2] = vl_sift(single(im2), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
    threshold = 1.5;
    [matches, ~] = vl_ubcmatch(d1, d2, threshold); 

    [F, inlier_count, inlier_indices] = ransac(f1, f2, matches, ransac_iterations, ransac_sample_size, outlier_threshold);
    print_inlier_percentage(size(matches), inlier_count)
%     plot_matching_descriptors(im1, im2, matches, f1, f2, 'test');
    plot_epipolar_lines(F, matches, f1, f2, im1, im2)
end