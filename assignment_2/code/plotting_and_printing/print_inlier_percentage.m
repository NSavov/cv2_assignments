function print_inlier_percentage( max_inliers, inlier_count )
    % todo
    pct = inlier_count/double(max_inliers(:, 2));
    disp(strcat(num2str(pct), '% inliers (', num2str(inlier_count), '/', num2str(max_inliers(:, 2)), ')'))
end

