function [ pointcloud ] = merge( pc, frame )
%MERGE Summary of this function goes here
%   Detailed explanation goes here

    intersection_available = true;
    %find bounding box of pc
    pc_bbox = boundingBox3d(pc');
    
    %find bounding box of frame
    frame_bbox = boundingBox3d(frame');
    
    %intersect bounding boxes
    intersect_box = intersectBoxes3d(pc_bbox, frame_bbox);
    
    %uniform average sampling on the intersection with a small box size
    min_p = [intersect_box(1);intersect_box(3);intersect_box(5)];
    max_p = [intersect_box(2);intersect_box(4);intersect_box(6)];
    
    if any(min_p ~= min(min_p, max_p)) || any(max_p ~= max(min_p, max_p))
        intersection_available = false;
    end
    
%     drawBox3d(pc_bbox)
%     hold on
%     drawBox3d(frame_bbox)
%     hold on
%     drawBox3d(intersect_box)
%     hold on
    
    sampled = [];
    pointcloud = [pc frame];
    
    if intersection_available
        inside_mask = all(pointcloud(:,:)>min_p & pointcloud(:,:)<max_p, 1);
        outside_mask = abs(inside_mask - 1);
        [~, col] = find(inside_mask==1);

        points_for_sampling = pointcloud(:, col);
        
        if ~isempty(points_for_sampling)
            sampled = get_sample(points_for_sampling, [], 'uniformspatial', 0.005);
        end
%         sampled = points_for_sampling;
        [~, col] = find(outside_mask==1);
        preserved_points = pointcloud(:, col);
        
        %construct the cloud from the non-sampled and sampled parts
        pointcloud = [preserved_points sampled];
    end
    
    pointcloud = sortrows(pointcloud', 1)';
end
