% Brief explanation:

% This function generates 4 kinds of graphs to present the results obtained
% with the Eulerian approach.

% All the graphs show the variation of mean spatial and temporal velocities
% over the dune surface.

% Quiver: Vectors show the velocities intensity and preferential direction 

% Countourf: Colors represents the velocities intensity  

% Histogram and PolarHistogram: show how the velocities vary with the dis-
% tance and angle to the dune's centroid 

% *You may have to adjust all the settings of the graphs and mesh

function B_FiguresAndPlots(velocityXY_mean,velX2_mean,velY2_mean,height,width,anglesBoxes,distBoxes)

    try
    
    set(0,'defaulttextinterpreter','latex')    
    set(gca,'FontSize',16)
   
    [malhaH,malhaW]  = size(velocityXY_mean);
    malhaH = (height/malhaH)/10;
    malhaW = (width/malhaW)/10;

    % Generating mesh
    [XX,YY] = meshgrid(1.25:malhaW:78.75,malhaH:malhaH:(height/10));

%    QUIVER ***************************************************************
    
    dir = 'INSERT YOUR DIRECTORY HERE\T(number of your test)_quiver';
    figure,
    quiver(XX,YY,velX2_mean,velY2_mean,1.1);    
    set(gca,'Ydir','reverse')
    set(gca,'FontSize',16)
    xlim([0 80])
    ylim([0 100])
    xticks([0 10 20 30 40 50 60 70 80])
    yticks([0 10 20 30 40 50 60 70 80 90 100])
    xlabel ('x ($mm$)','FontSize',16)
    ylabel ('y ($mm$)','FontSize',16)
    saveas(gcf,strcat(dir), 'epsc');
    saveas(gcf,strcat(dir), 'jpeg');
    
%    CONTOURF *************************************************************

    dir = 'INSERT YOUR DIRECTORY HERE\T(number of your test)_contourf';
    figure,
    contourf(XX,YY,velocityXY_mean);
    colorbar
    title(colorbar,'$\left \langle \bar{v} \right \rangle$ $(mm/s)$','Interpreter','latex','FontSize',16);
    set(gca,'Ydir','reverse')
    set(gca,'FontSize',16)
    xlim([0 80])
    ylim([0 100])
    xticks([0 10 20 30 40 50 60 70 80])
    yticks([0 10 20 30 40 50 60 70 80 90 100])    
    xlabel ('x $(mm)$','FontSize',16)
    ylabel ('y $(mm)$','FontSize',16)
    lim = caxis;
    caxis([0 40])
    saveas(gcf,strcat(dir), 'epsc');
    saveas(gcf,strcat(dir), 'jpeg');
   
%   POLARHISTOGRAM *******************************************************

    dir = 'INSERT YOUR DIRECTORY HERE\T(number of your test)_polarHist';
    figure,
    polarhistogram('BinEdges',anglesBoxes{1,1},'BinCounts',anglesBoxes{2,1})
    set(gca,'FontSize',16)
    saveas(gcf,strcat(dir), 'epsc');
    saveas(gcf,strcat(dir), 'jpeg');

%    HISTOGRAM ************************************************************   

    dir = 'INSERT YOUR DIRECTORY HERE\T(number of your test)_hist';
    figure,
    histogram('BinEdges',distBoxes{1,1},'BinCounts',distBoxes{2,1});
    set(gca,'FontSize',16)
    xlabel('r $(mm)$','FontSize',16)
    ylabel ('$\left \langle \bar{v} \right \rangle$ $(mm/s)$','FontSize',16)   
    xticks([0 10 20 30 40 50])
    yticks([0 5 10 15 20 25 30])
    ylim([0 30])
    xlim([0 50]) 
    saveas(gcf,strcat(dir), 'epsc');
    saveas(gcf,strcat(dir), 'jpeg');
    
    catch ME
        % Some error occurred if you get here.
        errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
            ME.stack(1).name, ME.stack(1).line, ME.message);
        fprintf(1, '%s\n', errorMessage);
        uiwait(warndlg(errorMessage));
    end
end
