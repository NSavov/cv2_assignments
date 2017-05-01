addpath code

img_names = get_image_names_from_directory('data/', 'png');
for img_n = img_names
    img = imread(img_n{1});
    a = mask_background(img);
    imshow(a);
    pause
end
