
function [veinPositions] = veinNormal(bw_label)

    % L1-L2 vein
    dummy1 = bw_label;
    [m n] = size(dummy1);
    for i = 1:m
        for j = 1:n
            if dummy1(i,j) == 1 || dummy1(i,j) == 2
                dummy1(i,j) = 1;
            else
                dummy1(i,j) = 0;
            end
        end
    end

    se = strel('disk', 14);
    dummy2 = imdilate(dummy1,se);
    dummy3 = imerode(dummy2,se);
    vein1 = imsubtract(dummy3,dummy1);
    vein1 = im2bw(vein1);
    vein1 = bwareafilt(vein1,1);

    % L2 L3 vein

    dummy1 = bw_label;
    [m n] = size(dummy1);
    for i = 1:m
        for j = 1:n
            if dummy1(i,j) == 3 || dummy1(i,j) == 4
                dummy1(i,j) = 1;
            else
                dummy1(i,j) = 0;
            end
        end
    end

    se = strel('disk', 14);
    dummy2 = imdilate(dummy1,se);
    dummy56 = imerode(dummy2,se);

    dummy1 = bw_label;
    for i = 1:m
        for j = 1:n
            if dummy56(i,j) ~= 0 || dummy1(i,j) == 2
                dummy1(i,j) = 1;
            else
                dummy1(i,j) = 0;
            end
        end
    end

    dummy2 = imdilate(dummy1,se);
    dummy3 = imerode(dummy2,se);
    vein2 = imsubtract(dummy3,dummy1);
    vein2 = im2bw(vein2);
    vein2 = bwareafilt(vein2,1);


    % L3 L4 vein

    dummy1 = bw_label;
    [m n] = size(dummy1);
    for i = 1:m
        for j = 1:n
            if dummy1(i,j) == 3 || dummy1(i,j) == 4
                dummy1(i,j) = 1;
            else
                dummy1(i,j) = 0;
            end
        end
    end
    dummy2 = imdilate(dummy1,se);
    dummy3 = imerode(dummy2,se);
    join1 = dummy3;

    dummy1 = bw_label;
    [m n] = size(dummy1);
    for i = 1:m
        for j = 1:n
            if dummy1(i,j) == 5 || dummy1(i,j) == 6
                dummy1(i,j) = 1;
            else
                dummy1(i,j) = 0;
            end
        end
    end
    dummy2 = imdilate(dummy1,se);
    dummy3 = imerode(dummy2,se);
    join2 = dummy3;

    join = join1|join2;
    dummy2 = imdilate(join,se);
    dummy3 = imerode(dummy2,se);
    vein3 = imsubtract(dummy3,join);
    vein3 = im2bw(vein3);
    vein3 = bwareafilt(vein3,1);



    % L4 L5 vein
    dummy1 = bw_label;
    [m n] = size(dummy1);
    for i = 1:m
        for j = 1:n
            if dummy1(i,j) == 5 || dummy1(i,j) == 6
                dummy1(i,j) = 1;
            else
                dummy1(i,j) = 0;
            end
        end
    end

    se = strel('disk', 14);
    dummy2 = imdilate(dummy1,se);
    dummy56 = imerode(dummy2,se);

    dummy1 = bw_label;
    for i = 1:m
        for j = 1:n
            if dummy56(i,j) ~= 0 || dummy1(i,j) == 7
                dummy1(i,j) = 1;
            else
                dummy1(i,j) = 0;
            end
        end
    end

    dummy2 = imdilate(dummy1,se);
    dummy3 = imerode(dummy2,se);
    vein4 = imsubtract(dummy3,dummy1);
    vein4 = im2bw(vein4);
    vein4 = bwareafilt(vein4,1);

    %svein1
    dummy1 = bw_label;
    [m n] = size(dummy1);
    for i = 1:m
        for j = 1:n
            if dummy1(i,j) == 3 || dummy1(i,j) == 4
                dummy1(i,j) = 1;
            else
                dummy1(i,j) = 0;
            end
        end
    end

    se = strel('disk', 14);
    dummy2 = imdilate(dummy1,se);
    dummy3 = imerode(dummy2,se);
    vein5 = imsubtract(dummy3,dummy1);
    vein5 = im2bw(vein5);
    vein5 = bwareafilt(vein5,1);


    %svein2
    dummy1 = bw_label;
    [m n] = size(dummy1);
    for i = 1:m
        for j = 1:n
            if dummy1(i,j) == 5 || dummy1(i,j) == 6
                dummy1(i,j) = 1;
            else
                dummy1(i,j) = 0;
            end
        end
    end

    se = strel('disk', 14);
    dummy2 = imdilate(dummy1,se);
    dummy3 = imerode(dummy2,se);
    vein6 = imsubtract(dummy3,dummy1);
    vein6 = im2bw(vein6);
    vein6 = bwareafilt(vein6,1);

    [vPos(1,1),vPos(1,2),vPos(1,3),vPos(1,4)] = farthest_points(vein1,1);
    [vPos(2,1),vPos(2,2),vPos(2,3),vPos(2,4)] = farthest_points(vein2,1);
    [vPos(3,1),vPos(3,2),vPos(3,3),vPos(3,4)] = farthest_points(vein3,1);
    [vPos(4,1),vPos(4,2),vPos(4,3),vPos(4,4)] = farthest_points(vein4,1);
    [vPos(5,1),vPos(5,2),vPos(5,3),vPos(5,4)] = farthest_points(vein5,0);
    [vPos(6,1),vPos(6,2),vPos(6,3),vPos(6,4)] = farthest_points(vein6,0);
    
    veinPositions = vPos;
end