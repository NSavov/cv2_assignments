s = matfile('pointview_t1.mat');
pointview = s.pointview;
tracked_descriptors = s.tracked_descriptors;

selected_frame = 5;

img_names = get_image_names_from_directory('data/', 'png');
im1 = imread(img_names{selected_frame});
im2 = imread(img_names{selected_frame+1});


points = tracked_descriptors(2*(selected_frame-1)+1:2*(selected_frame+1), all(pointview(selected_frame:selected_frame+1,:))>0);
size(points)


imagesc(0, 0, im1)
hold on
imagesc(size(im1, 2), 0, im2)
colormap(gray)

axis tight
for td_ind = 1:size(points, 2)
    point = points(1:4, td_ind);
%     subplot(1,2,1)
    hold on
    set(gca,'YDir','Reverse')
    
    x= [point(1), (size(im1, 2)+point(3))];
    y=[point(2), (point(4))];
    plot(x, y, 'r')
    
%     subplot(1,2,2)
%     imshow(im2)
%     hold on
%     set(gca,'YDir','Reverse')
% %     ylim([0 size(image, 1)])
%     plot(point(3), point(4), 'r*')
%     pause
end