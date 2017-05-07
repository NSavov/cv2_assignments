clc;
clear;

fx = 526.37013657; %focal length in width
fy = 526.37013657; %focal length in height
cx = 313.68782938; %principal point in width
cy = 259.01834898; %principal point in height

file_path = 'depth.png'; %depth image path
depth = imread(file_path); %load depth image
depth = double(depth) * 0.001; %scale depth image from mm to meter.
[cloud, ordered]= depth2cloud(depth, fx, fy,cx,cy); % convert from the depth image to cloud

X = cloud(:,1);
Y = cloud(:,2);
Z = cloud(:,3);
scatter3(X,Y,Z);
