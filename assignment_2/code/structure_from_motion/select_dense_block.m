function [ filtered_points, first, last ] = select_dense_block(pointview, pointview_mask, interval, skip)
%SELECT_DENSE_BLOCK Summary of this function goes here
%   Detailed explanation goes here
    best_block_size = 0;
    for i = 1:size(pointview_mask, 1)-(interval-1)*(skip+1)
        dense_block = pointview_mask(i:skip+1:i+(skip+1)*(interval-1),:);

        if size(all(dense_block), 2) > best_block_size
            best_block_size = size(all(dense_block), 2);
            best_dense_block = dense_block;
            first = i;
            last = i+interval-1;
        end
    end

    point_indices = find(all(best_dense_block));  
    filtered_points = pointview(2*(first-1)+1:(skip+1)*2*last, point_indices);

    skip_mask = [1 1 0 0];
    skip_mask = repmat(skip_mask, 1, ceil(size(filtered_points, 1)/4))';
    filtered_points = filtered_points(find(skip_mask==1), :);
end

