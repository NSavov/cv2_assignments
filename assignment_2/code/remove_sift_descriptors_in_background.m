function [f, d] = remove_sift_descriptors_in_background( f, d, im )
%REMOVE_SIFT_DESCRIPTORS_IN_BACKGROUND Summary of this function goes here
%   Detailed explanation goes here
    mask = get_background_mask(im);
    indices_to_remove = [];
    index = 1;
    x_width = size(im, 1);
    y_width = size(im, 2);
    size(f)
    for loc = f  
       x = int64(loc(1));
       y = int64(loc(2));
       if x >= 0 && x <= y_width && y >= 0 && y <= x_width
           if ~mask(y, x)
               indices_to_remove = [indices_to_remove, index]; 
           end
        end
       index = index + 1;  
    end
    f(:, indices_to_remove) = [];
    d(:, indices_to_remove) = [];
end

