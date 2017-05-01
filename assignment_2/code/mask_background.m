function [ mask ] = mask_background( img )
%REMOVE_BACKGROUND Summary of this function goes here
    factor = 10;
    img = imadjust(img);
    img = imadjust(img);
    img = imadjust(img);
    img = imadjust(img);
    img = imadjust(img);
    img = imadjust(img);
    img = imadjust(img);
    img = imadjust(img);
    im2 = double(img * factor);
    size_x = 15;
    filter = double(1/(size_x.^2) * ones([size_x,size_x]));
    mask = conv2(im2, filter, 'valid')/255.0;
    threshold = 0.7;
    mask(mask < threshold) = 0;
    mask = imfill(mask,4,'holes');
    mask(mask >= threshold) = 1;
end

