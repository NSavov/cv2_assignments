function [ Sampled_data ] = sample(Data, sampling_technique, sample_size )
%SAMPLE Summary of this function goes here
%   Detailed explanation goes here

    switch sampling_technique
        case 'allpoints'
            Sampled_data = Data;
        case 'uniform' 
            step = size(Data, 2)/sample_size;
            pc_size = inf;
            block_size = 0.01;
            block_size_step = 0.01;
            pc = pointCloud(Data');
            Sampled_data_new = [];
            
            while pc_size > sample_size
                pc_sampled = pcdownsample(pc,'gridAverage',block_size);
                Sampled_data = Sampled_data_new;
                Sampled_data_new = pc_sampled.Location';
                pc_size = size(Sampled_data_new, 2);
                block_size = block_size + block_size_step;
            end
            
            Sampled_data = sample(Sampled_data, 'random', sample_size);
            
            %use this for visualization:
            %pcshow(pointCloud(Sampled_data'));
            
            %old way:
%             Sampled_data = Data(:, 1:step:end);
            
            
        case 'random'
            Sampled_data = datasample(Data,sample_size, 2, 'Replace', false);
%         case 'informed_sampling'
            %WTF do I do here
            normals = pcnormals(ptCloud);
    end

end

