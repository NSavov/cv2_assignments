function [ A ] = construct_a_matrix(p1, p2)
    % put all points in a matrix that complies with the format of 
    % [x, y, 0, 0, 1, 0; 0, 0, x, y, 0, 1]. This allows for easy matrix
    % multiplication later on.
    size(p1)
    size(p2)
    numel(p1)
    size(p1,2)
    A = zeros(size(p1,2), 9);
    x = p1(1,:);
    xp = p2(1,:);
    y = p1(2,:);
    yp = p2(2,:);
    A(:,1) = x.*xp;
    A(:,2) = x.*yp;
    A(:,3) = x;
    A(:,4) = y.*xp;
    A(:,5) = y.*yp;
    A(:,6) = y;
    A(:,7) = xp;
    A(:,8) = yp;
    A(:,9) = ones([size(p1,2),1]);

%     A = zeros(numel(points), 6);
%     i = 1;
%     for p = points
%        A(i, 1:2) = p';
%        A(i, 5) = 1;
%        A(i+1, 3:4) = p';
%        A(i+1, 6) = 1;
%        i = i + 2;
%     end
end