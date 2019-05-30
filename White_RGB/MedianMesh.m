function[distX,distY,DISTXY] = MedianMesh(pair,n,nf,step,mesh,width,height,lst,P2MM)

    try
        
    ninitial = n;
    nfinal = nf-step;
    indeximg = 1;
    Compare{1,round(height/mesh)*round(width/mesh)} = [];
    Comp{(round(height/mesh)),(round(width/mesh)),nfinal-ninitial+1} = [];
    distX = NaN((round(height/mesh)),(round(width/mesh)),nfinal-ninitial+1);  % Mean grain displacements in the x-direction within each mesh element in each image 
    distY = NaN((round(height/mesh)),(round(width/mesh)),nfinal-ninitial+1);  % Mean grain displacements in the y-direction within each mesh element in each image 
    DISTXY = NaN((round(height/mesh)),(round(width/mesh)),nfinal-ninitial+1); % Mean grain displacements in the xy-direction within each mesh element in each image 

    for nimg = ninitial:nfinal  

        [MDuneXY] = MeanDuneXY(nimg,step,lst);                                % This function returns the average of the dune centroids in the current image and in the next one (current image + "step") 

        [Compare,hf] = COMPARE(pair,nimg,MDuneXY,width,height,mesh,Compare);  % This function returns the elements inside each square of mesh
                                                                              % It's better explained inside the function!    
        [distX,distY,DISTXY] = DistXDistY(Compare,nimg,pair,Comp,indeximg,hf,step,mesh,distX,distY,DISTXY,P2MM);    

        indeximg = indeximg + 1;
    end

    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
            ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end    
end