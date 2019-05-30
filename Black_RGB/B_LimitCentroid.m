% Obs.: The combination of the low exposure time between the images (due to
% the high frequencies used) and the black dune (very similar to the bottom 
% wall of the channel), required a very intense illumination. The lighting 
% was not absolutely perfectly distributed. Thus needing to "slice" the 
% image in order to be able to apply different thresholds of luminous 
% intensity of pixel, allowing to identify all the contour of the dune.

function [meanduneXY,meanLimit,meanBB,Ig] = B_LimitCentroid(nimg,step,lst,height,width)
    
    try

    meanduneXY = nan(1,2);
    CENTROID = nan(1,2);
    LIMIT = nan(1,2);
    nn = 1;
    LimitofBB = nan(2,1);

    for m = nimg:nimg+step

        Iname = lst(m);
        I = imread([Iname.name]);      

        Iadjust = imadjust(I,[0.00; 0.35],[0.1; 0.9], 0.5); 

        se = offsetstrel('ball',3,5);
        Ierode = imerode(Iadjust,se);

        IerodeGray = rgb2gray(Ierode);   
        ImanualBin = nan(height,width);

        IerodeGray2 = IerodeGray*2;
        
        % Here starts the sequence of "FORs" used to apply different 
        % thresholds in the image. If the image that you are working on has
        % a good illumination distribution, you will not need to do that. 
        % In this case, a simple binarization command is enough to differ-
        % entiate the dune from the bottom wall of the channel.
        
        Treshold = 115;

        for i = 1:50
            for j = 8:792              
                if (IerodeGray2(i,j) > Treshold)                 
                    ImanualBin(i,j) = 1;    
                else
                    ImanualBin(i,j) = 0;
                end
                if j > 590 
                    ImanualBin(i,j) = 1;
                end      
            end
        end

        Treshold = 122;

        for i = 51:110
            for j = 8:792              
                if (IerodeGray2(i,j) > Treshold)                 
                    ImanualBin(i,j) = 1;    
                else
                    ImanualBin(i,j) = 0;
                end
                if j > 565 
                    ImanualBin(i,j) = 1;
                end      
            end
        end

        Treshold = 138;

        for i = 111:140
            for j = 8:792              
                if (IerodeGray2(i,j) > Treshold)                 
                    ImanualBin(i,j) = 1;    
                else
                    ImanualBin(i,j) = 0;
                end
                if j > 590 
                    ImanualBin(i,j) = 1;
                end      
            end
        end

        Treshold = 147;

        for i = 141:300
            for j = 8:792
                if (IerodeGray2(i,j) > Treshold)
                    ImanualBin(i,j) = 1;    
                else
                    ImanualBin(i,j) = 0;
                end          
            end
        end

        Treshold = 148;

        for i = 301:650
            for j = 8:792
                if (IerodeGray2(i,j) > Treshold)
                    ImanualBin(i,j) = 1;    
                else
                    ImanualBin(i,j) = 0;
                end          
            end
        end

        Treshold = 150;

        for i = 651:720
            for j = 8:792
                if (IerodeGray2(i,j) > Treshold)
                    ImanualBin(i,j) = 1;    
                else
                    ImanualBin(i,j) = 0;
                end          
            end
        end

        Treshold = 152;

        for i = 721:770
            for j = 8:792
                if (IerodeGray2(i,j) > Treshold)
                    ImanualBin(i,j) = 1;    
                else
                    ImanualBin(i,j) = 0;
                end          
            end
        end

        Treshold = 148;

        for i = 771:height
            for j = 8:792
                if (IerodeGray2(i,j) > Treshold)
                    ImanualBin(i,j) = 1;    
                else
                    ImanualBin(i,j) = 0;
                end          
            end
        end

        Icomp = imcomplement(ImanualBin);

        Ibin = imbinarize(Icomp);

        Iopen = bwareaopen(Ibin,50000);

        Icomp2 = imcomplement(Iopen);

        Iopen2 = bwareaopen(Icomp2,50000);

        Icomp3 = imcomplement(Iopen2);

        Props = regionprops(Icomp3,'Centroid');
        Props2 = regionprops(Icomp3);

        Centroid = vertcat(Props(:).Centroid);        
        CENTROID(nn,:) = Centroid;

        boundingbox = vertcat(Props2(:).BoundingBox);        
        TopAndHeigh(:,1) = boundingbox(:,2);   % Top 
        TopAndHeigh(:,2) = boundingbox(:,4);   % Height
        LimitofBB(nn,:) = TopAndHeigh(:,1) + TopAndHeigh(:,2);

        CentroidRounded = round(vertcat(Props.Centroid));
        CenterLine = find(Icomp3(CentroidRounded(1,2):end,CentroidRounded(1,1))==0);
        limit = CentroidRounded(1,2)-1+CenterLine(1,:);

        LIMIT(1,nn) = limit;

        if nn == 1             
            Igray = rgb2gray(I);
            Ig = Igray;
            for i = 1:height
                for j = 1:width
                    element = Icomp3(i,j);        
                    if element == 0
                        Ig(i,j) = 0;
                    else
                        Ig(i,j) = Igray(i,j);
                    end
                end
            end
        end                            
        nn = nn+1;
    end

    meanduneXY(1,1) = mean(CENTROID(:,1)); % Median of X1 and X2
    meanduneXY(1,2) = mean(CENTROID(:,2)); % Median of Y1 and Y2
    meanLimit = mean(LIMIT(1,:));
    meanBB = mean(LimitofBB);

    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end 

end