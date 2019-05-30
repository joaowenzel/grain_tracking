% This functions provides a comparison between the position of the tracer 
% in the current image and the position of this same tracer in the next 
% image (current image + step)

function [pair] = N_Pair(allposXY,MD2LF,frequency,P2MM)

    try

    [~,totalimg] = size(allposXY);
    pair{1,totalimg} = [];

    for img = 1:totalimg-1

        [Size1,~] = size(allposXY{1,img});
        [Size2,~] = size(allposXY{1,img+1});
        DifSize = abs(Size1-Size2);

        if DifSize <24
            DifSize = 24;
        end

        FS = nan(Size1,2*DifSize+1); 
        PAIR = nan(Size1,10);

        for n = 1:Size1
            if n <= DifSize
                initial = 1;
                final = 2*DifSize + 1;
            elseif n >= Size2 - DifSize
                initial = Size2 - 2*DifSize;
                final = Size2;
            else
                initial = n - DifSize;
                final = n + DifSize;
            end

            Position = 1;

            for nn = initial:final        
                FS(n,Position) = (allposXY{1,img}(n)-allposXY{1,img+1}(nn))^2 + (allposXY{2,img}(n)-allposXY{2,img+1}(nn))^2;
                Position = Position+1;
            end

            FS2 = FS(n,:);
            FS2 = sort(FS2,'ascend');               

            x1 = FS2(1,1);
            x2 = FS2(1,2);
            x3 = FS2(1,3);        

            [~,x4] = find(FS(n,:)==x1);
            [~,x5] = find(FS(n,:)==x2);
            [~,x6] = find(FS(n,:)==x3);

            x4 = x4(1,1);
            x5 = x5(1,1);
            x6 = x6(1,1);

            FSmin = nan(1,3);       
            FSmin(1,1) = x4;
            FSmin(1,2) = x5;
            FSmin(1,3) = x6;

            GNII = nan(6,3);
            
