% Brief Explanation

% If the element of the mesh has lees than "meanEleXY" (amount of images 
% that has valid movement in each element of mesh) times "minEl2verify"
% (given in %) elements, the filter calculates the median value arround 
% this element, and if it's value is greater than "median2cut" times the 
% median value it is replaced by the median value.

function [distX_mean,distY_mean,DISTXY_mean,distX2_mean,distY2_mean,DISTXY2_mean,changeXYpercent] = N_Filter(distX,distY,DISTXY,median2cut,MinEl2VrPercent) 

    try

    distX_mean = mean(distX(:,:,:),3,'omitnan');
    distY_mean = mean(distY(:,:,:),3,'omitnan');
    DISTXY_mean = mean(DISTXY(:,:,:),3,'omitnan');
    
    % distX_mean, distY_mean and DISTXY_mean are the spatial (inside
    % each element of mesh) and temporal (through all images) mean of the
    % grains displacements in x, y, and xy-directions respectively.
   
    % distX2_mean, distY2_mean and DISTXY2_mean are the filtered results 
    
    % changeXYpercent is the percentage of elements of the mesh that has 
    % been filtered

    [row,column,dimensao] = size(distX);
    ElementX = NaN(row,column);
    howmanyelx = 0;
    TofEleX = 0;

    for l = 1:row
        for c = 1:column
            elx = 0;            
            for d = 1:dimensao
                element = distX(l,c,d);                
                if ~isnan(element) && element ~= 0
                    elx = elx + 1;
                end            
            end
            
            ElementX(l,c) = elx;
            TofEleX = TofEleX  +  ElementX(l,c); 

            if ~isnan(ElementX(l,c)) && ElementX(l,c) ~= 0           
                howmanyelx = howmanyelx + 1;
            end           
        end
    end

    medianEleX = TofEleX/howmanyelx;
    ElementX(ElementX(:,:) == 0) = NaN;    
    ElementY = NaN(row,column);
    howmanyely = 0;
    TofEleY = 0;

    for l = 1:row
        for c = 1:column
            ely = 0;
            
            for d = 1:dimensao                
                element = distY(l,c,d);
                
                if ~isnan(element) && element ~= 0
                    ely = ely + 1;
                end            
            end
            
            ElementY(l,c) = ely;
            TofEleY = TofEleY  +  ElementY(l,c);             

            if ~isnan(ElementY(l,c)) && ElementY(l,c) ~= 0 
                howmanyely = howmanyely + 1;
            end            
        end
    end

    medianEleY = TofEleY/howmanyely;
    meanEleXY = (medianEleX  +  medianEleY)/2;
    minEl2verify = meanEleXY * (MinEl2VrPercent/100);

    ElementY(ElementY(:,:) == 0) = NaN;

    [elX(:,1),elX(:,2)] = find(ElementX<=minEl2verify);
    [elY(:,1),elY(:,2)] = find(ElementY<=minEl2verify);

    eleXY(1:length(elX),1:2) = elX;
    eleXY(length(elX) + 1:length(elX) + length(elY),1:2) = elY;
    eleXY = unique(eleXY,'rows');        

    ElementXY = NaN(row,column);  
    howmanyelXY = 0;
    TofEleXY = 0;

    for l = 1:row
        for c = 1:column
            elXY = 0;
            
            for d = 1:dimensao                
                element = DISTXY(l,c,d);
                
                if ~isnan(element) && element ~= 0
                    elXY = elXY + 1;
                end            
            end
            
            ElementXY(l,c) = elXY;
            TofEleXY = TofEleXY  +  ElementXY(l,c);             

            if ~isnan(ElementXY(l,c)) && ElementXY(l,c) ~= 0 
                howmanyelXY = howmanyelXY + 1;
            end            
        end
    end

    ElementXY(ElementXY(:,:) == 0) = NaN;

    meanEleXY2 = TofEleXY/howmanyelXY;
    minEl2verify2 = meanEleXY2 * (MinEl2VrPercent/100);           
    [eleXY2(:,1),eleXY2(:,2)] = find(ElementXY<=minEl2verify2);

    distX2_mean = distX_mean; 
    [roweleXY,~] = size(eleXY);
    changeX = 0;

    for SizeX = 1:roweleXY        
        x = eleXY(SizeX,1);
        y = eleXY(SizeX,2);
        SumCounter  = 0;
        somaElx = nan;

        if x>1 && x<32 && y>1 && y<41            
            for x1 = (x-1):(x + 1)
                for y1 = (y-1):(y + 1)                               
                    elx2 = distX2_mean(x1,y1);    

                    if ~isnan(elx2)                        
                        SumCounter  = SumCounter + 1;
                        somaElx(SumCounter ,1) = elx2;
                    end                                                                  
                end
            end
            
            SOMA = sum(somaElx);
            
            if SumCounter  > 1
                MedianElx = (SOMA-(distX2_mean(x,y)))/(SumCounter -1);
                
                if abs(distX2_mean(x,y)) > abs((median2cut*MedianElx))
                    changeX = changeX + 1;
                    distX2_mean(x,y) = MedianElx;
                end
            else
                distX2_mean(x,y) = nan;
            end
        else
            distX2_mean(x,y) = nan;
        end
    end

    distY2_mean = distY_mean; 
    changeY = 0;

    for SizeY = 1:roweleXY        
        x = eleXY(SizeY,1);
        y = eleXY(SizeY,2);
        SumCounter = 0;
        somaEly = nan;

        if x>1 && x<32 && y>1 && y<41            
            for x1 = (x-1):(x + 1)
                for y1 = (y-1):(y + 1)                                                             
                    ely2 = distY2_mean(x1,y1);                                  

                    if ~isnan(ely2)  
                        SumCounter = SumCounter  + 1;
                        somaEly(SumCounter,1) = ely2;
                    end                                                                  
                end
            end
            
            SOMA = sum(somaEly);
            
            if SumCounter  > 1
                MedianEly = (SOMA-(distY2_mean(x,y)))/(SumCounter - 1);
               
                if abs(distY2_mean(x,y)) > abs((median2cut*MedianEly))
                    changeY = changeY + 1;
                    distY2_mean(x,y) = MedianEly;
                end
            else
                distY2_mean(x,y) = nan;
            end            
        else
            distY2_mean(x,y) = nan;
        end 
    end

    DISTXY2_mean = DISTXY_mean; 
    [roweleXY2,~] = size(eleXY2);
    changeXY = 0;

    for SizeXY = 1:roweleXY2
        x = eleXY2(SizeXY,1);
        y = eleXY2(SizeXY,2);
        SumCounter  = 0;
        somaElxy = nan;

        if x>1 && x<32 && y>1 && y<41            
            for x1 = (x - 1):(x + 1)
                for y1 = (y - 1):(y + 1)                                                             
                    elxy2 = DISTXY2_mean(x1,y1);                                  

                    if ~isnan(elxy2)  
                        SumCounter  = SumCounter  + 1;
                        somaElxy(SumCounter,1) = elxy2;
                    end                                                                  
                end
            end
            
            SOMA = sum(somaElxy);
            
            if SumCounter > 1
                MedianElxy = (SOMA - (DISTXY2_mean(x,y)))/(SumCounter - 1);
                
                if abs(DISTXY2_mean(x,y)) > abs((median2cut*MedianElxy))
                    changeXY = changeXY + 1;
                    DISTXY2_mean(x,y) = MedianElxy;
                end
            else
                DISTXY2_mean(x,y) = nan;
            end            
        else
            DISTXY2_mean(x,y) = nan;
        end 
    end

    changeXpercent = (changeX/howmanyelx)*100;
    changeYpercent = (changeY/howmanyely)*100;
    changeXYpercent = (changeXpercent + changeYpercent);
    changeXY2percent = (changeXY/howmanyelXY)*100;

    catch ME
    % Some error occurred if you get here.
    errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
    ME.stack(1).name, ME.stack(1).line, ME.message);
    fprintf(1, '%s\n', errorMessage);
    uiwait(warndlg(errorMessage));
    end        
end
   
% If you want to have more detailed information about the changes made by 
% the filter, replace line 9 by line 254.

%function [distX_mean,distY_mean,DISTXY_mean,distX2_mean,distY2_mean,DISTXY2_mean,changeX,changeY,ElementX,ElementY,ElementXY,changeXYpercent,changeXpercent,changeYpercent,changeXY2percent,meanEleXY,meanEleXY2] = Filter(distX,distY,DISTXY,median2cut,MinEl2VrPercent)    
    

