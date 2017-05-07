% Nedko Savov (11404345), Joop Pascha (10090614)
% Date: 24/04/2017

function plot3d_pointcloud(source, target, f_name)
%OUR_PLOT3D Summary of this function goes here
%   Detailed explanation goes here
    global param_is_plotting
    global param_is_testing_stability
    global param_is_timing
    global param_is_testing_tolerance
    global is_testing 
    
    if isempty(param_is_plotting)
        param_is_plotting = false;
    end
    
    if param_is_plotting && ~(param_is_timing || param_is_testing_tolerance || param_is_testing_stability)
        f_name = strcat(upper(f_name(1:1)), f_name(2:end));
        if is_testing
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

            title(strrep(f_name,'_',' '))
            xlabel('x')
            ylabel('y')
            if nargin < 3 
                f_name = []; 
            end
            if ~isempty(f_name)
                saveas(gcf, strcat('plots/', f_name)) 
                print(gcf, '-dpdf', strcat('plots/', f_name, '.pdf'))
            end
        else
            gcf = figure;
            title(strrep(f_name,'_',' '))
            xlabel('x')
            ylabel('y')
            Source_pc_object = pointCloud(source');
            Target_pc_object = pointCloud(target');
            pcshowpair(Source_pc_object,Target_pc_object)
            if nargin < 3 
                f_name = []; 
            end
            if ~isempty(f_name)
                saveas(gcf, strcat('plots/', f_name)) 
                print(gcf, '-dpdf', strcat('plots/', f_name, '.pdf'))
            end
        end
    end
end

