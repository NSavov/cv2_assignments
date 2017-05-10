addpath code/chaining
addpath code/fundamental_matrix
addpath code/helper
addpath code/plotting_and_printing
addpath code/structure_from_motion
run ./vlfeat/toolbox/vl_setup.m

trials = 100; 
outlier_threshold = 1;
sample_count = 8;


img_names = get_image_names_from_directory('data/', 'png');
start_index = 1;
end_index = 5;%size(img_names, 2);

[pointview, tracked_descriptors] = chain( img_names,start_index, end_index, trials, outlier_threshold, sample_count );


%select dense block and extract overlapping points
dense_block = pointview(:,:);
point_indices = find(all(dense_block));
filtered_points = tracked_descriptors(:, :, point_indices);


%normalize 
filtered_points = filtered_points - sum(filtered_points, 3)/size(filtered_points, 3);


splitted = num2cell(filtered_points, [2 3]); %split A keeping dimension 2 and 3 intact
splitted = cellfun(@squeeze, splitted,'UniformOutput', false);
D = vertcat(splitted{:});

%derive shape and motion matrices
[U,W,V] = svd(D);
U3 = U(:, 1:3);
W3 = W(1:3, 1:3);
V3 = V(:, 1:3);

M = U3*sqrt(W3);
S = sqrt(W3)*V3';


