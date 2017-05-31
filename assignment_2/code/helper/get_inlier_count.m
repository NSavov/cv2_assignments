function [ inlier_count, inlier_mask ] = get_inlier_count(p1, p2, F, threshold)
    % pre-allocate distance list
    distances = zeros([size(p1,2), 1]);
    
    % make coordinates homogenous
    p1h = p1;
    p2h = p2;
    p1h(3, :) = 1;
    p2h(3, :) = 1;
    
    % get the sampson distance and save it
    for i = 1:size(p1, 2)
        distances(i) = get_sampson_distance(F, p1h(:,i), p2h(:,i));
    end
    
    % threshold the distances, gives a boolean list that can fungate as a
    % mask for inliers.
    inlier_mask = distances < threshold;
    inlier_count = sum(inlier_mask);
end

