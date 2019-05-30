
function [limit] = Limit(I)
    
    try 
            
    Igray = rgb2gray(I);

    Icomp = imcomplement(Igray);        

    Ibin = imbinarize(Icomp);

    Iopen = bwareaopen(Ibin,500);

    Icomp2 = imcomplement(Iopen);

    Iopen2 = bwareaopen(Icomp2,500);

    Props = regionprops(Iopen2);

    Centroids = fix(vertcat(Props.Centroid));

    CenterLine = find(Iopen2(Centroids(1,2):end,Centroids(1,1))==0);

    limit = Centroids(1,2)-1+CenterLine(1,:);
    
    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end 

end
