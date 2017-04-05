%   method checks the accuracy, speed, stability, tolerance to noise by
%   selecting the point selecting technique.

techniques = ['all_points', 'uniform_sampling', 'random_sampling', 'informed_sampling'];
% for technique = techniques
    icp_algorithm( threshold, technique )
% end