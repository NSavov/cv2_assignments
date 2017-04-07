%   method checks the accuracy, speed, stability, tolerance to noise by
%   selecting the point selecting technique.
addpath plotting_code
addpath code
global param_is_plotting; param_is_plotting = true;

sampling_techniques = ('allpoints', 'uniform', 'random', 'informed');
sampling_technique = 'allpoints';
sample_size = 3200;
threshold = 0.0001;
% for technique = techniques
    temp = load('source.mat');
    Source_pc = temp.source;
    temp = load('target.mat');
    Target_pc = temp.target;

    icp_algorithm(Source_pca, Target_pca, thresholda, sampling_techniquea, sample_size)
% end