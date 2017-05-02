function [ t_final, max_inliers, final_inlier_indices, r_inliers, r_inlier_indices,  min_inliers, lowest_inlier_indices ] = ransac(f1, f2, matches, N, P)    
    max_inliers = -1;
    final_inlier_indices = [];
    lowest_inlier_indices = [];
    min_inliers = realmax('single');
    t_final = [];
    
    all_matches_f1 = f1(1:2, matches(1, :));
    all_matches_f2 = f2(1:2, matches(2, :));
    % ransac loop
    for i = 1:N
        % pick P random samples
        random_index_samples = randperm(size(matches,2));
        sel = random_index_samples(1:P); % select P random samples
        rdm_point_sel = matches(:, sel); % use these to select random matches 
        
        % create A matrix and b vector
        p1 = f1(1:2, rdm_point_sel(1,:));
        p2 = f2(1:2, rdm_point_sel(2,:));
        b = reshape(p2, [numel(p2), 1]);
        A = construct_a_matrix(p1);
        t = pinv(A)*b;
        pixel_outlier_threshold = 10;
        
        % calculate inliers with the obtained t vector
        inliers = calculate_inliers(all_matches_f1, all_matches_f2, t, pixel_outlier_threshold);  
        inlier_count = length(inliers);
        % set best sample
        if inlier_count > max_inliers
            max_inliers = inlier_count;
            final_inlier_indices = sel;
            t_final = t;
        end
        
        % set worst sample
        if inlier_count < min_inliers
            min_inliers = inlier_count;
            lowest_inlier_indices = sel;
        end
        
        % set random sample
        if i == 1
            r_inliers = inlier_count;
            r_inlier_indices = sel;
        end
    end
end

