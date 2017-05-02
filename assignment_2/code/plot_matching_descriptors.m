function plot_matching_descriptors( Ia, Ib, matches, fa, fb, fig_name)
    figure('name', fig_name); clf ;
    imshow(cat(2, Ia, Ib)) ;
    % to not reinvent the wheel, this code came from demo code from the 
    % vl_demo_sift_match.m from toolbox/demo folder in VLFeat package.
    % http://www.vlfeat.org/matlab/demo/vl_demo_sift_match.html
    max(matches(1,:))
    size(fa)
    xa = fa(1,matches(1,:)) ;
    xb = fb(1,matches(2,:)) + size(Ia,2) ;
    ya = fa(2,matches(1,:)) ;
    yb = fb(2,matches(2,:)) ;

    hold on ;
    h = line([xa ; xb], [ya ; yb]) ;
    set(h,'linewidth', 1, 'color', 'b') ;

    vl_plotframe(fa(:,matches(1,:))) ;
    fb(1,:) = fb(1,:) + size(Ia,2) ;
    vl_plotframe(fb(:,matches(2,:))) ;
    axis image off ;
    print(fig_name,'-depsc')
    pause
    close all
end

