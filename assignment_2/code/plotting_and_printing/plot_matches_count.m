function plot_matches_count( match_count )
%PLOT_MATCHES_COUNT Summary of this function goes here
%   Detailed explanation goes here
    figure
    plot(1:size(match_count,2),match_count)
    hold on;
    mean_line = 1:size(match_count,2);
    mean_line(:) = mean(match_count);
    plot(1:size(match_count,2), mean_line)
end

