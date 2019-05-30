function [distX,distY,DISTXY] = DistXDistY(Compare,nimg,pair,Comp,indeximg,hf,step,mesh,distX,distY,DISTXY,P2MM)

    try

    sf = length(Compare);
    L = 1;                                % L & C are used to transform the results from an array of 1 row & ((width/mesh)*(high/mesh))columns                                               
    C = 1;                                % to an array of (high/mesh)rows & (width/mesh)columns

    for s = 1:sf 
        len = length(Compare{1,s});       % Amount of grains in each cell of "Compare"
        CountX = 0;                       % The "CountX" and "CountY" are used to count the amount of grain that moved within each cell of "Compare"
        CountY = 0;       
        for ss = 1:len
            final = Compare{1,s}(ss);     % Label of the grain inside a cell of "Compare"                            
            Dist = pair{1,nimg}(final,3); % Distance traveled by the grain between the current image and the following one (just used if step == 1)                             
            nextGrain = true;             % Used to check if the grain appears in the next image                                  

            for istep = 1:step-1          % This for loop is used just when "step" is bigger than 1, and its function is to follow the grains through...
                if isnan(final)           % the images from the current image until the image (current image + "step")
                    nextGrain = false;                            
                    break
                else
                    final = pair{1,(nimg+(istep-1))}(final,2); 
                end                       % In the row above "final" is the same grain of line 20, but now in the image (current image + "step")

                if isnan(final)
                    nextGrain = false;                            
                    break
                end
            end
                                          % This "if" (line 32) is only used when step is greater than 1, and this grain is in the image (current image + "step") (some times the tracking can be lost)...
            if nextGrain == true          % It's function is to calculate the distance traveled by the grain between the current image and the image (current image + "step")
                Dist = sqrt((pair{1,nimg+(step-1)}(final,7)-pair{1,nimg}(Compare{1,s}(ss),5))^2 ... 
                + (pair{1,nimg+(step-1)}(final,8)-pair{1,nimg}(Compare{1,s}(ss),6))^2);
            end

            Comp{L,C,indeximg}(:,1) = Compare{1,s};                                                                         % Intersection between width and height (squares)

            if nextGrain == true                    
                DistY = (pair{1,nimg+(step-1)}(final,8) - pair{1,nimg}(Compare{1,s}(ss),6));                                % Yfinal - Yinitial

                if (DistY < 0  && Dist < 0.5) || (DistY > 0 && Dist < 0.31) 
                    Comp{L,C,indeximg}(ss,2) = nan;
                    Comp{L,C,indeximg}(ss,3) = nan;
                    Comp{L,C,indeximg}(ss,4) = Dist;                                                                        % Distance
                    Comp{L,C,indeximg}(ss,5) = pair{1,nimg+(step-1)}(final,7) - pair{1, nimg}(Compare{1,s}(ss),5);          % Xfinal - Xinitial
                    Comp{L,C,indeximg}(ss,6) = pair{1,nimg+(step-1)}(final,8) - pair{1,nimg}(Compare{1,s}(ss),6);           % Yfinal - Yinitial
                    Comp{L,C,indeximg}(ss,7) = pair{1,nimg}(Compare{1,s}(ss),9);                                            % Area1
                    Comp{L,C,indeximg}(ss,8) = pair{1,nimg+(step-1)}(final,10);                                             % Area2
                else
                    if (pair{1,nimg+(step-1)}(final,7) - pair{1, nimg}(Compare{1,s}(ss),5)) ~= 0
                        Comp{L,C,indeximg}(ss,2) = pair{1,nimg+(step-1)}(final,7) - pair{1, nimg}(Compare{1,s}(ss),5);      % Xfinal - Xinitial 
                        CountX = CountX + 1;
                    else
                        Comp{L,C,indeximg}(ss,2) = nan;
                    end

                    if (pair{1,nimg+(step-1)}(final,8) - pair{1,nimg}(Compare{1,s}(ss),6)) ~= 0                           
                        Comp{L,C,indeximg}(ss,3) = pair{1,nimg+(step-1)}(final,8) - pair{1,nimg}(Compare{1,s}(ss),6);       % Yfinal - Yinitial                            
                        CountY = CountY + 1;
                    else
                        Comp{L,C,indeximg}(ss,3) = nan;
                    end

                    Comp{L,C,indeximg}(ss,4) = Dist;                                % Distance                        
                    Comp{L,C,indeximg}(ss,5) = nan;                        
                    Comp{L,C,indeximg}(ss,6) = nan;
                    Comp{L,C,indeximg}(ss,7) = pair{1,nimg}(Compare{1,s}(ss),9);    % Area1
                    Comp{L,C,indeximg}(ss,8) = pair{1,nimg+(step-1)}(final,10);     % Area2
                end                                                                                    

                if mesh >= 100 && CountX <= 1
                    distX(L,C,indeximg) = nan;
                end

                if mesh >= 100 && CountY <= 1
                    distY(L,C,indeximg) = nan;
                end 
            else                                         % When the grain doesn't appears in the image (current image + "step")
                    Comp{L,C,indeximg}(ss,2) = nan;
                    Comp{L,C,indeximg}(ss,3) = nan;
                    Comp{L,C,indeximg}(ss,4) = nan;
                    Comp{L,C,indeximg}(ss,5) = nan;
                    Comp{L,C,indeximg}(ss,6) = nan;
                    Comp{L,C,indeximg}(ss,7) = nan;      % pair{1,nimg}(Compare{1,s}(ss),9);% Area1
                    Comp{L,C,indeximg}(ss,8) = nan;
            end

            distX(L,C,indeximg) = (mean(Comp{L,C,indeximg}(:,2),'omitnan'))*P2MM;  % mean X distance given in mm
            distY(L,C,indeximg) = (mean(Comp{L,C,indeximg}(:,3),'omitnan'))*P2MM;  % mean Y distance given in mm
            DISTXY(L,C,indeximg) = (mean(Comp{L,C,indeximg}(:,4),'omitnan'))*P2MM; % mean XY distance given in mm
        end            

        if s == (sf/hf)*L
            L = L+1; 
            C = 1;
        else
            C = C+1;
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



   