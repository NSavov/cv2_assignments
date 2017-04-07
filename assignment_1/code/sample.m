function [ Sampled_data ] = sample(Data, sampling_technique, sample_size )
%SAMPLE Summary of this function goes here
%   Detailed explanation goes here

    switch sampling_technique
        case 'allpoints'
            Sampled_data = Data;
            
        case 'uniform' 
            step = size(Data, 2)/sample_size;
            Sampled_data = Data(:, 1:step:end);
            
        case 'random'
            Sampled_data = datasample(Data,sample_size, 2, 'Replace', false);
            
%         case 'informed_sampling'
            %WTF do I do here
    end

end

