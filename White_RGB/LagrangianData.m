% Brief explanation:

% This function provides the mean of x and y distances and velocities of
% all valid tracking obtained in the Eulerian approach (each time that each 
% grain moved). Besides that, it gives the standard deviations of distances
% and velocities for both axes.

% Ex.:                                        Results of all trackings                                                      
% mean of x-dist.-mean of y-dist.-std. of x-dist.-std. of y-dist.-mean of x-vel.-mean of y-vel.-std. of x-vel.-std. of y-vel.

function [lagrangiandata] = LagrangianData(tracklist)

    try

    [tlsize,~] = size(tracklist);

    Velx = tracklist(:,1);
    VelxSUM = sum(Velx);
    VelxMean = (VelxSUM/(tlsize));
    
    VelxSTD = std(Velx);

    Vely = tracklist(:,2);
    VelySUM = sum(Vely);
    VelyMean = (VelySUM/(tlsize));

    VelySTD = std(Vely);

    distX = tracklist(:,3);
    distXSUM = sum(distX);
    distXMean = (distXSUM/(tlsize));

    distXSTD = std(distX);

    distY = tracklist(:,4);
    distYSUM = sum(distY);
    distYMean = (distYSUM/(tlsize));

    distYSTD = std(distY);

    lagrangiandata(:,1) = distXMean;
    lagrangiandata(:,2) = distYMean;
    lagrangiandata(:,3) = distXSTD;
    lagrangiandata(:,4) = distYSTD;
    lagrangiandata(:,5) = VelxMean;
    lagrangiandata(:,6) = VelyMean;
    lagrangiandata(:,7) = VelxSTD;
    lagrangiandata(:,8) = VelySTD;
    
    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
            ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end 
end
