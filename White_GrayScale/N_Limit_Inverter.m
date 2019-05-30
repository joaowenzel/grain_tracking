function [meanduneXY,meanLimit,inverter] = N_Limit_Inverter(nimg,step,lst)

    try
    
    meanduneXY = nan(1,2);   
    CENTROID = nan(1,2);
    LIMIT = nan(1,2);
    nn = 1;
    
    for m = nimg:nimg+step
        
        Iname = lst(m);
        I = imread([Iname.name]);  
 
        Icomp = imcomplement(I);
        
        if nn == 1             
            inverter = imclearborder(Icomp);
        end

        Ibin = imbinarize(Icomp);

        Iopen = bwareaopen(Ibin,5600);

        Icomp2 = imcomplement(Iopen);

        Iopen2 = bwareaopen(Icomp2,5600);              

        Props = regionprops(Iopen2);
        
        AREA = vertcat(Props(:).Area);       
        
        [RowMax,~] = find(AREA == max(AREA(:,1)));        
        Props = Props(RowMax,:); 
        Centroid = vertcat(Props(:).Centroid);        
        CENTROID(nn,:) = Centroid(RowMax,:);             

        CentroidRounded = round(vertcat(Props.Centroid));
        CenterLine = find(Iopen2(CentroidRounded(1,2):end,CentroidRounded(1,1))==0);
        limit = CentroidRounded(1,2)-1+CenterLine(1,:);
        
        LIMIT(1,nn) = limit;
                                   
        nn = nn+1;
    end
  
    meanduneXY(1,1) = mean(CENTROID(:,1)); % Median of X1 and X2
    meanduneXY(1,2) = mean(CENTROID(:,2)); % Median of Y1 and Y2
    meanLimit = mean(LIMIT(1,:));
    
    
    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end 

end

