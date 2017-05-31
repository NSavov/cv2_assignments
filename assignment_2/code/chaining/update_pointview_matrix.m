function [ pointview_mask, pointview, tracked_descriptors ] = update_pointview_matrix( pointview_mask, pointview, tracked_descriptors, inlier_indices, matches, f1, f2 )
%  
    construct_phase = false;
    
    f1_inlier_indices = matches(1,inlier_indices);
    f2_inlier_indices = matches(2,inlier_indices);

    if size(pointview_mask, 1) == 0
        construct_phase = true;
        pointview_mask = zeros(0, size(inlier_indices, 1));  
        pointview = zeros(0, size(inlier_indices, 1));
        tracked_descriptors = f1_inlier_indices;
    end
    

    diff = setdiff(tracked_descriptors, f1_inlier_indices);
    for ind=1:size(diff,2)
        tracked_descriptors(tracked_descriptors == diff(ind)) = 0;
    end
    
    %add indices of new tracked points
    new_desc = setdiff(f1_inlier_indices, tracked_descriptors);
    n = size(new_desc, 2);
    tracked_descriptors(end+1:end+n)=new_desc(1:n);
    
    pointview_entry = ones(1, size(pointview_mask,2));
    
    pointview_entry(end+1:end+n) = 1;
    pointview_mask(:, end+1:end+n) = 0;
    pointview(:, end+1:end+n) = 0;

    %convert old indices to new
    new_tracked_descriptors = zeros(size(tracked_descriptors));
    for i=1:size(f1_inlier_indices, 2)
       new_tracked_descriptors(tracked_descriptors==f1_inlier_indices(i))=f2_inlier_indices(i);
    end
    
    tracked_descriptors = new_tracked_descriptors;
    
    tracked_points_entry = zeros(2, size(pointview_mask,2));

    tracked_points_entry(1:2, tracked_descriptors>0) = f2(1:2, tracked_descriptors(tracked_descriptors>0));
    % tracked_points_entry
    pointview_entry(tracked_descriptors == 0) = 0;
    
    if construct_phase
        pointview_mask = vertcat(pointview_mask, pointview_entry);
        pointview = vertcat(pointview, f1(1:2, f1_inlier_indices));
    else
        pointview_mask(end, end-n+1:end) = 1;
        pointview(end-1:end, end-n+1:end) = f1(1:2, new_desc);
    end
    
    pointview_mask = vertcat(pointview_mask, pointview_entry);
    pointview = vertcat(pointview,  tracked_points_entry);
    
end

