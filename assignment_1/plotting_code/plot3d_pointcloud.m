function plot3d_pointcloud(source, target, f_name)
%OUR_PLOT3D Summary of this function goes here
%   Detailed explanation goes here
    global param_is_plotting
    if param_is_plotting
        sa = source(1,:);
        sb = source(2,:);
        sc = source(3,:);
        ta = target(1,:);
        tb = target(2,:);
        tc = target(3,:);

        gcf = figure;
        plot3(sa,sb,sc);
        hold on;
        plot3(ta,tb,tc);
        hold off;
        if nargin < 3 
            f_name = []; 
        end
        if ~isempty(f_name)
            saveas(gcf, strcat('plots/', f_name)) 
            print(gcf, '-dpdf', strcat('plots/', f_name, '.pdf'))
        end
    end
end

