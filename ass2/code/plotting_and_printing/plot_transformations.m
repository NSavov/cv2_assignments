function [ ] = plot_transformations( F, selected_matches, f1, f2, im1, im2)
%PLOT_TRANSFORMATIONS Summary of this function goes here
%   Detailed explanation goes here
    
    subplot(1,2,1)
    plot_epipolar_lines(F, f1(1:2, selected_matches(1,:)), im1)
    scatter(f2(1, selected_matches(2,:)), f2(2, selected_matches(2,:)), 'g')
    
    title('Source frame')
%     figure()
    subplot(1,2,2)
    plot_epipolar_lines(F', f2(1:2, selected_matches(2,:)), im2)
    scatter(f1(1, selected_matches(1,:)), f1(2, selected_matches(1,:)), 'g')
    
    title('Target frame')

end

