% Brief explanation:

% This function applies a Lagrangian approach about the grains displace-
% ments over the dune's surface. The grains are tracked while they are vi-
% sible in the image.

% The code access the array "pair" and pass through  its columns obtaining 
% the position of a specific grain, until it returns the information NaN, 
% which means that the grain is no more visible in the image

function [lagrangian,lagrangianlong,LargestTracking,usefullagrangian,lag12plus,LgrNofMov,tracklist,lagrangiandata] = N_Lagrangian(pair,MinTS,deltaY,speedY,frequency,P2MM)

    try
        
    lp = length(pair); 
    lagrangian{280,lp-1} = [];
    Pair = pair;

    for s = 1:lp-1
        len = length(Pair{1,s});
        row = 1;

        for ss = 1:len              
            S = s;   
            SS = 1;
            next = Pair{1,S}((ss),2);   

            if ~isnan (next)
                lagrangian{row,s}(SS,1) = S;
                lagrangian{row,s}(SS,2) = ss;
                lagrangian{row,s}(SS,3) = Pair{1,S}((ss),5); 
                lagrangian{row,s}(SS,4) = Pair{1,S}((ss),6); 
                Pair{1,S}((ss),2) = nan;

                while ~isnan (next) && S<lp-1
                    S = S + 1;
                    SS = SS + 1;                    

                    lagrangian{row,s}(SS,1) = S;
                    lagrangian{row,s}(SS,2) = next;
                    lagrangian{row,s}(SS,3) = Pair{1,S}((next),5); 
                    lagrangian{row,s}(SS,4) = Pair{1,S}((next),6);                                         

                    row2erase = next;                    
                    next = Pair{1,S}((next),2);
                    Pair{1,S}((row2erase),2) = nan;
                end   

                row = row + 1;
            end
        end            
    end

    [lagrangianlong,LargestTracking] = N_LagrangianLong(lagrangian,MinTS);

    [usefullagrangian,lag12plus,LgrNofMov] = N_UsefulLagrangian(lagrangianlong,deltaY,speedY);   

    [tracklist] = N_TrackList(usefullagrangian,frequency,P2MM);

    [lagrangiandata] = N_LagrangianData(tracklist);

    LargestTracking(1,1) = (sqrt(LargestTracking(1,1)))*P2MM;

    LgrNofMov(1,1) = (LgrNofMov(1,1))/4; % Largest n° of movement 
    
    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
            ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end 
end

