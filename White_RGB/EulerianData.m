% Brief explanation:

% This function brings together all the results obtained with the Eulerian 
% approach, and present them in 4 different ways:

% Euler:        Normal order without Not a Numbers
% EulerNaN:     Normal order with Not a Numbers
% EulerSpi:     Spiral order without Not a Numbers
% EulerSpiNaN:  Spiral order with Not a Numbers

% Normal order: The elements are enumerated beginning in the left upper 
% corner until fill out all columns, then start the next line, and so on. -  -  -  -  -  -  - 

% Spiral order: The elements are enumerated beginning around the centroid, 
% making a spiral 

function[EulerSpiNaN,EulerSpi,EulerNaN,Euler] = EulerianData(velMeanOrderX,velMeanOrderY,StdVelOrderX,StdVelOrderY,velXYmeanOrder,VELXYmeanOrder,STDVELXYOrder,NewLabel,distX2_mean,Spi)
    
    try

    Total(:,1) = velMeanOrderX(:,1); % Angle
    Total(:,2) = velMeanOrderX(:,2); % Dist to centroid
    Total(:,3) = velMeanOrderX(:,3); % real velMeanOrderX
    Total(:,4) = velMeanOrderY;
    Total(:,5) = StdVelOrderX;
    Total(:,6) = StdVelOrderY;
    Total(:,7) = velXYmeanOrder;
    Total(:,8) = VELXYmeanOrder;
    Total(:,9) = STDVELXYOrder;        

    row = 1;
    Tsize = size(Total,1);
    EulerSpiNaN = NaN((Tsize),10);
    EulerSpi = NaN((Tsize/4),10);

    for t = 1:Tsize
        Tnum = Total(t,3);
        EulerSpiNaN(t,1) = t;
        EulerSpiNaN(t,2:10) = Total(t,:);

        if ~isnan(Tnum)
            EulerSpi(row,1) = t;
            EulerSpi(row,2:10) = Total(t,:);
            row = row+1;
        end
    end

    distX_Traspose = distX2_mean';
    distX_reshaped = reshape(distX_Traspose,[],1);

    for dt = 1:(size(distX_reshaped,1))             
        distX_reshaped(dt,2) = distX_reshaped(dt,1);
        distX_reshaped(dt,1) = dt;
    end

    row = 1;
    distX_reshaped2 = nan(10,1);

    for t = 1:(size(distX_reshaped,1))
        Tnum = distX_reshaped(t,2);
        
        if ~isnan(Tnum)
            distX_reshaped2(row,:) = distX_reshaped(t,1);       
            row = row+1;
        end
    end

    Euler(:,1) = distX_reshaped2;

    for i = 1:(size(distX_reshaped2,1))    
        num = distX_reshaped2(i,1);
        [x,y] = find(NewLabel==num);
        num2 = Spi(x,y);
        Fnd = find(EulerSpi(:,1)==num2);
        Euler(i,2:11) = EulerSpi(Fnd,:);
    end          

    EulerNaN = nan(size(distX_reshaped,1),1);

    for i = 1:(size(distX_reshaped,1))        
        num = distX_reshaped(i,1);
        [x,y] = find(NewLabel==num);
        num2 = Spi(x,y);
        Fnd = find(EulerSpiNaN(:,1)==num2);
        EulerNaN(i,2:11) = EulerSpiNaN(Fnd,:);
    end  

    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end   
end

% Organization of variables in columns

% Euler       - Label in normal order - Label in Spiral order - angle to centroid - Dist to centroid - VelMeanOrderX - VelMeanOrderY - StdVelOrderX - StdVelOrderY - velXYmeanOrder - VELXYmeanOrder - STDVELXYOrder
% EulerNaN    - Label in normal order - Label in Spiral order - angle to centroid - Dist to centroid - VelMeanOrderX - VelMeanOrderY - StdVelOrderX - StdVelOrderY - velXYmeanOrder - VELXYmeanOrder - STDVELXYOrder
% EulerSpi    - Label in Spiral order - angle to centroid - Dist to centroid - VelMeanOrderX - VelMeanOrderY - StdVelOrderX - StdVelOrderY - velXYmeanOrder - VELXYmeanOrder - STDVELXYOrder
% EulerSpiNaN - Label in Spiral order - angle to centroid - Dist to centroid - VelMeanOrderX - VelMeanOrderY - StdVelOrderX - StdVelOrderY - velXYmeanOrder - VELXYmeanOrder - STDVELXYOrder  
  


