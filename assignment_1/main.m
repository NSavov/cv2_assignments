%   method checks the accuracy, speed, stability, tolerance to noise by
%   selecting the point selecting technique.
addpath plotting_code
addpath code
global param_is_plotting; param_is_plotting = true;
delete plots/*.pdf
delete plots/*.fig

sampling_techniques = {'allpoints', 'uniform', 'random', 'informed'};
sampling_technique = 'informed';
<<<<<<< Updated upstream
sample_size = 30000;
threshold = 0.0001;
=======
sample_size = 1000;
threshold = 0.000;
>>>>>>> Stashed changes
% for technique = techniques
    temp = load('source.mat');
    Source_pc = temp.source;
    temp = load('target.mat');
    Target_pc = temp.target;
<<<<<<< Updated upstream
    
    Source_pc(end+1,:) = 1;
    Target_pc(end+1,:) = 1;
    
    start_t = tic;
    icp_algorithm(Source_pc, Target_pc, threshold, sampling_technique, sample_size)
    toc(start_t)
=======
    icp_algorithm(Source_pc, Target_pc, threshold, sampling_technique, sample_size);
>>>>>>> Stashed changes
% end