%             GNII is a system created to choose the tracer which has the 
%             biggest probability to be the current tracer in the next ima-
%             ge. 
%             This score system works choosing in the next image the three 
%             closest tracers to the position of the current tracer in the 
%             current image. 		
%             Obs.: The three tracers chosen have to pass through filters. 
%             If one does not pass, the choice will be made between the 
%             other two, else if only one pass through the filters it will
%             be automatically chosen. In case of none of them pass throu-
%             gh the filters, the system says that the current tracer is 
%             unmatched in the next image (the tracer is no more visible).

            if n <= DifSize + 1            
                GNII(1,1) = FSmin(1,1);            
                GNII(1,2) = FSmin(1,2);
                GNII(1,3) = FSmin(1,3);
            elseif n >= Size2 - DifSize                
                GNII(1,1) = Size2 - (2*DifSize + 1) + FSmin(1,1);
                GNII(1,2) = Size2 - (2*DifSize + 1) + FSmin(1,2);
                GNII(1,3) = Size2 - (2*DifSize + 1) + FSmin(1,3);
            else   
                GNII(1,1) = FSmin(1,1) + (n-(DifSize+1));
                GNII(1,2) = FSmin(1,2) + (n-(DifSize+1));
                GNII(1,3) = FSmin(1,3) + (n-(DifSize+1));
            end

            Ydist(1,1) = (allposXY{2,img+1}(GNII(1,1)) - allposXY{2,img}(n)); %Ydist
            Ydist(1,2) = (allposXY{2,img+1}(GNII(1,2)) - allposXY{2,img}(n)); %Ydist
            Ydist(1,3) = (allposXY{2,img+1}(GNII(1,3)) - allposXY{2,img}(n)); %Ydist

            Xdist(1,1) = (allposXY{1,img+1}(GNII(1,1)) - allposXY{1,img}(n)); %Xdist
            Xdist(1,2) = (allposXY{1,img+1}(GNII(1,2)) - allposXY{1,img}(n)); %Xdist
            Xdist(1,3) = (allposXY{1,img+1}(GNII(1,3)) - allposXY{1,img}(n)); %Xdist

            GNII(6,1) = abs(Xdist(1,1)); % XdistABS
            GNII(6,2) = abs(Xdist(1,2)); % XdistABS
            GNII(6,3) = abs(Xdist(1,3)); % XdistABS

            YdistABS(1,1) = abs(Ydist(1,1));
            YdistABS(1,2) = abs(Ydist(1,2));
            YdistABS(1,3) = abs(Ydist(1,3));

            A = allposXY{2,img}(n);           
            B = allposXY{3,img};

            Area1 = allposXY{4,img}(n); % Area in img

            GNII(2,1) = allposXY{4,img+1}(GNII(1,1));  % Area of GNII(1) in img+1;
            GNII(2,2) = allposXY{4,img+1}(GNII(1,2));  % Area of GNII(2) in img+1;
            GNII(2,3) = allposXY{4,img+1}(GNII(1,3));  % Area of GNII(3) in img+1;

            GNII(3,1) = x1; % Dist
            GNII(3,2) = x2; % Dist
            GNII(3,3) = x3; % Dist

            for gnii = 1:3            
                if GNII(2,gnii) > Area1                    
                    GNII(4,gnii) = Area1/GNII(2,gnii); % Areadiv                    
                else                    
                    GNII(4,gnii) = GNII(2,gnii)/Area1; % Areadiv                    
                end

                GNII(5,gnii) = (GNII(4,gnii))*4;                   
               
                if GNII(3,gnii) >= MD2LF || ((A < B) &&  (Ydist(1,gnii) < -0.5)) ||((A < B) && Ydist(1,gnii)>0.5 && (GNII(6,gnii) >= ...
                   (YdistABS(1,gnii))))|| (Area1 <= 10 && GNII(4,gnii) <= 0.2) || (Area1 > 10 && GNII(4,gnii) < 0.3)                
                   GNII(:,gnii) = nan;                   
                end          
            end                       

            [~,Distmin] = min(GNII(3,:));  % dist min
            GNII(5,Distmin) = GNII(5,Distmin) + 1.5;

            if A < B                 
                [~,Xmin] = min(GNII(6,:)); % XdistABS min                                    
                GNII(5,Xmin) = GNII(5,Xmin) + 1.5;            
            end

            [~,gnimax] = max(GNII(5,:));            
            GNI = GNII(1,gnimax);          % GNI = Grain in the next image

            if size(GNI,2) > 1                 
                testGNI1 = abs((allposXY{1,img+1}(GNI(:,1)) - allposXY{1,img}(n)));
                testGNI2 = abs((allposXY{1,img+1}(GNI(:,2)) - allposXY{1,img}(n)));             

                if testGNI1 - testGNI2 < 0                  
                    GNI = GNI(:,1);                 
                elseif testGNI1 - testGNI2 > 0                  
                    GNI = GNI(:,1);                  
                else                  
                    GNI = GNI(:,2);                  
                end              
            end

            Ydist = Ydist(1,gnimax);
            Xdist = Xdist(1,gnimax);
            YdistABS = abs(Ydist); 

            if allposXY{1,img}(n) > 680 && allposXY{2,img}(n) < 22
                PAIR(n,1) = nan;  
                PAIR(n,2) = NaN;
                PAIR(n,3) = NaN;
                PAIR(n,4) = NaN;
                PAIR(n,5) = NaN;          
                PAIR(n,6) = NaN;          
                PAIR(n,7) = NaN;
                PAIR(n,8) = NaN;
                PAIR(n,9) = NaN;          
                PAIR(n,10) = NaN; 
            elseif isnan(GNI)                
                PAIR(n,1)= n;  
                PAIR(n,2) = NaN;
                PAIR(n,3) = NaN;
                PAIR(n,4) = NaN;
                PAIR(n,5) = allposXY{1,img}(n);                 % X1
                PAIR(n,6) = allposXY{2,img}(n);                 % Y1
                PAIR(n,7) = NaN;
                PAIR(n,8) = NaN;
                PAIR(n,9) = allposXY{4,img}(n);                 % Area 1
                PAIR(n,10) = NaN;
             else
                PAIR(n,1) = n;   
                PAIR(n,2) = GNI;
                PAIR(n,3) = sqrt((allposXY{1,img}(n)-allposXY{1,img+1}(GNI))^2 + ...
                (allposXY{2,img}(n)-allposXY{2,img+1}(GNI))^2); % Distance in pixels
                PAIR(n,4) = ((PAIR(n,3)*P2MM)*frequency);       % Velocity in mm/s
                PAIR(n,5) = allposXY{1,img}(n);                 % X position of the tracer in the current image
                PAIR(n,6) = allposXY{2,img}(n);                 % Y position of the tracer in the current image
                PAIR(n,7) = allposXY{1,img+1}(GNI);             % X position of the tracer in the next image
                PAIR(n,8) = allposXY{2,img+1}(GNI);             % Y position of the tracer in the next image
                PAIR(n,9) = allposXY{4,img}(n);                 % Area of the tracer in the current image
                PAIR(n,10) = allposXY{4,img+1}(GNI);            % Area of the tracer in the next image
            end                   
        end
        pair{1,img}  = PAIR;
    end
    
    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
            ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end       
end

