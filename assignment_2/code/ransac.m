function [ transformation_m, inlier_count, inlier_indices] = ransac(f1, f2, matches, trials, sample_size)    
    inlier_count = -1;
    inlier_indices = [];
    transformation_m = [];
    all_matches_f1 = f1(1:2, matches(1, :));
    all_matches_f2 = f2(1:2, matches(2, :));
    
    % ransac loop for [trials] number of time to obtain best match
    for i = 1:trials
        % pick [sample_size] random samples
        shuffled_indices = randperm(size(matches,2));
        selection = shuffled_indices(1:sample_size);
        point_selection = matches(:, selection);
        
        % construct t vector
        p1 = f1(1:2, point_selection(1,:));
        p2 = f2(1:2, point_selection(2,:));
        b = reshape(p2, [numel(p2), 1]);
        A = construct_a_matrix(p1);
        t = pinv(A)*b;
        pixel_outlier_threshold = 10; % in pixels
        
        % calculate inliers with the obtained t vector
        inliers = calculate_inliers(all_matches_f1, all_matches_f2, t, pixel_outlier_threshold);  
        current_inlier_count = length(inliers);
        
        % update best sample if necessary
        if current_inlier_count > inlier_count
            inlier_count = current_inlier_count;
            inlier_indices = selection;
            transformation_m = t;
        end
    end
end

