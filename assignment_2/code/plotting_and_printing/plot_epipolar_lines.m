function [  ] = plot_epipolar_lines( F, source_points, image)
%PLOT_EPIPOLAR_LINE Summary of this function goes here
%   Detailed explanation goes here

    target_x = 0:size(image, 2);
    [target_y] = get_epipolar_lines(F, source_points, target_x);
    imagesc(image)
    hold on
    set(gca,'YDir','Reverse')
%     xlim([0 size(image, 2)])
    ylim([0 size(image, 1)])
    plot(target_x, target_y, 'r')
%     set(gca,'YDir','normal')
%     hold off
end

