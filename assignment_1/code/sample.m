function [ Sampled_data ] = sample(Data, sampling_technique, sample_size)
%SAMPLE Summary of this function goes here
%   Detailed explanation goes here

    switch sampling_technique
        case 'allpoints'
            Sampled_data = Data;
        case 'uniform' 
            Sampled_data = get_uniform_sample(Data, sample_size);
            %use this for visualization:
            %pcshow(pointCloud(Sampled_data'));
            
            %old way:
%             Sampled_data = Data(:, 1:step:end);
        case 'random'
            Sampled_data = datasample(Data,sample_size, 2, 'Replace', false);
        case 'informed'
            Sampled_data = get_informed_sample(Data, sample_size);
    end

end

