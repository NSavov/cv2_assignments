addpath code
run ./vlfeat/toolbox/vl_setup.m

trials = 100; 
outlier_threshold = 1;
sample_count = 8;

img_names = get_image_names_from_directory('data/', 'png');
offset = 0;
im1 = imread(img_names{1+offset});
for img_n = {img_names{2+offset:end}}
clf
im2 = imread(img_n{1});
% im2 = imread(img_names{2});

% im1 = imread('data/boat1.pgm');
% im2 = imread('data/boat2.pgm');
fm = get_fundamental_matrix(im1, im2, trials, sample_count, outlier_threshold);
im1 = im2;
pause
end
