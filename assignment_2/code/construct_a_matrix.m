function [ A ] = construct_a_matrix(points)
    % put all points in a matrix that complies with the format of 
    % [x, y, 0, 0, 1, 0; 0, 0, x, y, 0, 1]. This allows for easy matrix
    % multiplication later on.
    A = zeros(numel(points), 6);
    i = 1;
    for p = points
       A(i, 1:2) = p';
       A(i, 5) = 1;
       A(i+1, 3:4) = p';
       A(i+1, 6) = 1;
       i = i + 2;
    end
end