function [ mask ] = get_background_mask( img )
    % todo	
    factor = 10;
    img = imadjust(img, [0.045, 1], []);
    img = imadjust(img);
    im2 = double(img * factor);
    size_x = 15;
    filter = double(1/(size_x.^2) * ones([size_x,size_x]));
    mask = imfilter(im2, filter, 'replicate')/255.0;
    threshold = 0.7;
    mask(mask < threshold) = 0;
    mask = imfill(mask,4,'holes');
    mask(mask >= threshold) = 1;
    mask = logical(mod(mask, 2));
end

