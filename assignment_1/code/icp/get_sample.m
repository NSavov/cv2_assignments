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
            pc = pointCloud(Data(1:3, :)');
            pc_sampled = pcdownsample(pc,'gridAverage',sample_size);
            Sampled_data = pc_sampled.Location';
            %pcshow(pointCloud(Sampled_data'));
          
        case 'random'
            Sampled_data = datasample(Data,sample_size, 2, 'Replace', false);
            
        case 'informed'
            Sampled_data = get_informed_sample(Data, Normals, sample_size);
    end

end

