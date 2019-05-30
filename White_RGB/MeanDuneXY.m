function [meanduneXY] = MeanDuneXY(nimg,step,lst)

        DuneXY = zeros(2,2); 
        meanduneXY = zeros(2,1);
        nn = 1;

    for m = nimg:nimg+step

        threshold = 50;
        Iname = lst(m);
        I = imread([Iname.name]);

        Ig = rgb2gray(I);

        Properties = regionprops(Ig>threshold,Ig,'Area','WeightedCentroid'); 

        Qcentroids = vertcat(Properties(:).WeightedCentroid);
        QArea = vertcat(Properties(:).Area);

        [AreaMax,~] = find(QArea == max(QArea(:,1)));

        Dunex = Qcentroids(AreaMax,1);
        Duney = Qcentroids(AreaMax,2);

        DuneXY(1,nn) = Dunex; % X Position of the centroids of the dunes in the img and img + step
        DuneXY(2,nn) = Duney; % Y Position of the centroids of the dunes in the img and img + step

        nn = nn+1;
    end

    meanduneXY(1,1) = mean(DuneXY(1,:)); % Median of X1 and X2
    meanduneXY(2,1) = mean(DuneXY(2,:)); % Median of Y1 and Y2

end
