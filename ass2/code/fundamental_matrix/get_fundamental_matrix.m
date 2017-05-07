function [ F, inlier_indices ] = get_fundamental_matrix( f1, f2, matches, ransac_iterations, ransac_sample_size, outlier_threshold )
%GET_FUNDAMENTAL_MATRIX Summary of this function goes here
% 


    [F, inlier_count, inlier_indices] = ransac(f1, f2, matches, ransac_iterations, ransac_sample_size, outlier_threshold);
    print_inlier_percentage(size(matches), inlier_count)
%     plot_matching_descriptors(im1, im2, matches, f1, f2, 'test');
%     plot_epipolar_lines(F, matches, f1, f2, im1, im2)


%     temp_f1 = f1(1:2, selected_matches(1,:));
%     temp_f1(end+1, :) = 1;
%     temp_f2 = f2(1:2, selected_matches(2,:));
%     temp_f2(end+1, :) = 1;
%     
%     temp_f2'*(F*temp_f1)
end