% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017
%
%   method checks the accuracy, speed, stability, tolerance to noise by
%   selecting the point selecting technique.
addpath code/plots
addpath code/icp
addpath code/merging_scenes

% settings that enable/disable plotting and specific tests, stability,
% timing, tolerance and whether the simple source/target.pcd is used
% or the person data
global param_is_plotting; param_is_plotting = false;
global param_is_testing_stability; param_is_testing_stability = false;
times_run_stability = 25;
global param_is_timing; param_is_timing = false;
times_run_timing = 25;
global param_is_testing_tolerance; param_is_testing_tolerance = false; 
times_run_tolerance = 25;
global is_testing, is_testing = false;

prev_param_is_testing_stability = param_is_testing_stability; prev_param_is_timing = param_is_timing; prev_param_is_testing_tolerance = param_is_testing_tolerance;

% to not clutter the download folder, remove files from the previous run
% delete plots/*.pdf
% delete plots/*.fig
% delete test_results/*.csv

% When testing the toy data is used of which no normals are given. As
% result no informed normal sampling can be carried out as normals lack for
% this data-set. In addition, the sample_size_uniformspatial parameter
% determines the box-size of the iniformspatial which results in about 1000
% points, which we used to compare the different sampling techniques. 
% This parameter is used instead of sample_size for only this method.
if is_testing
    sampling_techniques = {'allpoints', 'uniform', 'uniformspatial', 'random'};
    sample_size_uniformspatial = 0.01685;
else
    sampling_techniques = {'allpoints', 'uniform', 'uniformspatial', 'random', 'informed'};
    sample_size_uniformspatial = 0.0196;
end
sample_size = 1000;
% a higher threshold can be used for early stopping
threshold = 0;

sample_size_iter = sample_size;
for sampling_technique = sampling_techniques
    sampling_technique = sampling_technique{1}
    
    if strcmp(sampling_technique, 'uniformspatial')
        sample_size_iter = sample_size_uniformspatial;
    else
        sample_size_iter = sample_size;
    end
    
    % if testing use toy example, else use the human point cloud with normals.    
    if is_testing
        temp = load('source.mat');
        Source_pc = temp.source;
        temp = load('target.mat');
        Target_pc = temp.target;
        Source_normals = [];
        Target_normals = [];
    else 
        Source_pc = readPcd('data/0000000000.pcd')';
        Source_normals = readPcd('data/0000000000_normal.pcd')'; 
        [Source_pc, Source_normals] = remove_background(Source_pc, Source_normals);
        Target_pc = readPcd('data/0000000001.pcd')';
        Target_normals = readPcd('data/0000000001_normal.pcd')';
        [Target_pc, Target_normals] = remove_background(Target_pc, Target_normals);
        [Source_pc, Source_normals, Target_pc, Target_normals] = equalize_point_count(Source_pc, Source_normals, Target_pc, Target_normals);
        Source_pc = Source_pc(1:3, :);
        Source_normals = Source_normals(1:3, :);
        Target_pc = Target_pc(1:3, :);
        Target_normals = Target_normals(1:3, :);
    end

    % If testing stability run the algorithm times_run_stability number of times.
    % Results are saved in test_results.
    if param_is_testing_stability
        'testing_stability'
        error_matrix = zeros([1, times_run_stability]);
        for x = 1:times_run_stability
            x
            [~, ~, ~, errors] = icp_algorithm(Source_pc, Source_normals, Target_pc, Target_normals, threshold, sampling_technique, sample_size_iter);
            error_matrix(x) = errors(end);
        end
        csvwrite(strcat('test_results/stability_', sampling_technique, '_iter', int2str(times_run_stability), '.csv'), error_matrix)
    end
    
    % Time the run speed of the algorithm times_run_timing number of times.
    % Results are saved in test_results.
    if param_is_timing
        'timing'
        f_timings = zeros([1, times_run_timing]);
        g_timings = zeros([1, times_run_timing]);
        for x = 1:times_run_timing
            x
            f = @() icp_algorithm(Source_pc, Source_normals, Target_pc, Target_normals, threshold, sampling_technique, sample_size_iter);
            f_timings(1, x) = timeit(f);
        end 
        csvwrite(strcat('test_results/timing_', sampling_technique, '_iter', int2str(times_run_timing), '.csv'), f_timings)
    end
    
    % Add gaussian noise (0.05 * random distribution) and test whether the
    % performance of the algorithm is negatively affected over
    % times_run_tolerance number of times.
    % Results are saved in test_results.
    if param_is_testing_tolerance
        'testing_tolerance'
        error_matrix = zeros([1, times_run_tolerance]);
        for x = 1:times_run_tolerance
            x
            % noise is added to both source and target (normals/pointcloud)             
            Source_pc_noise = Source_pc+0.05*randn(size(Source_pc));
            Target_pc_noise = Target_pc+0.05*randn(size(Target_pc));
            Source_normals = Source_normals+0.05*randn(size(Target_pc));
            Target_normals = Target_normals+0.05*randn(size(Target_pc));
            [~, ~, ~, errors] = icp_algorithm(Source_pc_noise, Source_normals, Target_pc_noise, Target_normals, threshold, sampling_technique, sample_size_iter);
            error_matrix(x) = errors(end);
        end
        csvwrite(strcat('test_results/tolerance_', sampling_technique, '_iter', int2str(times_run_tolerance), '.csv'), error_matrix)
    end
       
    % normal run
    % Independent of all settings a normal run is carried out. For this the
    % settings need to be set to default and restored afterwards.
    param_is_testing_stability = false; param_is_timing = false; param_is_testing_tolerance = false;
    icp_algorithm(Source_pc, Source_normals, Target_pc, Target_normals, threshold, sampling_technique, sample_size_iter);
    
    % restore previous settings
    param_is_testing_stability = prev_param_is_testing_stability; param_is_timing = prev_param_is_timing; param_is_testing_tolerance = prev_param_is_testing_tolerance;
end