function [ boolean_descriptor_matrix, decriptors, locations ] = construct_pointview_matrix( match_list )
%CONSTRUCT_POINTVIEW_MATRIX Summary of this function goes here
%   Detailed explanation goes here
    % setup by using first image
    f1 = match_list{1}{1};
    d1 = match_list{1}{2};
    
    % 128 x n, n is the number of unique descriptors
    decriptors = d1;
    
    % rows = imgs
    % columns = descriptors
    img_count = size(match_list, 2);
    boolean_descriptor_matrix = zeros([img_count, 0]);
    boolean_descriptor_matrix(1, end+size(d1,2)) = 0;
    boolean_descriptor_matrix(1, :) = 1;
    
    % for each descriptor save the location of the matches.
    % if a new match is found, it's appended to the cell array that matches
    % with the indices of the descriptor.
    locations = num2cell(f1, 1);
    
%     % rest of images
%     for r = 2:size(row_count, 2)
%        f1 = match_list{r}{1};
%        d1 = match_list{r}{2};
%     end
end

