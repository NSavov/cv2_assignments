function [ pointview, tracked_descriptors ] = update_pointview_matrix( pointview, tracked_descriptors, inlier_indices )
%UPDATE_POINTVIEW_MATRIX Summary of this function goes here
%   Detailed explanation goes here


    if size(pointview, 2) == 0
        pointview = zeros(size(inlier_indices, 1), 0);    
        tracked_descriptors = inlier_indices;
    end
    pointview_entry = ones(size(pointview,1), 1);
    
    [~, ind] = setdiff(tracked_descriptors, inlier_indices);
    tracked_descriptors(ind) = 0;
    
    
    if size(ind, 2) ~= 0
        n = size(ind,1);
        if  n == 0
            n = 1;
        end
        
        new_desc = setdiff(inlier_indices, tracked_descriptors);
        if size(new_desc, 1) < n
            n = size(new_desc, 1);
        end
        
        tracked_descriptors(end+1:end+n)=new_desc(1:n);
        pointview_entry(end+1:end+n) = 1;
        pointview(end+1:end+n, :) = 0;
    end
    
    pointview_entry(tracked_descriptors == 0) = 0;
    
    pointview = horzcat(pointview, pointview_entry);
end

