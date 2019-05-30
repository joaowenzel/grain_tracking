% Brief explanation:

% This function provides the distances and the median velocities in x and 
% y-axis for each time that each grain moved. Each one of these movements 
% is shown in a different row, as the example below.

% Tracking  -                       Results  
% N°1       - median x-velocity - median y-velocity - x-distance - y-distance
% N°2       - median x-velocity - median y-velocity - x-distance - y-distance
% N°3       - median x-velocity - median y-velocity - x-distance - y-distance
% and so on - median x-velocity - median y-velocity - x-distance - y-distance

function [tracklist] = N_TrackList(usefullagrangian,frequency,P2MM)

    try

    [rowlag, collag] = size (usefullagrangian);
    tracklist = [];
    row = 1;

    for h = 1:collag 
        for s = 1: rowlag  
            [~,LagCOL] = size(usefullagrangian{s,h});

            for lc = 1:4:LagCOL
                A = usefullagrangian{s,h}(:,lc);
                A(isnan(A)) = [];
                [Asize,~] = size(A);

                if Asize ~= 0
                    X = usefullagrangian{s,h}(:,lc+2);
                    X(isnan(X)) = [];

                    Y = usefullagrangian{s,h}(:,lc+3);  
                    Y(isnan(Y)) = [];

                    PX = polyfit(A,X,1);
                    PX = PX(:,1);
                    PY = polyfit(A,Y,1);
                    PY = PY(:,1);

                    distX = (usefullagrangian{s,h}(Asize,lc+2))- (usefullagrangian{s,h}(1,lc+2));
                    distY = (usefullagrangian{s,h}(Asize,lc+3))- (usefullagrangian{s,h}(1,lc+3));

                    tracklist(row,1) = (PX*P2MM)*frequency;
                    tracklist(row,2) = (PY*P2MM)*frequency;
                    tracklist(row,3) = distX*P2MM;
                    tracklist(row,4) = distY*P2MM;
                    row = row + 1;
                end
            end
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