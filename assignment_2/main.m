addpath code
run ./vlfeat/toolbox/vl_setup.m

img_names = get_image_names_from_directory('data/', 'png');
im1 = imread(img_names{1});
for img_n = {img_names{2:end}}
    im2 = imread(img_n{1});
    % fundamental_matrix
    fm = get_fundamental_matrix(im1, im2);
    pause
end
