function [ Sample ] = get_informed_sample( data, sample_size )
%INFORMED_SAMPLING Summary of this function goes here
    [~, Ap] = findPointNormals(data(1:3, :)', 40);
    [~, I] = sort(Ap, 'descend');
    I = I(1:sample_size);
    Sample = data(:, I);
end