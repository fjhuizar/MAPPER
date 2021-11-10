%evaluating elliptic fourier shape descriptors for quantifying shapes



function [rFSDsReshaped] = edfcoeff(bw_img)


B = bwboundaries(bw_img);
[dummyVar temp] = size(B);
if ( dummyVar == 0)
    rFSDs = zeros(4,20);
else
    boundaryPoints = B{1};
    boundaryPoints= boundaryPoints - mean(boundaryPoints);
    rFSDs = fEfourier(boundaryPoints, 20, 1, 1)
    rFSDsReshaped = reshape(rFSDs, [1,80])
end


end





    
    