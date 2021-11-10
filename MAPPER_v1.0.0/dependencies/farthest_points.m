
function [xLeft,yLeft,xRight,yRight] = farthest_points(binaryImage,optionAllign)



labeledImage = bwlabel(binaryImage);
% Measure the area
measurements = regionprops(labeledImage, 'Area');

% bwboundaries() returns a cell array, where each cell contains the row/column coordinates for an object in the image.
% Plot the borders of all the coins on the original grayscale image using the coordinates returned by bwboundaries.
boundaries = bwboundaries(binaryImage);
numberOfBoundaries = 1;
for blobIndex = 1 : numberOfBoundaries
	thisBoundary = boundaries{blobIndex};
	x = thisBoundary(:, 2); % x = columns.
	y = thisBoundary(:, 1); % y = rows.
	
	% Find which two bounary points are farthest from each other.
	maxDistance = -inf;
	for k = 1 : length(x)
		distances = sqrt( (x(k) - x) .^ 2 + (y(k) - y) .^ 2 );
		[thisMaxDistance, indexOfMaxDistance] = max(distances);
		if thisMaxDistance > maxDistance
			maxDistance = thisMaxDistance;
			index1 = k;
			index2 = indexOfMaxDistance;
		end
	end
	
	% Find the midpoint of the line.
    x_1 = x(index1);
    x_2 = x(index2);
    y_1 = y(index1);
    y_2 = y(index2);
    
    if optionAllign == 1
        if x_1 < x_2
            xLeft = x_1;
            yLeft = y_1;
            xRight = x_2;
            yRight = y_2;
        else
            xLeft = x_2;
            yLeft = y_2;
            xRight = x_1;
            yRight = y_1;
        end
    else
        xLeft = x_1;
        yLeft = y_1;
        xRight = x_2;
        yRight = y_2;
    end
	
    
    
	xMidPoint = mean([x(index1), x(index2)]);
	yMidPoint = mean([y(index1), y(index2)]);
	
end

