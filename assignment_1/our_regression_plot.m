function [] our_regression_plot( fig_handle, x)
%OUR_PLOT Summary of this function goes here
%   Detailed explanation goes here
    global param_is_plotting
    if param_is_plotting
        if fig_handle = [] 
           plot 
        end
        set(fig_handle, 'XData', x)
        set(fig_handle, 'YData', 1:length(x))
        refreshdata
        drawnow
    end
    
end

