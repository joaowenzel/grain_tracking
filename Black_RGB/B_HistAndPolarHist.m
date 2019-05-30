% Brief explanation:

% This function uses the x and y mean velocities obtained with the 
% Eulerian approach and arranged in a spiral order to separate the mesh 
% elements at angles and distances related to the dune centroid. The code 
% gives the average value of these regions. These results are used to plot 
% the graphs: histogram and polar histogram, allowing to analyze how the 
% grains velocities vary over the dune surface.

% intervalAng & intervalDist change the divisions of angles and distances, 
% respectively.

function [anglesBoxes,distBoxes] = B_HistAndPolarHist(euleriandataSPI2) 

    try

    Ang(:,1) = deg2rad(euleriandataSPI2(:,2));
    Ang(:,2) = euleriandataSPI2(:,8);
    Ang = sortrows(Ang,1);

    Distance(:,1) = euleriandataSPI2(:,3);
    Distance(:,2) = euleriandataSPI2(:,8);
    Distance = sortrows(Distance,1);

    Y = 1;
    x = 1;
    intervalAng = 50;   % Number of Angle Divisions
    anglesBoxes2{2,1} = nan;

    while x <= size(Ang,1) && (Y<=intervalAng)
        element = Ang(x,1);
        SumCounter = 0;
        SumElx = nan(15,1);

        while (element<=((2*pi)/intervalAng)*Y) && x<=size(Ang,1)                
            SumCounter = SumCounter + 1;
            SumElx(SumCounter,1) = Ang(x,2);    
            x = x + 1;  
            
            if x <= size(Ang,1)
                element = Ang(x,1);
            end
        end

        anglesBoxes2{1,1}(1,Y) = ((2*pi)/intervalAng)*Y;
        anglesBoxes2{2,1}(1,Y) = nanmean(SumElx);
        Y = Y + 1;
    end

    anglesBoxes{1,1}(1,1) = 0;
    anglesBoxes{1,1}(1,2:(size(anglesBoxes2{1,1}(1,:),2) + 1)) = anglesBoxes2{1,1}(1,:);
    anglesBoxes{2,1} = anglesBoxes2{2,1}; 

    Y = 1;
    x = 1;   
    intervalDist = 22;  % Number of Distances Divisions
    distBoxes2{2,1}(1,intervalDist) = nan;

    while x <= size(Distance,1) && (Y<=intervalDist)
        element = Distance(x,1);
        SumCounter = 0;
        SumElx = nan(30,1);

        while (element<=((Distance(end,1)/intervalDist)*Y)) && (x<=size(Distance,1))
            SumCounter = SumCounter + 1;
            SumElx(SumCounter,1) = Distance(x,2);    
            x = x + 1;   
            
            if x <= size(Distance,1)           
                element = Distance(x,1);
            end
        end

        distBoxes2{1,1}(1,Y) = ((Distance(end,1)/intervalDist)*Y);
        distBoxes2{2,1}(1,Y) = nanmean(SumElx);
        Y = Y + 1;
    end

    distBoxes{1,1}(1,1) = 0;
    distBoxes{1,1}(1,2:(size(distBoxes2{1,1}(1,:),2) + 1)) = distBoxes2{1,1}(1,:);
    distBoxes{2,1} = distBoxes2{2,1}; 

    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end   

end