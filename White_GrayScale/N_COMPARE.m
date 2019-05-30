function [Compare,hf] = N_COMPARE(Pair,nimg,width,high,mesh,Compare,allposXY)

    try

    MDuneXY = allposXY{5,nimg};
   [ROW, ~] = size(Pair{1,nimg});  % Row = N° of rows in the current image (N° Of detected tracers in each image) 
    ROW = round(ROW/2);            % Divided by 2 because it is more than enough space
    x = MDuneXY(1,1);              % x = x-position of the dune's centroid (Median of 2 images)
    nw = round((width/mesh)/2);    % nw = number of mesh elements in x (width, that's why 'nw'), divided by 2 (to find the middle)
    nw2 = nw+1;                    % nw2 = nw+1 (is used to set the starting point of the second half) 
    nwf = nw*2;                    % nwf = total number of mesh elements in x (width) 
    wid2 = NaN(ROW,nwf);           % wid2 = An array used to separate the grains in columns (Normalized by the dune's centroid)
                                   % Ex. the first column of the second half has all the elements that x positions of centroid is >=  Xdune & < Xdune + mesh, and so on)
                                   % And the last column of the firt half has all the elements that x-positions of centroid is <=  Xdune & > Xdune - mesh, and so on)

    while (nw > 0)                 % Create the first half of wid2
        wid = find(Pair{1,nimg}(:,5) <= x & Pair{1,nimg}(:,5) > x-mesh); 
        wid2(1:length(wid),nw) = wid(:,1);
        x = x - mesh;
        nw = nw - 1;
    end

    x = MDuneXY(1,1);

    while (nw2 <= nwf)             % Create the second half of wid2
        wid = find(Pair{1,nimg}(:,5) >= x & Pair{1,nimg}(:,5) < x+mesh); 
        wid2(1:length(wid),nw2) = wid(:,1);
        x = x + mesh;
        nw2 = nw2 + 1;
    end

    y = MDuneXY(1,2);                % y = y position of the dune's centroid (Median of 2 images)
    nh = round((high/mesh)/2);      % nh = number of mesh elements in y (high, that's why 'nh'), divided by 2 (to find the middle) 
    nh2 = nh+1;                     % nh2 = nh+1 (is used to set the starting point of the second half) 
    nhf = round(high/mesh);         % nhf = total number of mesh elements in y (high)   
    hig2 = NaN(ROW,nhf);            % hig2 = An array used to separate the grains in rows 
                                    % Ex. the first column of the second half has all the elements that y positions of centroid is >=  Ydune & < Ydune + mesh, and so on)
                                    % And the last column of the firt half has all the elements that y-positions of centroid is <=  Ydune & > Ydune - mesh, and so on) 

    while (nh > 0)                  % Create the first half of hig2
        hig = find(Pair{1,nimg}(:,6) <= y & Pair{1,nimg}(:,6) > y-mesh);
        hig2(1:length(hig),nh) = hig(:,1);
        y = y - mesh;
        nh = nh - 1;
    end

    y = MDuneXY(1,2);

    while (nh2 <= nhf)              % Create the second half of hig2
        hig = find(Pair{1,nimg}(:,6) >= y & Pair{1,nimg}(:,6) < y+mesh);
        hig2(1:length(hig),nh2) = hig(:,1);
        y = y + mesh;
        nh2 = nh2 + 1;             
    end

    [~,wf] = size(wid2);
    [~,hf] = size(hig2);    
    clear Compare                       
    Compare{1,(hf*wf)} = [];
    z = 1;
    
    for h = 1:hf
        for w = 1:wf
            Compare{1,z}(:,1) = intersect(hig2(:,h),wid2(:,w)); %Intersection between width and height (squares of the mesh)                                    
            z = z+1;
        end                         
    end
    
    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
            ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end 
end