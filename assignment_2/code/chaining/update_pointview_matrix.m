function [ pointview, tracked_descriptors ] = update_pointview_matrix( pointview, tracked_descriptors, inlier_indices )
%UPDATE_POINTVIEW_MATRIX Summary of this function goes here
%   Detailed explanation goes here

    construct_phase = false;

    if size(pointview, 1) == 0
        construct_phase = true;
        pointview = zeros(0, size(inlier_indices, 1));    
        tracked_descriptors = inlier_indices;
    end
    pointview_entry = ones(1, size(pointview,2));

    [~, ind] = setdiff(tracked_descriptors, inlier_indices);
    tracked_descriptors(ind) = 0;
    
%     if size(ind, 2) ~= 0
%         n = size(ind,1);
%         if  n == 0
%             n = 1;
%         end
%         
    new_desc = setdiff(inlier_indices, tracked_descriptors);
%         if size(new_desc, 1) < n
%             n = size(new_desc, 1);
%         end

    n = size(new_desc, 1);
    tracked_descriptors(end+1:end+n)=new_desc(1:n);
    pointview_entry(end+1:end+n) = 1;
    pointview(:, end+1:end+n) = 0;
%     end
    
    pointview_entry(tracked_descriptors == 0) = 0;
    
    if construct_phase
        pointview = vertcat(pointview, pointview_entry);
    else
        pointview(end, end-n:end) = 1;
    end
    
    pointview = vertcat(pointview, pointview_entry);
    
end

