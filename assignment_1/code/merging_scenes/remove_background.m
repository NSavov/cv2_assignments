% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function [ pointcloud, pointcloud_normals ] = remove_background( pointcloud, pointcloud_normals)
%REMOVE_BACKGROUND Summary of this function goes here
%   Detailed explanation goes here
    col_idx = sqrt(pointcloud(1,:).^2 + pointcloud(2,:).^2 + pointcloud(3,:).^2) < 1.6 &  sqrt(pointcloud(1,:).^2 + pointcloud(2,:).^2 + pointcloud(3,:).^2) > 0.7;
    if ~isempty(pointcloud_normals)
        pointcloud_normals = pointcloud_normals(:, col_idx); 
    end
    pointcloud = pointcloud(:, col_idx);
end

