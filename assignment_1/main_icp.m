%   method checks the accuracy, speed, stability, tolerance to noise by
%   selecting the point selecting technique.
addpath plotting_code
addpath code/icp
global param_is_plotting; param_is_plotting = true;

global param_is_testing_accuracy; param_is_testing_accuracy = true;
times_run_accuracy = 3;
global param_is_timing; param_is_timing = true;
times_run_timing = 3;
global param_is_testing_tolerance; param_is_testing_tolerance = true; 
times_run_tolerance = 3;
global param_is_testing_stability; param_is_testing_stability = true;
times_run_stability = 3;

prev_param_is_testing_accuracy = param_is_testing_accuracy; prev_param_is_timing = param_is_timing; prev_param_is_testing_tolerance = param_is_testing_tolerance; prev_param_is_testing_stability = param_is_testing_stability;

delete plots/*.pdf
delete plots/*.fig
delete test_results/*.csv

sampling_techniques = {'allpoints', 'uniform', 'uniformspatial', 'random', 'informed'};
sample_size = 1000;
sample_size_uniformspatial = 0.001;
threshold = 0.0001;

sample_size_iter = sample_size;
for sampling_technique = sampling_techniques
    sampling_technique = sampling_technique{1};
    
    if strcmp(sampling_technique, 'uniformspatial')
        sample_size_iter = sample_size_uniformspatial;
    else
        sample_size_iter = sample_size;
    end
    
    temp = load('source.mat');
    Source_pc = temp.source;
    temp = load('target.mat');
    Target_pc = temp.target;
    
    Source_pc(end+1,:) = 1;
    Target_pc(end+1,:) = 1;
    
    if param_is_testing_accuracy
        error_matrix = zeros([1, times_run_accuracy]);
        for x = 1:times_run_accuracy
            [~, ~, ~, errors] = icp_algorithm(Source_pc, Target_pc, threshold, sampling_technique, sample_size_iter);
            error_matrix(x) = errors(end);
        end
        csvwrite(strcat('test_results/accuracy_', sampling_technique, '_iter', int2str(times_run_accuracy), '.csv'), error_matrix)
    end
    
    if param_is_timing
        f_timings = zeros([1, times_run_timing]);
        g_timings = zeros([1, times_run_timing]);
        for x = 1:times_run_timing
            f = @() sample(Source_pc, sampling_technique, sample_size_iter);
            f_timings(1, x) = timeit(f);
            g = @() sample(Target_pc, sampling_technique, sample_size_iter);  
            g_timings(1, x) = timeit(g);
        end 
        csvwrite(strcat('test_results/timing_', sampling_technique, '_iter', int2str(times_run_timing), '.csv'), [f_timings;g_timings])
    end
    
    if param_is_testing_tolerance
        error_matrix = zeros([1, times_run_tolerance]);
        for x = 1:times_run_tolerance
            Source_pc_noise = Source_pc+0.05*randn(size(Source_pc));
            Target_pc_noise = Target_pc+0.05*randn(size(Target_pc));
            [~, ~, ~, errors] = icp_algorithm(Source_pc_noise, Target_pc_noise, threshold, sampling_technique, sample_size_iter);
            error_matrix(x) = errors(end);
        end
        csvwrite(strcat('test_results/tolerance_', sampling_technique, '_iter', int2str(times_run_tolerance), '.csv'), error_matrix)
    end
    
    if param_is_testing_stability
        error_matrix = zeros([1, times_run_stability]);
        for x = 1:times_run_stability
            [~, ~, ~, errors] = icp_algorithm(Source_pc, Target_pc, threshold, sampling_technique, sample_size_iter);
            error_matrix(x) = errors(end);
        end
        csvwrite(strcat('test_results/stability_', sampling_technique, '_iter', int2str(times_run_tolerance), '.csv'), error_matrix)
    end
       
    % normal run
    param_is_testing_accuracy = false; param_is_timing = false; param_is_testing_tolerance = false; param_is_testing_stability = false;
    icp_algorithm(Source_pc, Target_pc, threshold, sampling_technique, sample_size_iter);
    
    % restore previous settings
    param_is_testing_accuracy = prev_param_is_testing_accuracy; param_is_timing = prev_param_is_timing; param_is_testing_tolerance = prev_param_is_testing_tolerance; param_is_testing_stability = prev_param_is_testing_stability;
end