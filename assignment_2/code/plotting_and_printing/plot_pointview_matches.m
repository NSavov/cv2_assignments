
function plot_pointview_matches(pointview, pointview_mask, selected_frame)

    img_names = get_image_names_from_directory('data/', 'png');
    im1 = imread(img_names{selected_frame});
    im2 = imread(img_names{selected_frame+1});
    im3 = imread(img_names{selected_frame+2});

    pointview_filtered = pointview_mask(selected_frame:selected_frame+2, any(pointview_mask(selected_frame:selected_frame+2,:))>0);
    points = pointview(2*(selected_frame-1)+1:2*(selected_frame+2), any(pointview_mask(selected_frame:selected_frame+2,:))>0);

    % points2 = tracked_descriptors(2*(selected_frame-1)+1:2*(selected_frame+1), all(pointview(selected_frame+1:selected_frame+2,:))>0);
    points = points(:, 1:8:end);
    pointview_filtered = pointview_filtered(:, 1:8:end);


    imagesc(0, 0, im1)
    hold on
    imagesc(size(im1, 2), 0, im2)
    hold on
    imagesc(size(im1, 2)+size(im2, 2), 0, im3)
    colormap(gray)


    axis tight
    for td_ind = 1:size(points, 2)
        point = points(1:4, td_ind);
        point2 = points(3:6, td_ind);
        hold on
        set(gca,'YDir','Reverse')
        if all(pointview_filtered(1:2,td_ind)) == 1
            x= [point(1), (size(im1, 2)+point(3))];
            y=[point(2), (point(4))];
            plot(x, y, 'g*')
            set(gca,'YDir','Reverse')
            plot(x, y, 'r')
        end

        set(gca,'YDir','Reverse')
        if all(pointview_filtered(2:3,td_ind)) == 1
            x= [ (size(im1, 2)+point2(1)) (size(im1, 2)+size(im2, 2)+point2(3))];
            y=[point2(2) point2(4)];
            plot(x, y, 'g*')
            set(gca,'YDir','Reverse')
            plot(x, y, 'b')
        end
    end
end