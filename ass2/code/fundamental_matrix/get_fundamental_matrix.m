function [ F, inlier_indices ] = get_fundamental_matrix( f1, f2, matches, ransac_iterations, ransac_sample_size, outlier_threshold )
%GET_FUNDAMENTAL_MATRIX Summary of this function goes here
% 


    [F, inlier_count, inlier_indices] = ransac(f1, f2, matches, ransac_iterations, ransac_sample_size, outlier_threshold);
    print_inlier_percentage(size(matches), inlier_count)
%     plot_matching_descriptors(im1, im2, matches, f1, f2, 'test');
%     plot_epipolar_lines(F, matches, f1, f2, im1, im2)

   
end