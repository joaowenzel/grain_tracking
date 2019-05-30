% Brief explanation:

% This function uses "deltaY" and "speedY" to determine and filter the 
% tracking, in order to get just the time when the particle is in movement, 
% disregarding the time in which it remains stopped

function [usefullagrangian,lag12plus,LgrNofMov] = N_UsefulLagrangian(lagrangianlong,deltaY,speedY)

    try

    [rowlag,collag] = size(lagrangianlong);
    usefullagrangian{rowlag,collag} = [];

    for s = 1: collag    
        for h = 1:rowlag            
            row = 1;               
            [Length,~] = size(lagrangianlong {h,s}); 
            Col = 1;
            Utrack = NaN(Length,4);
            ii = 1;
            itest2 = 1;
            
            for i = 1:Length-deltaY
                sp = (lagrangianlong{h,s}(i+deltaY,4) - lagrangianlong{h,s}(i,4))/deltaY;
                if sp > speedY                                                
                    itest = i-ii;
                    ii = i;  
                    
                    if (itest>1) && (itest2>1)            
                        Col = Col + 4;
                        row = 1;                            
                    end       
                    
                    itest2 = itest2+1;
                    I = i;
                    row2 = row;
                    
                    while row2 <= row + deltaY                                                 
                        Utrack(row2,Col:Col+3)   =  lagrangianlong{h,s}(I,:);
                        I = I + 1;
                        row2 = row2 + 1;
                    end
                    row = row + 1;
                end
            end

            usefullagrangian{h,s} = Utrack;  
            usefullagrangian{h,s}(usefullagrangian{h,s} == 0) = NaN;
        end
    end

    LgrNofMov = zeros(1,3);
    lag12plus{rowlag,collag} = [];
    
    for s = 1: collag   
        row = 1;
        
        for h = 1:rowlag                         
            col = size(usefullagrangian{h,s},2); 
            
            if col >= 12                
                lag12plus{row,s} =  usefullagrangian{h,s};
                row = row+1;            
            end
            
            if col > LgrNofMov(1,1)                
                LgrNofMov(1,1) = col;
                LgrNofMov(1,2) = h;
                LgrNofMov(1,3) = s;
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

