function [ f1, d1, f2, d2, matches ] = get_sift( im1, im2 )
%GET_SIFT Summary of this function goes here
%   Detailed explanation goes here
    [f1, d1] = vl_sift(single(im1), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
    % plot_features(f1, im1)
    [f2, d2] = vl_sift(single(im2), 'PeakThresh', 1, 'EdgeThresh', 20, 'NormThresh', 0.01);
    threshold = 1.5;
    [matches, ~] = vl_ubcmatch(d1, d2, threshold); 
end

