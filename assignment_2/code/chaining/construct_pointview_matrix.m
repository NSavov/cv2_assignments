function [ boolean_descriptor_matrix, locations ] = construct_pointview_matrix( descriptors_per_imgs )
%CONSTRUCT_POINTVIEW_MATRIX Summary of this function goes here
%   Detailed explanation goes here
    % setup by using first image
%     {f1, d1, f2, d2, matches, inlier_indices};
    img_pair_index = 1;
    matches_n = descriptors_per_imgs{img_pair_index}{5};
    inlier_indexes_n = descriptors_per_imgs{img_pair_index}{6};
    sel_p = matches_n(1, inlier_indexes_n);
    sel_n = matches_n(2, inlier_indexes_n);
    f_p = descriptors_per_imgs{img_pair_index}{1}(:, sel_p);
    d_p = descriptors_per_imgs{img_pair_index}{2}(:, sel_p);
    f_n = descriptors_per_imgs{img_pair_index}{3}(:, sel_n);
    d_n = descriptors_per_imgs{img_pair_index}{4}(:, sel_n);
    
    inlier_count_consequative_frames = size(inlier_indexes_n, 1);
    zeros(inlier_count_consequative_frames);
    
    % rows = imgs
    % columns = descriptors
    img_count = size(descriptors_per_imgs, 2);
    boolean_descriptor_matrix = zeros([img_count, 0]);
    boolean_descriptor_matrix(1, end+size(matches_n, 2)) = 0;
    boolean_descriptor_matrix(1:2, :) = 1; 

    % for each descriptor save the location of the matches.
    % if a new match is found, it's appended to the cell array that matches
    % with the indices of the descriptor.
    locations = num2cell(f_p, 1);
    locations = [locations; num2cell(f_n, 1)];

    % loop
    sel_pn = sel_n;
    img_pair_index = img_pair_index + 1;
    matches_n = descriptors_per_imgs{img_pair_index}{5};
    inlier_indexes_n = descriptors_per_imgs{img_pair_index}{6};
    
    sel_p = matches_n(1, inlier_indexes_n);
    consequative_pair_corr = intersect(sel_pn, sel_p);
    consequative_pair_diff = setdiff(sel_p, consequative_pair_corr');
    boolean_descriptor_matrix(:, end:end+size(consequative_pair_diff,2)) = 0;
    boolean_descriptor_matrix(img_pair_index:img_pair_index+1, (end-size(consequative_pair_diff,2)):end) = 1;
    offset = 1;
    locations(img_pair_index, offset:end+size(consequative_pair_diff,2)) = [locations(img_pair_index,:), num2cell(descriptors_per_imgs{img_pair_index-1}{3}(:, consequative_pair_diff), 1)];
%     locations = [locations; [locations(img_pair_index,:), num2cell(descriptors_per_imgs{img_pair_index-1}{3}(:, consequative_pair_diff), 1)]
end

