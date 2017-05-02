function [ inlier_count ] = get_inlier_count(p1, p2, F, threshold)
    % todo
    distances = zeros([size(p1,2), 1]);
    
    % make coordinates homogenous
    p1h = p1;
    p2h = p2;
    p1h(3, :) = 1;
    p2h(3, :) = 1;
    
    for i = 1:size(p1, 2)
        distances(i) = get_sampson_distance(F, p1h(:,i), p2h(:,i));
    end
    
    inlier_count = sum(distances < threshold);
end

