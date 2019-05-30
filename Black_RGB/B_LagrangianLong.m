% Brief explanation:

% This function returns the trackings larger than "MinTS" (Minimal tracking
% size) defined in the main function.

function [lagrangianlong,LargestTracking] = B_LagrangianLong(lagrangian,MinTS)

    try

    [rowlag,collag] = size(lagrangian);
    lagrangianlong{rowlag,collag} = [];
    test1 = 1;
    test2 = 1;
    LargestTracking = zeros(1,3);

    for s = 1: collag
        hh = 1;
        
        for h = 1:rowlag
            [imtrack,~] = size(lagrangian{h,s});                

            if imtrack == 0
                test1 = test1 + 1;

            else
                sizetrack = (lagrangian{h,s}(imtrack,4)-lagrangian{h,s}(1,4))^2  +  (lagrangian{h,s}(imtrack,3)-lagrangian{h,s}(1,3))^2;

                if sizetrack <= MinTS
                    test2 = test2 + 1;
                else
                    lagrangianlong{hh,s} = lagrangian{h,s};                    
                    hh = hh + 1;

                    if  sizetrack > LargestTracking(1,1)
                        LargestTracking(1,1) = sizetrack;
                        LargestTracking(1,2) = h;
                        LargestTracking(1,3) = s;
                    end                   
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