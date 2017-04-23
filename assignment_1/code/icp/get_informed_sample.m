function [ Sample ] = get_informed_sample( Data, Normals, size )
%INFORMED_SAMPLING Summary of this function goes here
    num_bins = 256;
    points_divided_into_bins = get_points_indices_divided_in_bins(Normals, num_bins);
    Sample = get_uniform_normal_bin_sampling(Data, Normals, points_divided_into_bins, size);
end