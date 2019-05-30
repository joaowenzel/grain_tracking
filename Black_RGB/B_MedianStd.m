function [velX,velY,velX_mean,velY_mean,StdVelX,StdVelY,STDVELXY,distanceXY_mean,velocityXY_mean,VELOCITYXY_mean,velX2_mean,velY2_mean] = B_MedianStd(distX2_mean,distY2_mean,DISTXY2_mean,distX,distY,DISTXY,frequency,step) 

    distanceXY_mean(:,:,1) = distX2_mean.^2;
    distanceXY_mean(:,:,2) = distY2_mean.^2;
    distanceXY_mean = sum(distanceXY_mean(:,:,:),3,'omitnan');
    distanceXY_mean = sqrt(distanceXY_mean);     
    distanceXY_mean(distanceXY_mean==0) = nan;
    
    velocityXY_mean = (distanceXY_mean*frequency)/step;  % mm/s    
    VELOCITYXY_mean = (DISTXY2_mean*frequency)/step;     % mm/s
        
    velX = (distX*frequency)/step;                       % mm/s
    velY = (distY*frequency)/step;                       % mm/s
    VELXY = (DISTXY*frequency)/step;                     % mm/s

    velX_mean = mean(velX(:,:,:),3,'omitnan');
    velY_mean = mean(velY(:,:,:),3,'omitnan');
    
    velX2_mean = (distX2_mean*frequency)/step;           % mm/s
    velY2_mean = (distY2_mean*frequency)/step;           % mm/s
    
    % velX_mean, velY_mean and VELXY_mean are the spatial (inside
    % each element of mesh) and temporal (through all images) mean of the
    % grains velocities in x, y, and xy-directions respectively.
   
    % velX2_mean, velY2_mean and VELOCITYXY_mean are the filtered results
  
    % STANDART DEVIATIONS
    StdVelX = std(velX,[],3,'omitnan');   % Standart deviation of velX
    StdVelY = std(velY,[],3,'omitnan');   % Standart deviation of velY     
    STDVELXY = std(VELXY,[],3,'omitnan'); % Standart deviation of VELXY  
end
