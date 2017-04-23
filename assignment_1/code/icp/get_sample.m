function [ Sampled_data ] = get_sample(Data, Normals, sampling_technique, sample_size)
%SAMPLE Summary of this function goes here
%   Detailed explanation goes here
    switch sampling_technique
        case 'allpoints'
            Sampled_data = Data;
            
        case 'uniform' 
            step = floor(size(Data, 2)/sample_size);
            Sampled_data = Data(:, 1:step:end);
       
        case 'uniformspatial'   
            % TODO, make it work for 4d
%             Sampled_data = get_uniform_sample(Data, sample_size);un
            pc = pointCloud(Data(1:3, :)');
            pc_sampled = pcdownsample(pc,'gridAverage',sample_size);
            Sampled_data = pc_sampled.Location';
            %pcshow(pointCloud(Sampled_data'));
          
        case 'random'
            Sampled_data = datasample(Data,sample_size, 2, 'Replace', false);
            
        case 'informed'
            Sampled_data = get_informed_sample(Data, Normals, sample_size);
    end
    
    f_name = strcat('plots/', sampling_technique);
    if ~(exist(strcat(f_name, '.fig'), 'file') == 2)
        global param_is_plotting
        global param_is_testing_stability
        global param_is_timing
        global param_is_testing_tolerance
        if param_is_plotting && ~(param_is_timing || param_is_testing_tolerance || param_is_testing_stability)
            fig_handle = figure(99);
            pcshow(pointCloud(Sampled_data'));
            saveas(fig_handle, f_name);
%             print(fig_handle, '-dpdf', strcat(sampling_technique, '_okerror'), '.pdf');
            close(fig_handle)
        end
    end
end

