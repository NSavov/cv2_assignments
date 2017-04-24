% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function [ Sample ] = get_informed_sample( Data, Normals, size )
% divides points into bins based on the normals, then uniformally samply
% these bins so that bins that contain fewer samples are have a higher
% relative sampling rate to obtain more samples from presumably informative
% regions (regions that contain significant normal differences).
    num_bins = 256;
    points_divided_into_bins = get_points_indices_divided_in_bins(Normals, num_bins);
    Sample = get_uniform_normal_bin_sampling(Data, Normals, points_divided_into_bins, size);
end