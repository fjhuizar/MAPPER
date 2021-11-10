%evaluating elliptic fourier shape descriptors for interveins

function [rFSDsReshaped] = edfcoeffIntervein(bw_img)

B = bwboundaries(bw_img);
[dummyVar temp] = size(B);
for i = 1:dummyVar
    dummyBoundary = [];
    dummyBoundary = B{i};
    [realBoundaryid(i) dummyCol] = size(dummyBoundary);
end

[dummyValues idBoundary] = max(realBoundaryid);


if ( dummyVar == 0)
    rFSDs = zeros(4,20);
else
    boundaryPoints = [];
    boundaryPoints = B{idBoundary};
    boundaryPoints= boundaryPoints - mean(boundaryPoints);
    rFSDs = fEfourierNormalized(boundaryPoints, 20, 1, 1)
    rFSDsReshaped = reshape(rFSDs, [1,80])
end

end





    
    