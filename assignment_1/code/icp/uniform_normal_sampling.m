function [ Sample ] = uniform_normal_sampling(Data, points_divided_into_bins, sample_size)
%UNIFORM_NORMAL_SAMPLING Summary of this function goes here
%   Detailed explanation goes here
    unique_bins = unique(points_divided_into_bins);
    unique_bins = unique_bins(~isnan(unique_bins));
    bins_and_corresponding_indices = get_indices_per_category(points_divided_into_bins, unique_bins);
    frequency_matrix = [unique_bins, histc(points_divided_into_bins(:),unique_bins)];
    fract_sample_per_bin = sample_size / size(unique_bins,1);
    Sample = [];
    indices_to_sample_completely = find(frequency_matrix(:, 2)<fract_sample_per_bin);
    for index = indices_to_sample_completely
        index
        size(bins_and_corresponding_indices)
        Data(bins_and_corresponding_indices{index})
    end
    Sample = [];
%     
end

