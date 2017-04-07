function our_plot3d(Source_pc, Target_pc, save_name)
%OUR_PLOT3D Summary of this function goes here
%   Detailed explanation goes here
    size(Source_pc)
    sa = Source_pc(1,:);
    sb = Source_pc(2,:);
    sc = Source_pc(3,:);
    ta = Target_pc(1,:);
    tb = Target_pc(2,:);
    tc = Target_pc(3,:);
    
    figure;
    plot3(sa,sb,sc);
    hold on;
    plot3(ta,tb,tc);
    hold off;
    
end

