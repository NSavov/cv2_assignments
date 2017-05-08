function [ ] = plot_pointview_matrix( pointview )
%PLOT_POINTVIEW_MATRIX Summary of this function goes here
%   Detailed explanation goes here

    repeat_count = int64(size(pointview, 2)/size(pointview, 1));
    pointview_extended = zeros(size(pointview, 1)*repeat_count, size(pointview, 2));
    for pointview_row_ind = 1:(size(pointview, 1))
        for copy_row_ind = ((pointview_row_ind-1)*repeat_count)+1:((pointview_row_ind-1)*repeat_count+repeat_count)
            pointview_extended(copy_row_ind, :) = pointview(pointview_row_ind,:);
        end
    end
    clf
    imshow(pointview_extended)
end

