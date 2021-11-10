function [hair_id, Pprs1] = trichrome(image, bw_label, intervein_id, thresh )
    hair_id = [];
    dummy_image(:,:) = image(:,:,1);
    dummy_image(bw_label ~= intervein_id) = 0;
    Pprs1 = dummy_image;
    A = dummy_image;
    x = 0:size(Pprs1,2)-1;
    y = 0:size(Pprs1,1)-1;
    [X,Y] = meshgrid(x,y); 
    [m n] = size(Pprs1);
    k = 1;
    for i = 3:m-2
        for j = 3:n-2
            if (A(i,j) ~= 0)
                list_neighbors = [A(i,j) A(i-1,j) A(i-2,j) A(i+1,j) A(i+2,j) A(i,j+1) A(i,j+2) A(i,j-1) A(i,j-2) A(i-1,j+1) A(i-1,j+2) A(i-1,j-1) A(i-1,j-2) A(i-2,j+1) A(i-2,j+2) A(i-2,j-1) A(i-2,j-2) A(i+1,j+1) A(i+1,j+2) A(i+1,j-1) A(i+1,j-2) A(i+2,j+1) A(i+2,j+2) A(i+2,j-1) A(i+2,j-2)];
                min_val = min(list_neighbors);
                    if A(i,j) == min_val
                        hair_id(k,1) = i;
                        hair_id(k,2) = j;
                        k = k + 1;
                    end
            end
        end
    end
    counter_n = 1;

    for i = 1:k-1
        for j = 1:k-1
            dis = ((hair_id(i,1) - hair_id(j,1))^2 + (hair_id(i,2) - hair_id(j,2))^2)^0.5;
            if dis <= thresh && i~=j 
                outliers(counter_n,1) = i;
                outliers(counter_n,2) = j;
                counter_n = counter_n + 1;
            end
        end
    end
    
   existentialCrisis = exist('outliers');
 
   if (existentialCrisis == 1)
        [ma na] = size(outliers);
        outliers_vectorized(1:ma) =  outliers(1:ma,1);
        outliers_vectorized(ma+1:2*ma) =  outliers(1:ma,2);
        outliers_vectorized = sort(outliers_vectorized);
        counter_p = 1;
        for i = 1:ma/2
            removal(counter_p) = outliers_vectorized(4*i);
            counter_p = counter_p  + 1 ;
        end
        hair_id(removal,:) = [];    
   end
 
end
             