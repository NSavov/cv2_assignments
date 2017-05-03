function [ mask ] = get_background_mask( img )
    % todo	
    factor = 8;
    img = imadjust(img, [0.045, 1], []);
    img = double(img * factor);
    size_x = 3;
    filter = double(1/(size_x.^2) * ones([size_x,size_x]));
%     filter = fspecial('average', [size_x, size_x]);
    mask = imfilter(img, filter, 'circular')/255.0;
    threshold = 0.61;
    mask(mask < threshold) = 0;
    mask = imfill(mask,8);
    mask(mask >= threshold) = 1;
    mask = logical(mod(mask, 2));
%     imshow(mask)
%     pause 
end

