function [pos,props,Area] = B_TracerIdentifier(im,threshold,arealim)       

    try

    if numel(arealim)==1
        arealim=[arealim inf]; 
    end
    
    warnstate=warning('off','MATLAB:divideByZero');
    props=regionprops(im>threshold,im,'WeightedCentroid','Area', ...
    'PixelValues','PixelList');
    pos=vertcat(props.WeightedCentroid);    
    
    if numel(pos)>0
        good = pos(:,1)~=1 & pos(:,2)~=1 & pos(:,1)~=(2) & ...
        pos(:,2)~=(1) & vertcat(props.Area)>arealim(1) & ...
        vertcat(props.Area)<arealim(2); 
        pos=pos(good,:);
        props=props(good);
        Area=vertcat(props.Area);
    end    
    warning(warnstate)
    
    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
        ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end 
    
end