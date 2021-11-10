%evaluating elliptic fourier shape descriptors for quantifying shapes



function [rFSDs] = efdCoeffWing(bw_img, numHarmonics)

    se = strel('disk', 10);
    bw_img = imdilate(bw_img,se);
    bw_img = imfill(bw_img,'holes');    
    bw_img = imerode(bw_img,se);

    B = bwboundaries(bw_img)
    [dummyVar temp] = size(B);
    if ( dummyVar == 0)
        rFSDs = zeros(4,20);
    else
        boundaryPoints = B{1};
        boundaryPoints= boundaryPoints - mean(boundaryPoints);
        rFSDs = fEfourier(boundaryPoints, numHarmonics, 1, 1);
    end

end





    
    