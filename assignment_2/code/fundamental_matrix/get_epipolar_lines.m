function [  target_points_y ] = get_epipolar_lines( F, source_points, target_points_x)
    % The fundamental matrix puts constrains on where a point can possibly
    % lay. The intersection of the three contraints on the dimensions is
    % where the point should lay. 
    source_points(end+1, :) = 1;
    line = F*source_points;
    a = line(1, :);
    b = line(2, :);
    c = line(3, :);
    
    target_points_y = (-a'*target_points_x-c')./b';
end