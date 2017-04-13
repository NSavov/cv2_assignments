function [ Sample ] = get_informed_sample( Data, Normals, size )
%INFORMED_SAMPLING Summary of this function goes here
%     [~, Ap] = find_point_normals(data(1:3, :)', 40);
%     [~, I] = sort(Ap, 'descend');
%     I = I(1:sample_size);
%     Sample = data(:, I);
    num_bins = 256;
    points_divided_into_bins = get_points_indices_divided_in_bins(Normals, num_bins);
    Sample = uniform_normal_sampling(Data, points_divided_into_bins, size);
end