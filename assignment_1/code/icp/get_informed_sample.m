function [ Sample ] = get_informed_sample( data, sample_size )
%INFORMED_SAMPLING Summary of this function goes here
%     [~, Ap] = find_point_normals(data(1:3, :)', 40);
%     [~, I] = sort(Ap, 'descend');
%     I = I(1:sample_size);
%     Sample = data(:, I);
    [Nx, Ny, Nz] = surfnorm(data(1,:), data(2,:), data(3,:));
    size(Nx)
    Samplem= [];
end