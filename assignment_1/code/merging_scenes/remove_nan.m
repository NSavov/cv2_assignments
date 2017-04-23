function [ pointcloud, pointcloud_normals ] = remove_nan( pointcloud, pointcloud_normals)
%REMOVE_BACKGROUND Summary of this function goes here
%   Detailed explanation goes here
    nan_mask = isnan(pointcloud);
    nan_mask = any(nan_mask, 1);
    nan_mask = abs(nan_mask - 1);
    if ~isempty(pointcloud_normals)
        pointcloud_normals = pointcloud_normals(:, find(nan_mask)); 
    end
    
    pointcloud = pointcloud(:, find(nan_mask));
end