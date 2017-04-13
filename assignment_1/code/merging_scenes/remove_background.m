function [ pointcloud ] = remove_background( pointcloud )
%REMOVE_BACKGROUND Summary of this function goes here
%   Detailed explanation goes here
    col_idx = pointcloud(3, :) <= 2;
    pointcloud = pointcloud(:, col_idx);
end

