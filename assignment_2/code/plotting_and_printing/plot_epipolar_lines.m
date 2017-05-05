function [  ] = plot_epipolar_lines( F, matches, f1, f2, im1, im2)
%PLOT_EPIPOLAR_LINE Summary of this function goes here
%   Detailed explanation goes here
    indices = randperm(size(matches, 2));
    selected_random_matches = matches(:,indices(1:10));
    
    subplot(1,2,1)
%     plot_epipolar_lines(F, f1(1:2, selected_random_matches(1,:)), im1)
    scatter(f1(1, selected_random_matches(1,:)), f1(2, selected_random_matches(1,:)), 'g')
    target_x = 0:size(im1, 2);
    [target_y] = get_epipolar_lines(F, f1(1:2, selected_random_matches(1,:)), target_x);
%     imagesc(image)
    hold on
    set(gca,'YDir','Reverse')
%     xlim([0 size(image, 2)])
    ylim([0 size(image, 1)])
    plot(target_x, target_y, 'r')
%     set(gca,'YDir','normal')
%     hold off
    title('Source frame')

%     subplot(1,2,2)
%     plot_epipolar_lines(F', f2(1:2, selected_random_matches(2,:)), im2)
%     scatter(f1(1, selected_random_matches(1,:)), f1(2, selected_random_matches(1,:)), 'g')
%     title('Target frame')
%     pause
end

