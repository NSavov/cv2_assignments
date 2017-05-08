function [  target_points_y ] = get_epipolar_lines( F, source_points, target_points_x)
    % todo
    source_points(end+1, :) = 1;
    line = F*source_points;
    a = line(1, :);
    b = line(2, :);
    c = line(3, :);
    
    target_points_y = (-a'*target_points_x-c')./b';
end