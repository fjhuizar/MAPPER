% Input arguewmwnts:
%   label: image segmentation mask
% Output arguements:
%   arbitrary labelled intervein regions

function [bw_label] = interveinMorphFilter(label, sizeFilter)
    % relabelling segmentation mask so as to have two components intervein and
    % vein
    label(label == 3) = 2;
    label(label == 4) = 2;
    % Binarizing the label matrix : double to binary or logical
    rgb_img = label2rgb(label);
    bw_img = im2bw(rgb_img);
    bw_img = imcomplement(bw_img);
    bw_img = imclearborder(bw_img);
    % area filter to filter out noisy or non wing debris
    bw_img = bwareafilt(bw_img,7);
    % Morphometric processing for smoothing out the wing blade marin
    bw_img = imfill(bw_img,'holes');
    se = strel('disk', sizeFilter);
    bw_img = imerode(bw_img,se);
    bw_img = imfill(bw_img,'holes');
    bw_img = bwareafilt(bw_img,7);
    bw_img = imdilate(bw_img,se);
    % Converting the binary mask to labellde image with each intervein
    % labelled differently
    bw_label = bwlabel(bw_img);

end



