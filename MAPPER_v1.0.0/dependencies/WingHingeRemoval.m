%% Removing hinge from Drosophila wings

%% Reading in the folder containing input images (!!Don't forget to change the directory address!!)

if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
  uiwait(warndlg(errorMessage));
  return;
end
%% Making a database of all the '.tif' images inside the input folder
filePattern = fullfile(myFolder, '*.tif');
pngFiles = dir(filePattern);
imagename = strings(length(pngFiles));
intervenalareasum = zeros(length(pngFiles));
mkdir(myFolder,'croppedWings');

%% Looping across individual files
for k = 1:length(pngFiles)
%% Loading individual file from the database  
baseFileName = pngFiles(k).name;
fullFileName = fullfile(myFolder, baseFileName);
fprintf(1, 'Now reading %s\n', fullFileName);
testcase = imread(fullFileName);    
I = testcase; 

%% Cropping out the hinge using roipoly command
BW = roipoly(I);
[m n o] = size(I);

if o == 3
    
    for i = 1:m
        for j = 1:n
            if BW(i,j) == 1
                I(i,j,1) = 240;
                I(i,j,2) = 240;
                I(i,j,3) = 240;
            end
        end
    end

else
    for i = 1:m
        for j = 1:n
            if BW(i,j) == 1
                I(i,j,1) = 240;
            end
        end
    end
    
end
    
%% Writing the image
if o == 3
%     J = imadjust(rgb2gray((I)));
      J = I;
else
    J = imadjust(I);
end

baseFileName = baseFileName(1:end-4);
baseFileName = strcat(baseFileName,'.TIF');
FILENAME = strcat(myFolder, '\croppedWings\', baseFileName);
imwrite(J,FILENAME);
end
close;

%% End of code


