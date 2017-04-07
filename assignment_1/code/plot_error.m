function [fig_handle] = our_regression_plot( fig_handle, x)
%OUR_PLOT Summary of this function goes here
%   Detailed explanation goes here
    global param_is_plotting
    if param_is_plotting
        if isempty(fig_handle)
           figure;
           fig_handle = plot(x); 
        end
        set(fig_handle, 'XData', 1:length(x))
        set(fig_handle, 'YData', x)
        refreshdata
        drawnow
    end
    
end

