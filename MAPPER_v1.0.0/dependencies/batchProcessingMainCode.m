%% MAPPER Quantitative analysis (Batch processing)
%% Preparing workspace
clear all;
clc;
workspace;  
format long g;
format compact;
addpath('dependencies')

%% Parameter definition

morphFilterSizeIntervein = 5;
morphFilterSizwWing = 8;
thresholdTrichome = 2;
numHarmonics = 20;

%% Geeting user define path for the folders containing the wing images to be analyzed
start_path = fullfile(matlabroot, 'C:\Users\Nilay\Desktop\AutomatedWingAnalysis\GPCR\Galphasubunits');
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
	return;
end
allSubFolders = genpath(topLevelFolder);
remain = allSubFolders;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames)

%% Looping through each folder and associated wing images for feature extraction

wingAnalysisCounter = 1;
folderAnalysisCounter = 1;

% looping through the folders containing wing images
for k = 1 : numberOfFolders
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
 	filePattern = sprintf('%s/*.tif', thisFolder);
    baseFileNames = dir(filePattern);
   	numberOfImageFiles = length(baseFileNames);
 	if numberOfImageFiles >= 1       
        % looping through each file present in an individual folder
 		for f = 1 : numberOfImageFiles
 			fullFileName = fullfile(thisFolder, baseFileNames(f).name);
            [filepath,name,ext] = fileparts(fullFileName);
            
            % Getting the file name without the extension
            fullFileName2 = fullFileName(1:end-4);
            
            % Creating filenames for the segmentation mask
            fullFileNameMask = strcat(fullFileName2,'_Simple Segmentation.png');
            
            % Creating filenames for the labelled interveins
            fullFileNameLabel = strcat(fullFileName2,'_Label.jpg');
            
            % Reading in the images and corresponding segmentation masks
            rawImage = imread(fullFileName);
            segmentationMask = imread(fullFileNameMask);
            
            % Morphometric filter for filtering the interveins
            [bwLabelIntervein] = interveinMorphFilter(segmentationMask, morphFilterSizeIntervein);
            
            % Morphometric filter for extracting the global wing shape
            [bwWing, bwLabelWing] = wingMorphFilter(segmentationMask, morphFilterSizwWing);
            
            % Classifying the interveins
            dummyLabel = [];
            dummyLabel = bwLabelIntervein;
            yfit = [];
            [bwLabelNew, yfit] = classificationInterveinGeometric(dummyLabel);
            
            % Printing the labelled intervein areas as a file
            imwrite(label2rgb(bwLabelNew),fullFileNameLabel);
            
            % Storing the filenames and genotypes of each individual wing
            filesName{wingAnalysisCounter} = strcat(name);
            folderName(wingAnalysisCounter) = folderAnalysisCounter;
            
            % Area and trichome numbers of individual intervein regions
            areaIntervein = [];
            trichomeIntervein = [];
            hairSpace = [];
            [areaIntervein, trichomeIntervein, hairSpace] = statsAreaTrichome(rawImage, bwLabelIntervein, thresholdTrichome);
            statsAreaIntervein(wingAnalysisCounter,1:10) = 0;
            statsTrichomeIntervein(wingAnalysisCounter,1:10) = 0;
            for i = 1:max(max(bwLabelIntervein))
                statsAreaIntervein(wingAnalysisCounter,yfit(i)) = areaIntervein(i);
            end
            for i = 1:max(max(bwLabelIntervein))
                statsTrichomeIntervein(wingAnalysisCounter,yfit(i)) = trichomeIntervein(i);
            end
            
            % Global statistics of wing
            statsCompleteWing = [];
            statsCompleteWing = regionprops(bwWing,'Area');
            statswingBladeArea(wingAnalysisCounter) = cat(1,statsCompleteWing.Area);
            statstrichomeDensityWing(wingAnalysisCounter) = sum(trichomeIntervein) / sum(areaIntervein);
            
            % Extracting elliptic fourier descriptor  coefficients 
            EFDCoefficients{wingAnalysisCounter} = efdCoeffWing(bwWing, numHarmonics);
            statsEFDReshaped(wingAnalysisCounter,:) = reshape(EFDCoefficients{wingAnalysisCounter},[1 numHarmonics*4]);

            
            % Extracting AP, PD nad d(L3,L4) for normal looking wings
            yfitReshaped = [];
            yfitReshaped = reshape(yfit,[1,length(yfit)]);
            checkArray = [1,2,3,4,5,6,7];
            if isequal(sort(yfitReshaped), checkArray) == 1
                veinPositions = [];
                % Extracting vein position
                [veinPositions] = veinNormal(bwLabelNew);
                % Extract intervein 3 centroid for identication of distal
                % and proximal end of veins
                centroidLabelStr = [];
                centroidLabel = [];
                centroidLabelStr = regionprops(bwLabelNew,'centroid');
                centroidLabel = cat(1,centroidLabelStr.Centroid);
                centroidI3 = centroidLabel(3,:);
                
                % calculating AP distance
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
                lengthAP(wingAnalysisCounter) = norm(L2PointAP-L5PointAP);
               
                
                % calculating distance between L3 and L4          
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
                lengthL3L4(wingAnalysisCounter) = norm(L3PointRight - L4PointRight);
                
                % calculating PD distance                
                L3L4PointsRight = vertcat(L3PointRight,L4PointRight);
                L3L4PointsLeft = vertcat(L3PointLeft,L4PointLeft);
                lengthPD(wingAnalysisCounter) = norm( (mean(L3L4PointsRight)) - (mean(L3L4PointsLeft)));
            else
                lengthAP(wingAnalysisCounter) = 0;
                lengthPD(wingAnalysisCounter) = 0;
                lengthL3L4(wingAnalysisCounter) = 0;
            end
            
            % increaing the counter of processing wing image files
            wingAnalysisCounter = wingAnalysisCounter+1;
            fprintf('Processing image file %s\n', fullFileName);
 		end
 	else
 		fprintf('     Folder %s has no image files in it.\n', thisFolder);
    end
    folderAnalysisCounter = folderAnalysisCounter + 1;
end

% Creating table with all the features
varNames = {'Wing name','Genotype','Intervein area','Trichome density Intervein','Wing area', 'Total Trichome density','AP axis', 'PD axis', 'd(L3-L4)'};
T = table(filesName',folderName',statsAreaIntervein,statsTrichomeIntervein,statswingBladeArea',statstrichomeDensityWing',lengthAP',lengthPD' , lengthL3L4','VariableNames',varNames);

% printic area statistics for different genotypes

for i = 2:max(folderName)
    dummyGenotypeArea = [];
    dummyCounter = 1;
    for j = 1:length(folderName)
        if folderName(j) == i
            dummyGenotypeArea(dummyCounter) =  statswingBladeArea(j);
            dummyCounter = dummyCounter + 1;
        end
    end
    areaGenotype(i-1) = mean(dummyGenotypeArea) 
end

bar(areaGenotype)


