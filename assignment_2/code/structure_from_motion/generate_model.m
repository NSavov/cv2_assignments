function [ S ] = generate_model( pointview_mask, pointview, interval, skip, use_reference )
%GENERATE_MODEL Summary of this function goes here
%   Detailed explanation goes here

    % select dense block and extract overlapping points
    [ filtered_points, first, last ] = select_dense_block(pointview, pointview_mask, interval, skip);

    if use_reference
        filtered_points = dlmread('PointViewMatrix.txt');
    end

    % normalize 
    filtered_points = filtered_points - sum(filtered_points, 2)/size(filtered_points, 2);

    % construct D matrix
    D = filtered_points;%vertcat(splitted{:});

    % derive shape and motion matrices
    [U,W,V] = svd(D);
    U3 = U(:, 1:3);
    W3 = W(1:3, 1:3);
    V3 = V(:, 1:3);

    M = U3*sqrt(W3);
    S = sqrt(W3)*V3';

    % disambiguate
    L = pinv(M)*eye(size(M, 1))*pinv(M');
    C = chol(L)/3;

    M = M*C;
    S = pinv(C)*S;
end

