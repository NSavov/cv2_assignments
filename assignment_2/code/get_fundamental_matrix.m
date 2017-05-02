function [ fm ] = get_fundamental_matrix( im1, im2 )
%GET_FUNDAMENTAL_MATRIX Summary of this function goes here
%   Detailed explanation goes here
    [f1, d1] = vl_sift(single(im1));
    [f2, d2] = vl_sift(single(im2));
    threshold = 1.5; % default is 1.5
    [matches, scores] = vl_ubcmatch(d1, d2, threshold); 
    trials = 100; 
    sample_count = 50;
    [t, hcount, final_inlier_indices, rcount, c_inlier_indices, lcount, lowest_inlier_indices] = ransac(f1, f2, matches, trials, sample_count);
    size(matches)
    
%     a = get_background_mask(im); 
%     im(~a) = 0; % apply mask, temporily to see results
%     imshow(im)
    fm = []
end

