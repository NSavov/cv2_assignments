addpath code/chaining
addpath code/fundamental_matrix
addpath code/helper
addpath code/plotting_and_printing
addpath code/structure_from_motion
run ./vlfeat/toolbox/vl_setup.m

trials = 100; 
outlier_threshold = 1;
sample_count = 20;


img_names = get_image_names_from_directory('data/', 'png');
% img_names = horzcat({img_names{1+offset}}, {img_names{2+offset}}, {img_names{3+offset:end}});

start_index = 1;
end_index = 5;%size(img_names, 2);

pointview = chain( img_names,start_index, end_index, trials, outlier_threshold, sample_count );
plot_pointview_matrix( pointview )
