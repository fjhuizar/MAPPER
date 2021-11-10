% Input arguewmwnts:
%   label: image segmentation mask
% Output arguements:
%   bw_img: binary image separating the whole wing blade from background
%   bw_label: label matrix having 1 for the wing and 2 for the background

function [bw_img, bw_label] = wingMorphFilter2( label, sizeFilter)
    % Combine the veins and inyterveins as a single label
    label(label == 2) = 1;
    label(label == 3) = 2;
    label(label == 4) = 2;
    % binarize the label matrix so as to obtain a binary mask for the whole
    % wing
    rgb_img = label2rgb(label);
    bw_img = im2bw(rgb_img);
    bw_img = imcomplement(bw_img);
    % Morphological operations to smoothen out the wing boundaries
    bw_img = bwareafilt(bw_img,5);
    bw_img = imfill(bw_img,'holes');
    se = strel('disk', sizeFilter);
    bw_img = imerode(bw_img,se);
    bw_img = imfill(bw_img,'holes');
    bw_img = bwareafilt(bw_img,1);
    bw_img = imdilate(bw_img,se);
    bw_label = bwlabel(bw_img);

end



