function [ A ] = construct_a_matrix(p1, p2)
    % following the step-by-step guide as given in the assignment
    A = zeros(size(p1,2), 9);
    x = p1(1,:);
    y = p1(2,:);
    
    xp = p2(1,:);
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
end