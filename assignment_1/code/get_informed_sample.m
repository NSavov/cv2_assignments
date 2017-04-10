function [ sample ] = get_informed_sample( data, sample_size )
%INFORMED_SAMPLING Summary of this function goes here
%   Detailed explanation goes here
%     x = data(1, :);
%     y = data(2, :);
%     z = data(3, :);
%     tri = delaunay(x,y);
%     h = trisurf(tri, x, y, z);
%     size(h)
%     sample = []
%     pc = pointCloud(data');
%     normals = pcnormals(pc);
%     threshold = 0.9;
%     TRI = delaunay(X,Y,Z);
%     patchcurvature(TRI)
    

    x = data(2:3, :);
    y = data([1,3], :);
    z = data([1,2], :);
    [~, ~, k1, k2] = surfature(x',y',z');
    Ap = (abs(1./k1) + abs(1./k2)) ./ 2;
    [~, I] = sort(Ap, 'ascend');
    size(k1)
    I = I(1:sample_size);
    sample = data(:, I);
%     scatter3(sample(1,:), sample(2,:), sample(3,:))
end

