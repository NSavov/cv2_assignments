function [ pointcloud ] = merge( pc, frame )
%MERGE Summary of this function goes here
%   Detailed explanation goes here

    %find bounding box of pc
    pc_bbox = point3dBounds(pc');
    
    %find bounding box of frame
    frame_bbox = point3dBounds(frame');
    
    %intersect bounding boxes
    intersect_box = intersectBoxes3d(pc_bbox, frame_bbox);
    
    %uniform average sampling on the intersection with a small box size
    
%     scatter3(pc(1, :), pc(2, :),pc(3, :))
%     hold on
%     scatter3(frame(1, :),frame(2, :),frame(3, :))
%     hold on
%     drawBox3d(intersect_box)

    min_p = [intersect_box(1);intersect_box(3);intersect_box(5)];
    max_p = [intersect_box(2);intersect_box(4);intersect_box(6)];
    
    pointcloud = [pc frame];
    inside_mask = all(pointcloud(1:end-1,:)>min_p & pointcloud(1:end-1,:)<max_p, 1);
    outside_mask = abs(inside_mask - 1);
    [~, col] = find(inside_mask==1);
    
    points_for_sampling = pointcloud(:, col);
    size(points_for_sampling)
    sampled = sample(points_for_sampling, 'uniformspatial', 0.01);

    
    %construct the cloud from the non-sampled and sampled parts - sampled +
    %the rest
    [~, col] = find(outside_mask==1);
    preserved_points = pointcloud(:, col);
    pointcloud = [preserved_points sampled];
    pointcloud = sort(pointcloud, 1);
    
    
end
