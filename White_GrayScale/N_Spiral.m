% Brief Explanation

% This function reorders all the variables in a spiral order, which begins
% in the center of the image (where the centroid of the dune is plotted). 
% It is useful to generate graphs and to determine the distance and the an-
% gle of the elements of mesh (and its values) related to the dune's 
% centroid.

function[velMeanOrderX,velMeanOrderY,StdVelOrderX,StdVelOrderY,velXYmeanOrder,VELXYmeanOrder,STDVELXYOrder,NewLabel,Spi] = Spiral(mesh,velX_mean,velY_mean,StdVelX,StdVelY,velocityXY_mean,VELOCITYXY_mean,STDVELXY,P2MM)
    
    if mesh == 25        
        L = 1;
        C = 1;
        rows = 41;
        NewLabel = nan(41,32);       
        for i = 1:1312
            NewLabel(L,C) = i;
            if i == (1312/rows)*L
                L = L+1; 
                C = 1;
            else
                C = C+1;
            end
        end

        % Spiral for mesh = 25

        AddRowAb1 = 1025:1056;
        AddRowAb2 = 1089:1120;
        AddRowAb3 = 1153:1184;
        AddRowAb4 = 1217:1248;
        AddROWAB = [AddRowAb4; AddRowAb3; AddRowAb2; AddRowAb1];

        AddRowDown1 = fliplr(1057:1088);
        AddRowDown2 = fliplr(1121:1152);
        AddRowDown3 = fliplr(1185:1216);
        AddRowDown4 = fliplr(1249:1280);
        AddRowDown5 = 1281:1312;
        AddROWDN = [AddRowDown1; AddRowDown2; AddRowDown3; AddRowDown4; AddRowDown5];

        Spi = spiral(32); %Spiral
        Spi = [AddROWAB; Spi; AddROWDN]; %Spiral with more Rows (Same N° of rows & columns of comp_mean and StdDist)
        velMeanOrderX = nan(1312,3); % distX_mean (X distance) in Spiral order 
        [x1,y1] = find(Spi==1);
        
        for n = 1:1312 % 1312 = 1312 elements (41 rows * 32 columns)
            [x,y] = find(Spi==n);
            velMeanOrderX(n,3) = velX_mean(x,y);
            
            X = x1-x;
            Y = y1-y;
            
            OpLeg = (abs(X+0.5))*mesh*P2MM;
            AdLeg = (abs(Y+0.5))*mesh*P2MM;
            Hip = (sqrt(OpLeg^2+AdLeg^2));            
            seno = OpLeg/Hip;
            theta = asind(seno);
            
            if X >= 0 && Y >= 0                
                theta = (90-theta)+90;                                
            elseif X < 0 && Y < 0                
                theta = 180 + theta;                
            elseif X < 0 && Y >= 0                
                theta = (90-theta)+270;                
            end                         
           
            velMeanOrderX(n,1) = theta;
            velMeanOrderX(n,2) = Hip;
        end

        velMeanOrderY = nan(1312,1); % distY_mean (Y distance) in spiral order

        for n = 1:1312 % 1312 = 1312 elements (41 rows * 32 columns)
            [x,y] = find(Spi==n);
            velMeanOrderY(n,1) = velY_mean(x,y);
        end
                
        StdVelOrderX = nan(1312,1); % Standard Deviation in X direction in spiral order

        for n = 1:1312 % 1312 = 1312 elements (41 rows * 32 columns)
            [x,y] = find(Spi==n);
            StdVelOrderX(n,1) = StdVelX(x,y);
        end
                
        StdVelOrderY = nan(1312,1); % Standard Deviation in Y direction in spiral order

        for n = 1:1312 % 1312 = 1312 elements (41 rows * 32 columns)
            [x,y] = find(Spi==n);
            StdVelOrderY(n,1) = StdVelY(x,y);
        end
                  
        velXYmeanOrder = nan(1312,1);

        for n = 1:1312 % 1312 = 1312 elements (41 rows * 32 columns)
            [x,y] = find(Spi==n);
            velXYmeanOrder(n,1) = velocityXY_mean(x,y);
        end
                
        VELXYmeanOrder = nan(1312,1); 

        for n = 1:1312 % 1312 = 1312 elements (41 rows * 32 columns)
            [x,y] = find(Spi==n);
            VELXYmeanOrder(n,1) = VELOCITYXY_mean(x,y);
        end               
        
        STDVELXYOrder = nan(1312,1); 

        for n = 1:1312 % 1312 = 1312 elements (41 rows * 32 columns)
            [x,y] = find(Spi==n);
            STDVELXYOrder(n,1) = STDVELXY(x,y);
        end 

        
    elseif mesh == 35.5823        
        L = 1;
        C = 1;
        rows = 46;
        NewLabel = nan(46,34);   
        
        for i = 1:1564
            NewLabel(L,C) = i;
            if i == (1564/rows)*L
                L = L+1; 
                C = 1;
            else
                C = C+1;
            end
        end

        AddRowAb1 = 1157:1190;
        AddRowAb2 = 1225:1258;
        AddRowAb3 = 1293:1326;
        AddRowAb4 = 1361:1394;
        AddRowAb5 = 1429:1462;
        AddRowAb6 = 1497:1530;
        AddROWAB = [AddRowAb6; AddRowAb5; AddRowAb4; AddRowAb3; AddRowAb2; AddRowAb1];

        AddRowDown1 = fliplr(1191:1224);
        AddRowDown2 = fliplr(1259:1292);
        AddRowDown3 = fliplr(1327:1360);
        AddRowDown4 = fliplr(1395:1428);
        AddRowDown5 = fliplr(1463:1496);
        AddRowDown6 = fliplr(1531:1564);
        AddROWDN = [AddRowDown1; AddRowDown2; AddRowDown3; AddRowDown4; AddRowDown5; AddRowDown6];

        Spi = spiral(34); %Spiral
        
        Spi = [AddROWAB; Spi; AddROWDN]; %Spiral with more Rows (Same N° of rows & columns of comp_mean and StdDist)        
        velMeanOrderX = nan(1564,3); % distX_mean (X distance) in Spiral order 
        [x1,y1] = find(Spi==1);
        
        for n = 1:1564 % 1564 = 1564 elements (46 rows * 34 columns)
            [x,y] = find(Spi==n);
            velMeanOrderX(n,3) = velX_mean(x,y);      
            
            X = x1-x;
            Y = y1-y;
            
            OpLeg = (abs(X+0.5))*mesh*P2MM;
            AdLeg = (abs(Y+0.5))*mesh*P2MM;
            Hip = (sqrt(OpLeg^2+AdLeg^2));            
            seno = OpLeg/Hip;
            theta = asind(seno);
            
            if X >= 0 && Y >= 0                
                theta = (90-theta)+90;                               
            elseif X < 0 && Y < 0                
                theta = 180 + theta;               
            elseif X < 0 && Y >= 0                
                theta = (90-theta)+270;               
            end                         
            
            velMeanOrderX(n,1) = theta;
            velMeanOrderX(n,2) = Hip;
        end

        velMeanOrderY = nan(1564,1); % distY_mean (Y distance) in spiral order

        for n = 1:1564 % 1564 = 1564 elements (46 rows * 34 columns)
            [x,y] = find(Spi==n);
            velMeanOrderY(n,1) = velY_mean(x,y);
        end
                
        StdVelOrderX = nan(1564,1); % Standard Deviation in X direction in spiral order

        for n = 1:1564 % 1564 = 1564 elements (46 rows * 34 columns)
            [x,y] = find(Spi==n);
            StdVelOrderX(n,1) = StdVelX(x,y);
        end
                
        StdVelOrderY = nan(1564,1); % Standard Deviation in Y direction in spiral order

        for n = 1:1564 % 1564 = 1564 elements (46 rows * 34 columns)
            [x,y] = find(Spi==n);
            StdVelOrderY(n,1) = StdVelY(x,y);
        end
                  
        velXYmeanOrder = nan(1564,1);

        for n = 1:1564 % 1564 = 1564 elements (46 rows * 34 columns)
            [x,y] = find(Spi==n);
            velXYmeanOrder(n,1) = velocityXY_mean(x,y);
        end
                
        VELXYmeanOrder = nan(1564,1); 

        for n = 1:1564 % 1564 = 1564 elements (46 rows * 34 columns)         
            [x,y] = find(Spi==n);
            VELXYmeanOrder(n,1) = VELOCITYXY_mean(x,y);
        end               
        
        STDVELXYOrder = nan(1564,1); 

        for n = 1:1564 % 1564 = 1564 elements (46 rows * 34 columns)
            [x,y] = find(Spi==n);           
            STDVELXYOrder(n,1) = STDVELXY(x,y);
        end 

        
    elseif mesh == 50
        
        L = 1;
        C = 1;
        rows = 20;
        NewLabel = nan(20,16);

        for i = 1:320
            NewLabel(L,C) = i;
            if i == (320/rows)*L
                L = L+1; 
                C = 1;
            else
                C = C+1;
            end
        end

        AddRowAb1 = 257:272;
        AddRowAb2 = 289:304;    
        AddROWAB = [AddRowAb2; AddRowAb1];

        AddRowDown1 = fliplr(273:288);
        AddRowDown2 = fliplr(305:320);
        AddROWDN = [AddRowDown1; AddRowDown2];
        
        Spi = spiral(16); %Spiral
        Spi = [AddROWAB; Spi; AddROWDN]; %Spiral with more Rows (Same N° of rows & columns of comp_mean and StdDist)
        velMeanOrderX = nan(320,3); % velX_mean (X Velocity) in spiral order 
        [x1,y1] = find(Spi==1);
            
        for n = 1:320 % 320 = 320 elements (20 rows * 16 columns)                        
            [x,y] = find(Spi==n);
            velMeanOrderX(n,3) = velX_mean(x,y);            
            X = x1-x;
            Y = y1-y;
            OpLeg = (abs(X+0.5))*mesh*P2MM;
            AdLeg = (abs(Y+0.5))*mesh*P2MM;
            Hip = (sqrt(OpLeg^2+AdLeg^2));
            seno = OpLeg/Hip;
            theta = asind(seno);
            
            if X >= 0 && Y >= 0                
                theta = (90-theta)+90;                                
            elseif X < 0 && Y < 0                
                theta = (90-theta)+270;                
            elseif X < 0 && Y >= 0                
                theta = 180 + theta;                
            end                         
            
            velMeanOrderX(n,1) = theta;
            velMeanOrderX(n,2) = Hip;
        end

        velMeanOrderY = nan(320,1); % distY_mean (Y distance) in spiral order

        for n = 1:320 % 320 = 320 elements (20 rows * 16 columns)
            [x,y] = find(Spi==n);
            velMeanOrderY(n,1) = velY_mean(x,y);
        end

        StdVelOrderX = nan(320,1); % Standard Deviation in X direction in spiral order

        for n = 1:320 % 320 = 320 elements (20 rows * 16 columns)
            [x,y] = find(Spi==n);
            StdVelOrderX(n,1) = StdVelX(x,y);
        end

        StdVelOrderY = nan(320,1); % Standard Deviation in Y direction in spiral order

        for n = 1:320 % 320 = 320 elements (20 rows * 16 columns)
            [x,y] = find(Spi==n);
            StdVelOrderY(n,1) = StdVelY(x,y);
        end

        velXYmeanOrder = nan(320,1);

        for n = 1:320 % 320 = 320 elements (20 rows * 16 columns)
            [x,y] = find(Spi==n);
            velXYmeanOrder(n,1) = velocityXY_mean(x,y);
        end

        VELXYmeanOrder = nan(320,1); 

        for n = 1:320 % 320 = 320 elements (20 rows * 16 columns)
            [x,y] = find(Spi==n);
            VELXYmeanOrder(n,1) = VELOCITYXY_mean(x,y);
        end

        STDVELXYOrder = nan(320,1); 

        for n = 1:320 % 320 = 320 elements (20 rows * 16 columns)
            [x,y] = find(Spi==n);
            STDVELXYOrder(n,1) = STDVELXY(x,y);
        end       
    else
        
        L = 1;
        C = 1;
        rows = 10;
        NewLabel = nan(10,8);

        for i = 1:80
            NewLabel(L,C) = i;
            if i == (80/rows)*L
                L = L+1; 
                C = 1;
            else
                C = C+1;
            end
        end

        % mesh == 100 
        % Spiral for mesh = 100

        AddRowAb = 65:72;
        AddRowDown = fliplr(73:80);
        Spi = spiral(8); %Spiral
        Spi = [AddRowAb; Spi; AddRowDown]; %Spiral with more Rows (Same N° of rows & columns of comp_mean and StdDist)
        velMeanOrderX = nan(80,3); % velX_mean (X velocity) in spiral order 
        [x1,y1] = find(Spi==1);
        
        for n = 1:80 % 80 = 80 elements (10 rows * 8 columns)
            [x,y] = find(Spi==n);
            velMeanOrderX(n,3) = velX_mean(x,y);            
            X = x1-x;
            Y = y1-y;            
            OpLeg = (abs(X+0.5))*mesh*P2MM;
            AdLeg = (abs(Y+0.5))*mesh*P2MM;
            Hip = (sqrt(OpLeg^2+AdLeg^2));
            seno = OpLeg/Hip;
            theta = asind(seno);
            
            if X >= 0 && Y >= 0                
                theta = (90-theta)+90;                                
            elseif X < 0 && Y < 0                
                theta = 180 + theta;                
            elseif X < 0 && Y >= 0                
                theta = (90-theta)+270;                
            end                                     
            
            velMeanOrderX(n,1) = theta;
            velMeanOrderX(n,2) = Hip;
        end

        velMeanOrderY = nan(80,1); % distY_mean (Y distance) in spiral order

        for n = 1:80 % 80 = 80 elements (10 rows * 8 columns)
            [x,y] = find(Spi==n);
            velMeanOrderY(n,1) = velY_mean(x,y);
        end

        StdVelOrderX = nan(80,1); % Standard Deviation in X direction in spiral order

        for n = 1:80  % 80 = 80 elements (10 rows * 8 columns)
            [x,y] = find(Spi==n);
            StdVelOrderX(n,1) = StdVelX(x,y);
        end

        StdVelOrderY = nan(80,1); % Standard Deviation in Y direction in spiral order

        for n = 1:80  % 80 = 80 elements (10 rows * 8 columns)
            [x,y] = find(Spi==n);
            StdVelOrderY(n,1) = StdVelY(x,y);
        end

        velXYmeanOrder = nan(80,1);

        for n = 1:80  % 80 = 80 elements (10 rows * 8 columns)
            [x,y] = find(Spi==n);
            velXYmeanOrder(n,1) = velocityXY_mean(x,y);
        end

        VELXYmeanOrder = nan(80,1); 

        for n = 1:80  % 80 = 80 elements (10 rows * 8 columns)
            [x,y] = find(Spi==n);
             VELXYmeanOrder(n,1) = VELOCITYXY_mean(x,y);
        end

        STDVELXYOrder = nan(80,1); 

        for n = 1:80  % 80 = 80 elements (10 rows * 8 columns)
            [x,y] = find(Spi==n);
            STDVELXYOrder(n,1) = STDVELXY(x,y);
        end
    end
end
