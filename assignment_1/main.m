%   method checks the accuracy, speed, stability, tolerance to noise by
%   selecting the point selecting technique.

sampling_techniques = ['all_points', 'uniform_sampling', 'random_sampling', 'informed_sampling'];
sampling_technique = 'all_points';
threshold = inf;
% for technique = techniques
    temp = load('source.mat');
    Source_pc = temp.source;
    temp = load('target.mat');
    Target_pc = temp.target;
    icp_algorithm(Source_pc, Target_pc, threshold, sampling_technique)
% end