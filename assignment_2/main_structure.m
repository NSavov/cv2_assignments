addpath code/chaining
addpath code/fundamental_matrix
addpath code/helper
addpath code/plotting_and_printing
addpath code/structure_from_motion
run ./vlfeat/toolbox/vl_setup.m

first = 1;
last = 6;

% load variables from saved pointview (created in main_chaining.m)
s = matfile('pointview_t1.mat');
pointview = s.pointview;
tracked_descriptors = s.tracked_descriptors;

% select dense block and extract overlapping points
dense_block = pointview(first:last,:);
point_indices = find(all(dense_block));
filtered_points = tracked_descriptors(2*(first-1)+1:2*last, point_indices);

% normalize 
filtered_points = filtered_points - sum(filtered_points, 2)/size(filtered_points, 2);

% splitted = num2cell(filtered_points, [2 3]); %split A keeping dimension 2 and 3 intact
% splitted = cellfun(@squeeze, splitted,'UniformOutput', false);

% construct D matrix
D = filtered_points;%vertcat(splitted{:});
size(D)
% D = dlmread('PointViewMatrix.txt');

% derive shape and motion matrices
[U,W,V] = svd(D);
U3 = U(:, 1:3);
W3 = W(1:3, 1:3);
V3 = V(:, 1:3);

M = U3*sqrt(W3);
S = sqrt(W3)*V3';

% disambiguate
% L = pinv(M)*eye(size(M, 1))*pinv(M');
L = eye(size(M, 1))/M'\M;
C = chol(L)/3;

M = M*C;
S = pinv(C)*S;

% pc = pointCloud(S);

% pcshow(pc)

% scatter3(S(1,:), S(2,:), S(3,:))
tri = delaunay(S(1,:),S(2,:));
h = trimesh(tri, S(1,:), S(2,:), S(3,:));

%reverse concatenate to retrieve Ai
% l = ones(1, size(M, 1)/2)*2;
% A = mat2cell(M, l, size(M,2));

% for Ai = A{1:end}
%     Ai*filtered_points;
% end

%M * L * M'