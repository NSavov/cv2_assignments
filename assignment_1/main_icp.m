%   method checks the accuracy, speed, stability, tolerance to noise by
%   selecting the point selecting technique.
addpath plotting_code
addpath code/icp
global param_is_plotting; param_is_plotting = true;

global param_is_testing_stability; param_is_testing_stability = false;
times_run_stability = 25;
global param_is_timing; param_is_timing = false;
times_run_timing = 25;
global param_is_testing_tolerance; param_is_testing_tolerance = false; 
times_run_tolerance = 25;
is_testing = false;

prev_param_is_testing_stability = param_is_testing_stability; prev_param_is_timing = param_is_timing; prev_param_is_testing_tolerance = param_is_testing_tolerance;

delete plots/*.pdf
delete plots/*.fig
delete test_results/*.csv

if is_testing
    sampling_techniques = {'allpoints', 'uniform', 'uniformspatial', 'random'};
    sample_size_uniformspatial = 0.1685;
else
    sampling_techniques = {'allpoints'};
%     sampling_techniques = {'allpoints', 'uniform', 'uniformspatial', 'random', 'informed'};
%     todo change
    sample_size_uniformspatial = 0.1685;
end
sample_size = 1000;
threshold = 0;

sample_size_iter = sample_size;
for sampling_technique = sampling_techniques
    sampling_technique = sampling_technique{1};
    
    if strcmp(sampling_technique, 'uniformspatial')
        sample_size_iter = sample_size_uniformspatial;
    else
        sample_size_iter = sample_size;
    end
    
    if is_testing
        temp = load('source.mat');
        Source_pc = temp.source;
        temp = load('target.mat');
        Target_pc = temp.target;
        Source_normals = [];
        Target_normals = [];
    else 
        Source_pc = read_point_cloud('data/0000000000.pcd')';
        Target_pc = read_point_cloud('data/0000000001.pcd')';
        Source_normals = read_point_cloud('data/0000000000_normal.pcd')'; 
        Target_normals = read_point_cloud('data/0000000001_normal.pcd')';
    end
%     Source_pc_object = pointCloud(Source_pc(1:3, :)');
%     Target_pc_object = pointCloud(Target_pc(1:3, :)');
%     pcshowpair(Source_pc_object,Target_pc_object)
    if param_is_testing_stability
        error_matrix = zeros([1, times_run_stability]);
        for x = 1:times_run_stability
            [~, ~, ~, errors] = icp_algorithm(Source_pc, Source_normals, Target_pc, Target_normals, threshold, sampling_technique, sample_size_iter);
            error_matrix(x) = errors(end);
        end
        csvwrite(strcat('test_results/stability_', sampling_technique, '_iter', int2str(times_run_stability), '.csv'), error_matrix)
    end
    
    if param_is_timing
        f_timings = zeros([1, times_run_timing]);
        g_timings = zeros([1, times_run_timing]);
        for x = 1:times_run_timing
            f = @() sample(Source_pc, Source_normals, sampling_technique, sample_size_iter);
            f_timings(1, x) = timeit(f);
            g = @() sample(Target_pc, Target_normals, sampling_technique, sample_size_iter);  
            g_timings(1, x) = timeit(g);
        end 
        csvwrite(strcat('test_results/timing_', sampling_technique, '_iter', int2str(times_run_timing), '.csv'), [f_timings;g_timings])
    end
    
    if param_is_testing_tolerance
        error_matrix = zeros([1, times_run_tolerance]);
        for x = 1:times_run_tolerance
            Source_pc_noise = Source_pc+0.05*randn(size(Source_pc));
            Target_pc_noise = Target_pc+0.05*randn(size(Target_pc));
            [~, ~, ~, errors] = icp_algorithm(Source_pc, Source_normals, Target_pc, Target_normals, threshold, sampling_technique, sample_size_iter);
            error_matrix(x) = errors(end);
        end
        csvwrite(strcat('test_results/tolerance_', sampling_technique, '_iter', int2str(times_run_tolerance), '.csv'), error_matrix)
    end
       
    % normal run
    param_is_testing_stability = false; param_is_timing = false; param_is_testing_tolerance = false;
    icp_algorithm(Source_pc, Source_normals, Target_pc, Target_normals, threshold, sampling_technique, sample_size_iter);
    
    % restore previous settings
    param_is_testing_stability = prev_param_is_testing_stability; param_is_timing = prev_param_is_timing; param_is_testing_tolerance = prev_param_is_testing_tolerance;
end