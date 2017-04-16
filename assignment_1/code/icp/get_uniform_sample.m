function [ Sampled_data ] = get_uniform_sample(Data, sample_size)
%UNIFORM Summary of this function goes here
%   Detailed explanation goes here
    step = size(Data, 2)/sample_size;
    pc_size = inf;
    block_size = 0.001;
    block_size_step = 0.0003;
    pc = pointCloud(Data');
    Sampled_data_new = [];

    while pc_size > sample_size
        pc_sampled = pcdownsample(pc,'gridAverage',block_size);
        Sampled_data = Sampled_data_new;
        Sampled_data_new = pc_sampled.Location';
        pc_size = size(Sampled_data_new, 2);
        block_size = block_size + block_size_step;
    end
    block_size
    size(Sampled_data)
end

