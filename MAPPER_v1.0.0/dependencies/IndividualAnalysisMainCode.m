%% MAPPER Quantitative Analysis: Individual Wing Processing
%% Preparing workspace
clear;
clc;
workspace;  
format long g;
format compact;
addpath('dependencies')

%% Parameters
morphFilterSizeIntervein = 5;
morphFilterSizwWing = 8;
thresholdTrichome = 2;
numHarmonics = 2;
windowSizeDensityPlot = 32;
labelName = 'Label.jpg';

%% Reading in raw image and segmentation mask
rawImage = imread('Slide 1 Wing 2 4018.tif');
%segmentationMask = imread(uigetfile);
%rawImage = imread('57151_1_rotated.tif');
segmentationMask = imread('Slide 1 Wing 2 4018_Simple Segmentation.png');

%% Morphological operation to filter the segmentation mask of interveins
% Function details: interveinMorphFilter(arg1, arg2);
% arg1: segmentation mask, arg2: radius of morphological structuring
% element for erosion and dilation
[bwLabelIntervein] = interveinMorphFilter(segmentationMask, morphFilterSizeIntervein);

%% Morphological operation to filter the overall wing blade area
[bwWing, bwLabelWing] = wingMorphFilter(segmentationMask, morphFilterSizwWing);
% Function details: wingMorphFilter(arg1, arg2);
% arg1: segmentation mask, arg2: radius of morphological structuring
% element for erosion and dilation

%% Classification of interveins using the geometrical features
[bwLabelNew, yfit] = classificationInterveinGeometric(bwLabelIntervein);
% Printing the labelled wing image
imwrite(label2rgb(bwLabelNew),labelName)


%% Area of interveins and wing blade area
%[o1, o2, o3] = statsAreaTrichome(i1, i2, i3);
% Output:
% a) o1: area of individual labelled intervein regions
% b) o2: trichomedensity of each individual intervein region
% c) o3: spatial location of each intervein
% Input:
% a) i1: raw image data
% b) i2: labelled interveins 
% c) i3: thresholding filter of individual trichomes
[areaIntervein, trichomeIntervein, hairSpace] = statsAreaTrichome(rawImage, bwLabelNew, thresholdTrichome);
trichomeDensityIntervein = trichomeIntervein' ./ areaIntervein; 

% Plotting heatmap of intervein area
areaLabel = bwLabelNew;
for i = 1: length(yfit)
    areaLabel(areaLabel == yfit(i)) = areaIntervein(yfit(i));
end



figure (1)
imagesc(areaLabel)
colorbar

sortedyfit = sort(yfit);
T = table(sortedyfit,areaIntervein,trichomeIntervein','VariableNames',{'ID','Area','# Trichomes'} );

%% Global statistics of wing (area and trichome density)

statsCompleteWing = regionprops(bwWing,'Area');
wingBladeArea = cat(1,statsCompleteWing.Area);
trichomeDensityWing = sum(trichomeIntervein) / sum(areaIntervein);

%% EFD Coefficients of wing
EFDCoefficientsWing = efdCoeffWing(bwWing, numHarmonics)
outlineWing = rEfourier(EFDCoefficientsWing, numHarmonics,100);
figure()
plot(outlineWing(:,1),outlineWing(:,2))
xlim([-500 500])
ylim([-400 400])

%% Trichome density heat maps
% coarse grained trichome heat map showing trichome density of individual
% intervein regions
trichomeLabel = bwLabelNew;
for i = 1: length(yfit)
    trichomeLabel(trichomeLabel == yfit(i)) = trichomeDensityIntervein(yfit(i));
end

figure (2)
imagesc(trichomeLabel)
colorbar

% a finer heat map of trichome density distribution 
DataDensityPlot(hairSpace(:,2), hairSpace(:,1), windowSizeDensityPlot);

%% Getting coordinate of intervein 3 

centroidLabelStr = regionprops(bwLabelNew,'centroid');
centroidLabel = cat(1,centroidLabelStr.Centroid);
centroidI3 = centroidLabel(3,:);

%% AP axis (Comment about execulting this section for a normal looking wing)

[veinPositions] = veinNormal(bwLabelNew);

% Calculating veinPositions of the L1 and L4 vein for estimating the AP
% axis
L2Points1 = [veinPositions(1,1) veinPositions(1,2)];
L2Points2 = [veinPositions(1,3) veinPositions(1,4)];
L5Points1 = [veinPositions(4,1) veinPositions(4,2)];
L5Points2 = [veinPositions(4,3) veinPositions(4,4)];

if norm(centroidI3 - L2Points1) > norm(centroidI3 - L2Points2)
    L2PointAP = L2Points1;
else
    L2PointAP = L2Points2;
end

if norm(centroidI3 - L5Points1) > norm(centroidI3 - L5Points2)
    L5PointAP = L5Points1;
else
    L5PointAP = L5Points2;
end

APPoints = vertcat(L2PointAP,L5PointAP);

figure(4)
imshow(rawImage)
hold on
plot(APPoints(:,1), APPoints(:,2),'--rs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])

%% d(L3,l4) 

L3Points1 = [veinPositions(2,1) veinPositions(2,2)];
L3Points2 = [veinPositions(2,3) veinPositions(2,4)];
L4Points1 = [veinPositions(3,1) veinPositions(3,2)];
L4Points2 = [veinPositions(3,3) veinPositions(3,4)];


if norm(centroidI3 - L3Points1) > norm(centroidI3 - L3Points2)
    L3PointRight = L3Points1;
    L3PointLeft = L3Points2;
else
    L3PointRight = L3Points2;
    L3PointLeft = L3Points1;
end

if norm(centroidI3 - L4Points1) > norm(centroidI3 - L4Points2)
    L4PointRight = L4Points1;
    L4PointLeft = L4Points2;
else
    L4PointRight = L4Points2;
    L4PointLeft = L4Points1;
end

L3L4PointsRight = vertcat(L3PointRight,L4PointRight);

figure(5)
imshow(rawImage)
hold on
plot(L3L4PointsRight(:,1), L3L4PointsRight(:,2),'--rs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])

%% Proximal distal axis

% L3PointLeft = [veinPositions(2,1) veinPositions(2,2)]; 
% L4PointLeft = [veinPositions(3,1) veinPositions(3,2)];
L3L4PointsLeft = vertcat(L3PointLeft,L4PointLeft);

pointsPD = vertcat(mean(L3L4PointsLeft),mean(L3L4PointsRight));

figure(6)
imshow(rawImage)
hold on
plot(pointsPD(:,1), pointsPD(:,2),'--rs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])







