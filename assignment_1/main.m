%   method checks the accuracy, speed, stability, tolerance to noise by
%   selecting the point selecting technique.
addpath plotting_code
addpath code
global param_is_plotting; param_is_plotting = true;


sampling_techniques = ['all_points', 'uniform_sampling', 'random_sampling', 'informed_sampling'];
sampling_technique = 'all_points';
threshold = 0.0001;
% for technique = techniques
    temp = load('source.mat');
    Source_pc = temp.source;
    temp = load('target.mat');
    Target_pc = temp.target;
    icp_algorithm(Source_pc, Target_pc, threshold, sampling_technique)
% end