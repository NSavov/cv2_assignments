% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function [ Sampled_data ] = get_sample(Data, Normals, sampling_technique, sample_size)
% Handles all the different function calls to the sampling methods
    switch sampling_technique
        case 'allpoints'
            Sampled_data = Data;
            
        case 'uniform' 
            % naive uniform sampling that samples each dimension uniformly             
            step = floor(size(Data, 2)/sample_size);
            Sampled_data = Data(:, 1:step:end);
       
        case 'uniformspatial'   
            % uniform spatial sampling that uses uniform shifting boxes
            % from which the sub-cluster centroid is returned as 'point'.
            % the sample_size is actually a parameter here that denotes the
            % box size so that there are 1000 points sampled from the point
            % cloud.
            pc = pointCloud(Data(1:3, :)');
            pc_sampled = pcdownsample(pc,'gridAverage',sample_size);
            Sampled_data = pc_sampled.Location';
          
        case 'random'
            % matlab built-in, simply takes random indices from matrix
            Sampled_data = datasample(Data,sample_size, 2, 'Replace', false);
            
        case 'informed'
            % sampling method that uses normals to sample more from more
            % distinct regions that presumably contain more rare normals.
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

