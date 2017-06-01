addpath code/chaining
addpath code/fundamental_matrix
addpath code/helper
addpath code/plotting_and_printing
addpath code/structure_from_motion
run ./vlfeat/toolbox/vl_setup.m

use_reference = false;
interval = 20;
skip = 0;

% load variables from saved pointview (created in main_chaining.m)
s = matfile('pointview_t0.2.mat');
pointview_mask = s.pointview_mask;
pointview = s.pointview;

%reconstruct 3D points from movement on frames
S = generate_model(pointview_mask, pointview, interval, skip, use_reference);

% plot 3D points
tri = delaunay(S(1,:),S(2,:));
h = trisurf(tri, S(1,:), S(2,:), S(3,:));
