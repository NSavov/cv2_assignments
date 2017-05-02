function [ inlier_count ] = get_inlier_count(p1, p2, F, threshold)
    %
    distances = zeros(size(p1,1));
    for i = 1:size(p1)
        distances(i) = get_sampson_distance(p1(i,:), p2(i,:));
    end
    
    inlier_count = sum(distances < threshold);
%     A = construct_a_matrix(f1);
%     calc_points = reshape(A*t, [2, size(f1,2)]);
%     result = (calc_points - f2).^2;
%     d = sqrt(sum(result));
%     inliers = f1(:, d < threshold);
end

