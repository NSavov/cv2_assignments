function [ inliers ] = calculate_inliers(f1, f2, t, threshold)
    % calculate the euclidean distance (ED) between the transformed matches 
    % and the calculated matches, if the ED than a certain [threshold] it
    % is discarded as outlier
    A = construct_a_matrix(f1);
    calc_points = reshape(A*t, [2, size(f1,2)]);
    result = (calc_points - f2).^2;
    d = sqrt(sum(result));
    inliers = f1(:, d < threshold);
end

