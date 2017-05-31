function [ f1, d1, f2, d2, matches ] = get_sift( im1, im2 )
%GET_SIFT Summary of this function goes here
%   Detailed explanation goes here
    % to remove keypoints that are very noisy (low-contrast), these
    % following thresholds were set. This means that the background is
    % removed.
    [f1, d1] = vl_sift(single(im1), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
    [f2, d2] = vl_sift(single(im2), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
    threshold = 1.5;
    [matches, ~] = vl_ubcmatch(d1, d2, threshold);
    
%     plot_features(f1, im1)
%     plot_matching_descriptors(im1, im2, matches, f1, f2, 'matching_of_im1_im2_descriptors')
%     pause
end

