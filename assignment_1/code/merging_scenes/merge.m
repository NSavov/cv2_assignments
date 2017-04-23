function [ pointcloud ] = merge( pc, frame, merge_sample_size )
%MERGE Summary of this function goes here
%   Detailed explanation goes here

    intersection_available = true;
    %find bounding box of pc
    pc_bbox = boundingBox3d(pc');
    
    %find bounding box of frame
    frame_bbox = boundingBox3d(frame');
    
    %intersect bounding boxes
    intersect_box = intersectBoxes3d(pc_bbox, frame_bbox);
    
    %uniform spatial sampling (average) on the intersection with a small box size
    min_p = [intersect_box(1);intersect_box(3);intersect_box(5)];
    max_p = [intersect_box(2);intersect_box(4);intersect_box(6)];
    
    %if there is no intersection, just take the union
    if any(min_p ~= min(min_p, max_p)) || any(max_p ~= max(min_p, max_p))
        intersection_available = false;
    end
    
    sampled = [];
    pointcloud = [pc frame];
    
    if intersection_available
        inside_mask = all(pointcloud(:,:)>min_p & pointcloud(:,:)<max_p, 1);
        outside_mask = abs(inside_mask - 1);
        [~, col] = find(inside_mask==1);

        points_for_sampling = pointcloud(:, col);
        
        if ~isempty(points_for_sampling)
            sampled = get_sample(points_for_sampling, [], 'uniformspatial', merge_sample_size);
        end
        [~, col] = find(outside_mask==1);
        preserved_points = pointcloud(:, col);
        
        %construct the cloud from the non-sampled and sampled parts
        pointcloud = [preserved_points sampled];
    end
    
    %sort the coordinates so the cloud could be prepared for a uniform
    %sampling
    pointcloud = sortrows(pointcloud', 1)';
end
