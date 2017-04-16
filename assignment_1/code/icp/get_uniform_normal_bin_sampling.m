function [ Sample ] = get_uniform_normal_bin_sampling(Data, Normals, points_divided_into_bins, sample_size)
%UNIFORM_NORMAL_SAMPLING Summary of this function goes here
%   Detailed explanation goes here
    unique_bins = unique(points_divided_into_bins);
    unique_bins = unique_bins(~isnan(unique_bins));
    bins_and_corresponding_indices = get_indices_per_category(points_divided_into_bins, unique_bins);
    frequency_matrix = [unique_bins, histc(points_divided_into_bins(:),unique_bins)];
    min_sample_per_bin = sample_size / size(unique_bins,1);
    indices_to_sample_completely = find(frequency_matrix(:, 2) < min_sample_per_bin);
    total_sampled = 0.0;
    Sample = [];
    for index = indices_to_sample_completely'
        indices = bins_and_corresponding_indices{index};
        Sub_sample = Data(:, indices);
        Sample = [Sample, Sub_sample];
        total_sampled = total_sampled + size(indices,1);
    end
    
    remaining_indices = 1:size(unique_bins, 1);
    remaining_indices(indices_to_sample_completely) = [];
    sub_sample_size = floor((sample_size - total_sampled) / size(remaining_indices, 2));
    for index = remaining_indices 
        Sub_data = Data(:, bins_and_corresponding_indices{index});
        Sub_sample = get_sample(Sub_data, Normals, 'uniform', sub_sample_size);
        Sample = [Sample, Sub_sample];
    end
end

