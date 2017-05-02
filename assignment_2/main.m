addpath code
run ./vlfeat/toolbox/vl_setup.m

img_names = get_image_names_from_directory('data/', 'png');
% im1 = imread(img_names{1});
% for img_n = {img_names{2:end}}
% im2 = imread(img_n{1});
% im2 = imread(img_names{2});

im1 = rgb2gray(imread('data/left.jpg'));
im2 = rgb2gray(imread('data/right.jpg'));
fm = get_fundamental_matrix(im1, im2);
% im1 = im2;
% end
