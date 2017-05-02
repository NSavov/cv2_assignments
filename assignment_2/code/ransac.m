function [ transformation_m, inlier_count, inlier_indices] = ransac(f1, f2, matches, trials, sample_size, outlier_threshold)    
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
        point_index_selection = matches(:, selection);
        
        % eight point algorithm
        p1 = f1(1:2, point_index_selection(1,:)); 
        p2 = f2(1:2, point_index_selection(2,:));
        T = get_normalisation_matrix(p1);
        Tp = get_normalisation_matrix(p2);
        
        % make coordinates homogenous
        p1h = p1;
        p1h(3,:) = 1;
        p2h = p2;
        p2h(3,:) = 1;
        
        % normalizing p1 and p2
        p1n = T * p1h;
        p2n = Tp * p2h;
        
        A = construct_a_matrix(p1n(:, 1:2), p2n(:, 1:2));
        [~, ~, V] = svd(A);
        F = reshape(V(end,:), [3,3]);
        
        % correct F
        [Uf, Df, Vf] = svd(F);
        Df(3,3) = 0;
        F = Uf*Df*Vf;
        F = Tp'*F*T; % denormalise

        % calculate inliers with the obtained t vector
        current_inlier_count = get_inlier_count(all_matches_f1, all_matches_f2, F, outlier_threshold);  
        % update best sample if necessary
        if current_inlier_count > inlier_count
            inlier_count = current_inlier_count;
            inlier_indices = selection;
            transformation_m = F;
        end
    end
end

