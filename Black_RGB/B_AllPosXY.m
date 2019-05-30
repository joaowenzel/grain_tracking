close all; 
clc; 
warning('off', 'Images:initSize:adjustingMag');
%***********************************************************************************************
frequency_T2 = 200;         % Frequency of image acquisition
n_T2 = 1;                   % Initial image
nf_T2 = 3000;               % Final image
threshold_T2 = 40;          % Threshold to differentiate the grains and the bottom wall of the channel
arealim_T2 = [10 60];       % Determine the lower and upper bound of area of each grain (Pixels)
MD2SF_T2 = 84.2668;         % Maximum distance to search for the same grain in the next image (Pixels)
MinTS_T2 = 101.44;          % Minimal tracking size to consider in lagrangian (Pixels)
deltaY_T2 = 2;              % deltaY & speedY are used to determine and filter the tracking,in order to get just the time when the particle is in movement...
speedY_T2 = 0.6;            % Disregarding the time in which it remains stopped
height = 1024;              % Image height (Pixels)
width = 800;                % Image width (Pixels)
step_T2 = 1;                % Here is possible to choose the gap between the images. Ex. if step == 1: image n°1->n°2; n°2->n°3; n°3->n°4... if step == 2: image n°1->n°3; n°2->n°4; n°3->n°5 ans so on...         
mesh_T2 = 25;               % Determine the mesh size that will be generated on the image
median2cut_T2 = 2;          % Used in filter, if the element of the mesh has lees than "meanEleXY"(amount of images that has valid movement in each element of mesh) times "minEl2verify"(given in %) elements,                             
MinEl2VrPercent_T2 = 27;    % the filter calculates the median value arround this element, and if it's value is greater than "median2cut" times the median value it is replaced by the median value
P2MM = 0.0992906802568982;   % Pixel to milimeter conversion factor       
%***********************************************************************************************
allposXY_T2{6,nf_T2-(n_T2-1)} = []; 
time_img_T2 = 1/frequency_T2; 
lst = dir('*.tif');

for m = n_T2:nf_T2
    clf
    time_T2 = (m-1)*time_img_T2;
    Iname = lst(m);
    I = imread([Iname.name]);
    [meanduneXY,meanLimit,meanBB,Ig] = B_LimitCentroid(m,step_T2,lst,height,width);
    [pos,props,Area] = B_TracerIdentifier(Ig,threshold_T2,arealim_T2);
    posx = pos(:,1);
    posy = pos(:,2);    
    allposXY_T2{1,m} = posx;       % Position on the x-axis of each tracer grain detected in the image
    allposXY_T2{2,m} = posy;       % Position on the y-axis of each tracer grain detected in the image
    allposXY_T2{3,m} = meanLimit;  % Central point of dune slip face (Mean value between the current image and the next one)
    allposXY_T2{4,m} = Area;       % Area of each tracer grain detected in the image
    allposXY_T2{5,m} = meanduneXY; % Position in x and y-axis of dune's centroid (Mean value between the current image and the next one)
    allposXY_T2{6,m} = meanBB;     % The highest value of the y-axis where the dune is
    subplot(1,2,1)
    imshow(I)    
    title([' Raw Image ',num2str(m),' of ',num2str(nf_T2)])
    subplot(1,2,2)
    imshow(Ig)    
    title(['Processed Image ',num2str(m),' of ',num2str(nf_T2)])
    hold on
    plot(posx,posy,'ro')
    pause(0.001)
end

% A brief explanation of the following functions can be found inside of them.

% Eulerian *************************************************************************************

[pair_T2] = B_Pair(allposXY_T2,MD2SF_T2,frequency_T2,P2MM); 
                                                                
[distX_T2,distY_T2,DISTXY_T2] = B_MedianMesh(pair_T2,n_T2,nf_T2,step_T2,mesh_T2,width,height,P2MM,allposXY_T2);  % Note: the X, Y and XY distance change with the chosen step. But the velocities do not change (The step is considered in the calculus) 

[distX_mean_T2,distY_mean_T2,DISTXY_mean_T2,distX2_mean_T2,distY2_mean_T2,DISTXY2_mean_T2,changeXYpercent_T2] = B_Filter(distX_T2,distY_T2,DISTXY_T2,median2cut_T2,MinEl2VrPercent_T2);

[velX_T2,velY_T2,velX_mean_T2,velY_mean_T2,StdVelX_T2,StdVelY_T2,STDVELXY_T2,distanceXY_mean_T2,velocityXY_mean_T2,VELOCITYXY_mean_T2,velX2_mean_T2,velY2_mean_T2] = B_MedianStd(distX2_mean_T2,distY2_mean_T2,DISTXY2_mean_T2,distX_T2,distY_T2,DISTXY_T2,frequency_T2,step_T2);    

[velMeanOrderX_T2,velMeanOrderY_T2,StdVelOrderX_T2,StdVelOrderY_T2,velXYmeanOrder_T2,VELXYmeanOrder_T2,STDVELXYOrder_T2,NewLabel,Spi] = B_Spiral(mesh_T2,velX_mean_T2,velY_mean_T2,StdVelX_T2,StdVelY_T2,velocityXY_mean_T2,VELOCITYXY_mean_T2,STDVELXY_T2,P2MM);

[EulerSpiNaN_T2,EulerSpi_T2,EulerNaN_T2,Euler_T2] = B_EulerianData(velMeanOrderX_T2,velMeanOrderY_T2,StdVelOrderX_T2,StdVelOrderY_T2,velXYmeanOrder_T2,VELXYmeanOrder_T2,STDVELXYOrder_T2,NewLabel,distX2_mean_T2,Spi);

[anglesBoxes_T2,distBoxes_T2] = B_HistAndPolarHist(EulerSpi_T2); 

% B_FiguresAndPlots(velocityXY_mean_T2,velX2_mean_T2,velY2_mean_T2,height,width,anglesBoxes_T2,distBoxes_T2);

% Lagrangian ***********************************************************************************

[lagrangian_T2,lagrangianlong_T2,LargestTracking_T2,usefullagrangian_T2,lag12plus_T2,LgrNofMov_T2,tracklist_T2,lagrangiandata_T2] = B_Lagrangian(pair_T2,MinTS_T2,deltaY_T2,speedY_T2,frequency_T2,P2MM);
