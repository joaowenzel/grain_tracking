close all; 
clc; 
warning('off', 'Images:initSize:adjustingMag');
%***********************************************************************************************
frequency_T1 = 300;         % Frequency of image acquisition
n_T1 = 1;                   % Initial image
nf_T1 = 3000;               % Final image
threshold_T1 = 250;         % Threshold to differentiate the grains and the bottom wall of the channel
arealim_T1 = [3 150];       % Determine the lower and upper bound of area of each grain (Pixels)
MD2SF_T1 = 37.4519;         % Maximum distance to search for the same grain in the next image (Pixels)
MinTS_T1 = 101.4339;        % Minimal tracking size to consider in lagrangian (Pixels)
deltaY_T1 = 2;              % deltaY & speedY are used to determine and filter the tracking,in order to get just the time when the particle is in movement...
speedY_T1 = 0.6;            % disregarding the time in which it remains stopped
height = 1024;              % Image height (Pixels)
width = 800;                % Image width (Pixels)
step_T1 = 1;                % Here is possible to choose the gap between the images. Ex. if step == 1: image n°1->n°2; n°2->n°3; n°3->n°4... if step == 2: image n°1->n°3; n°2->n°4; n°3->n°5 ans so on...         
mesh_T1 = 25;               % Determine the mesh size that will be generated on the image
median2cut_T1 = 2;          % Used in filter, if the element of the mesh has lees than "meanEleXY"(amount of images that has valid movement in each element of mesh) times "minEl2verify"(given in %) elements,                                                          
MinEl2VrPercent_T1 = 27;    % the filter calculates the median value arround this element, and if it's value is greater than "median2cut" times the median value it is replaced by the median value
P2MM = 0.0992906802568982;  % Pixel to milimeter conversion factor
%***********************************************************************************************
allposXY_T1{4,nf_T1-(n_T1-1)} = [];
time_img_T1 = 1/frequency_T1; 
lst = dir('*.tif');

for m = n_T1:nf_T1
    clf
    time_T1 = (m-1)*time_img_T1;
    Iname = lst(m);
    I = imread([Iname.name]);
    [inverter] = Inverter(I);   % This function reverses the image to make the tracers white
    [pos,props,Area] = TracerIdentifier(inverter,threshold_T1,arealim_T1);
    posx = pos(:,1);
    posy = pos(:,2);
    [limit] = Limit(I);
    allposXY_T1{1,m} = posx;   % Position on the x-axis of each tracer grain detected in the image
    allposXY_T1{2,m} = posy;   % Position on the y-axis of each tracer grain detected in the image
    allposXY_T1{3,m} = limit;  % Central point of dune slip face
    allposXY_T1{4,m} = Area;   % Area of each tracer grain detected in the image
    subplot(1,2,1)
    imshow(I)    
    title([' Raw Image ',num2str(m),' of ',num2str(nf_T1)])
    subplot(1,2,2)
    imshow(inverter)    
    title(['Processed Image ',num2str(m),' of ',num2str(nf_T1)])
    hold on
    plot(posx,posy,'ro')
    pause(0.001)
end

% A brief explanation of the following functions can be found inside of them.

% Eulerian *************************************************************************************

[pair_T1] = Pair(allposXY_T1,MD2SF_T1,frequency_T1,P2MM); 
                                                          
[distX_T1,distY_T1,DISTXY_T1] = MedianMesh(pair_T1,n_T1,nf_T1,step_T1,mesh_T1,width,height,lst,P2MM);  % Note: the X, Y and XY distance change with the chosen step. But the velocities do not change(The step is considered in the calculus) 

[distX_mean_T1,distY_mean_T1,DISTXY_mean_T1,distX2_mean_T1,distY2_mean_T1,DISTXY2_mean_T1,changeXYpercent_T1] = Filter(distX_T1,distY_T1,DISTXY_T1,median2cut_T1,MinEl2VrPercent_T1);

[velX_T1,velY_T1,velX_mean_T1,velY_mean_T1,StdVelX_T1,StdVelY_T1,STDVELXY_T1,distanceXY_mean_T1,velocityXY_mean_T1,VELOCITYXY_mean_T1,velX2_mean_T1,velY2_mean_T1] = MedianStd(distX2_mean_T1,distY2_mean_T1,DISTXY2_mean_T1,distX_T1,distY_T1,DISTXY_T1,frequency_T1,step_T1);    

[velMeanOrderX_T1,velMeanOrderY_T1,StdVelOrderX_T1,StdVelOrderY_T1,velXYmeanOrder_T1,VELXYmeanOrder_T1,STDVELXYOrder_T1,NewLabel,Spi] = Spiral(mesh_T1,velX2_mean_T1,velY2_mean_T1,StdVelX_T1,StdVelY_T1,velocityXY_mean_T1,VELOCITYXY_mean_T1,STDVELXY_T1,P2MM);

[EulerSpiNaN_T1,EulerSpi_T1,EulerNaN,Euler_T1] = EulerianData(velMeanOrderX_T1,velMeanOrderY_T1,StdVelOrderX_T1,StdVelOrderY_T1,velXYmeanOrder_T1,VELXYmeanOrder_T1,STDVELXYOrder_T1,NewLabel,distX2_mean_T1,Spi);

[anglesBoxes_T1,distBoxes_T1] = HistAndPolarHist(EulerSpi_T1); 

FiguresAndPlots(velocityXY_mean_T1,velX2_mean_T1,velY2_mean_T1,height,width,anglesBoxes_T1,distBoxes_T1);

% Lagrangian ***********************************************************************************

[lagrangian_T1,lagrangianlong_T1,LargestTracking_T1,usefullagrangian_T1,lag12plus_T1,LgrNofMov_T1,tracklist_T1,lagrangiandata_T1] = Lagrangian(pair_T1,MinTS_T1,deltaY_T1,speedY_T1,frequency_T1,P2MM);
