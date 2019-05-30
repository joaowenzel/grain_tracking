clc; 
close all; 
warning('off', 'Images:initSize:adjustingMag');
%***********************************************************************************************
frequency_T3 = 200;         % Frequency of image acquisition
n_T3 = 1;                   % Initial image
nf_T3 = 6000;               % Final image
threshold_T3 = 12000;       % Threshold to differentiate the grains and the bottom wall of the channel
arealim_T3 = [13 150];      % Determine the lower and upper bound of area of each grain (Pixels)
MD2SF_T3 = 75.8684;         % Maximum distance to search for the same grain in the next image (Pixels)
MinTS_T3 = 143.3858;        % Minimal tracking size to consider in lagrangian (Pixels)
deltaY_T3 = 2;              % deltaY & speedY are used to determine and filter the tracking,in order to get just the time when the particle is in movement...
speedY_T3 = 0.6;            % disregarding the time in which it remains stopped
height = 1637;              % Image height (Pixels)
width = 1208;               % Image width (Pixels)
step_T3 = 1;                % Here is possible to choose the gap between the images. Ex. if step == 1: image n°1->n°2; n°2->n°3; n°3->n°4... if step == 2: image n°1->n°3; n°2->n°4; n°3->n°5 ans so on...         
mesh_T3 = 35.5823;          % Determine the mesh size that will be generated on the image
median2cut_T3 = 2;          % Used in filter, if the element of the mesh has lees than "menEleXY"(amount of images that has valid movement in each element of mesh) times "minEl2verify"(given in %) elements,                             
MinEl2VrPercent_T3 = 27;    % the filter calculates the median value arround this element, and if it's value is greater than "median2cut" times the median value it is replaced by the median value
P2MM = 0.0697613803230543;   % Pixel to milimeter conversion factor
%***********************************************************************************************
allposXY_T3{4,nf_T3-(n_T3-1)} = [];
time_img_T3 = 1/frequency_T3; 
lst = dir('*.tif');

for m = n_T3:nf_T3
    clf
    time_T3 = (m-1)*time_img_T3;
    Iname = lst(m);
    I = imread([Iname.name]);
    [meanduneXY,meanLimit,inverter] = N_Limit_Inverter(m,step_T3,lst);  % This function reverses the image to make the tracers white
    [pos,props,Area] = N_TracerIdentifier(inverter,threshold_T3,arealim_T3);
    posx = pos(:,1);
    posy = pos(:,2);
    allposXY_T3{1,m} = posx;       % Position on the x-axis of each tracer grain detected in the image
    allposXY_T3{2,m} = posy;       % Position on the y-axis of each tracer grain detected in the image
    allposXY_T3{3,m} = meanLimit;  % Central point of dune slip face (Mean value between the current image and the next one)
    allposXY_T3{4,m} = Area;       % Area of each tracer grain detected in the image
    allposXY_T3{5,m} = meanduneXY; % Position in x and y-axis of dune's centroid (Mean value between the current image and the next one)
    subplot(1,2,1)        
    imshow(I)    
    title([' Raw Image ',num2str(m),' of ',num2str(nf_T3)])
    subplot(1,2,2)
    imshow(inverter)
    title(['Processed Image ',num2str(m),' of ',num2str(nf_T3)])
    hold on
    plot(posx,posy,'ro')
    pause(0.001)
end

% A brief explanation of the following functions can be found inside of them.

% Eulerian *************************************************************************************

[pair_T3] = N_Pair(allposXY_T3,MD2SF_T3,frequency_T3,P2MM); 
                                                                
[distX_T3,distY_T3,DISTXY_T3] = N_MedianMesh(pair_T3,n_T3,nf_T3,step_T3,mesh_T3,width,height,P2MM,allposXY_T3);  % Note: the X, Y and XY distance change with the chosen step. But the velocities do not change (The step is considered in the calculus) 

[distX_mean_T3,distY_mean_T3,DISTXxY_mean_T3,distX2_mean_T3,distY2_mean_T3,DISTXY2_mean_T3,changeXYpercent_T3] = N_Filter(distX_T3,distY_T3,DISTXY_T3,median2cut_T3,MinEl2VrPercent_T3);

[velX_T3,velY_T3,velX_mean_T3,velY_mean_T3,StdVelX_T3,StdVelY_T3,STDVELXY_T3,distanceXY_mean_T3,velocityXY_mean_T3,VELOCITYXY_mean_T3,velX2_mean_T3,velY2_mean_T3] = N_MedianStd(distX2_mean_T3,distY2_mean_T3,DISTXY2_mean_T3,distX_T3,distY_T3,DISTXY_T3,frequency_T3,step_T3);    
 
[velMeanOrderX_T3,velMeanOrderY_T3,StdVelOrderX_T3,StdVelOrderY_T3,velXYmeanOrder_T3,VELXYmeanOrder_T3,STDVELXYOrder_T3,NewLabel,Spi] = N_Spiral(mesh_T3,velX_mean_T3,velY_mean_T3,StdVelX_T3,StdVelY_T3,velocityXY_mean_T3,VELOCITYXY_mean_T3,STDVELXY_T3,P2MM);

[EulerSpiNaN_T3,EulerSpi_T3,EulerNaN_T3,Euler_T3] = N_EulerianData(velMeanOrderX_T3,velMeanOrderY_T3,StdVelOrderX_T3,StdVelOrderY_T3,velXYmeanOrder_T3,VELXYmeanOrder_T3,STDVELXYOrder_T3,NewLabel,distX2_mean_T3,Spi);

[anglesBoxes_T3,distBoxes_T3] = N_HistAndPolarHist(EulerSpi_T3); 

N_FiguresAndPlots(velocityXY_mean_T3,velX2_mean_T3,velY2_mean_T3,height,width,anglesBoxes_T3,distBoxes_T3);

% Lagrangian ************************************************************************************
 
[lagrangian_T3,lagrangianlong_T3,LargestTracking_T3,usefullagrangian_T3,lag12plus_T3,LgrNofMov_T3,tracklist_T3,lagrangiandata_T3] = N_Lagrangian(pair_T3,MinTS_T3,deltaY_T3,speedY_T3,frequency_T3,P2MM);
 
