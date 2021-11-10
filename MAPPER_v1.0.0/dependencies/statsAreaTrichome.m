%% Extracts area and trichome density of individual intervein compartments
% Input: 
%   img: Raw image data
%   bw_label: labelled intervein region which is an output of the machine
%   learning based classifier
% Output:
%   areaIntervein: area of the intervein regions
%   trichomeIntervein: # of trichomes in the intervein regions

function [areaIntervein, trichomeIntervein, hairSpatialLocation] = statsAreaTrichome(img, bw_label, thresh)
    stats = regionprops(bw_label,'Area');
    hairSpatialLocation = [];
    areaIntervein = cat(1,stats.Area);
    for i = 1:max(max(bw_label))
        hairid = [];
        Pprs = [];
        [hair_id, Pprs] = trichrome(img, bw_label, i, thresh);
        hairSpatialLocation = vertcat(hairSpatialLocation, hair_id);
        [trichomeIntervein(i), n1] = size(hair_id);
    end
end


