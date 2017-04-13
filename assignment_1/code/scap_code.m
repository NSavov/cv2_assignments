% compare two pointclouds
Source_pc_object = pointCloud(Source_pc(1:3, :)');
Target_pc_object = pointCloud(Target_pc(1:3, :)');
pcshowpair(Source_pc_object,Target_pc_object)
