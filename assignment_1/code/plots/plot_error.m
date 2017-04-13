function [fig] = plot_error(x, fig, f_name)
%OUR_PLOT Summary of this function goes here
%   Detailed explanation goes here
    global param_is_plotting
    global param_is_testing_stability
    global param_is_timing
    global param_is_testing_tolerance
    
    if isempty(param_is_plotting)
        param_is_plotting = false;
    end
    
    if param_is_plotting && ~(param_is_timing || param_is_testing_tolerance || param_is_testing_stability)
        if isempty(fig)
           fig(2) = figure;
           fig(1) = plot(x);
        end
        set(fig(1), 'XData', 1:length(x));
        set(fig(1), 'YData', x);
        xlabel('Iteration')
        ylabel('RMS error')
        refreshdata;
        drawnow;
        if nargin < 3 
            f_name = []; 
        end
        if ~isempty(f_name)
            f_name = strcat(upper(f_name(1:1)), f_name(2:end)); 
            title(strrep(f_name,'_',' '))
            saveas(fig(2), strcat('plots/', f_name));
            print(fig(2), '-dpdf', strcat('plots/', f_name, '_error', num2str(round(x(end), 3)), '.pdf'));
        end
    end
end

