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

    function N_FiguresAndPlots(velocityXY_mean,velX2_mean,velY2_mean,height,width,anglesBoxes,distBoxes)

        try

        set(0,'defaulttextinterpreter','latex')
        set(gca,'FontSize',16)

        [malhaH,malhaW]  = size(velocityXY_mean);
        malhaH = (height/malhaH)*0.06976138032;
        malhaW = (width/malhaW)*0.06976138032;
        malhaWdiv = malhaW/2;
        limHmm = 114.2;

        % Generating mesh
        [XX,YY] = meshgrid(malhaWdiv:malhaW:84.27,malhaH:malhaH:limHmm);

    %    QUIVER ***************************************************************

        dir = 'INSERT YOUR DIRECTORY HERE\T(number of your test)_quiver';
        figure,
        quiver(XX,YY,velX2_mean,velY2_mean,1.1);
        set(gca,'Ydir','reverse')
        set(gca,'FontSize',16)
        xlim([2.135 82.135]);
        ylim([0 110]);
        xticks([2.135 12.135 22.135 32.135 42.135 52.135 62.135 72.135 82.135])    
        xticklabels({'0','10','20','30','40','50','60','70','80'})
        yticks([0 10 20 30 40 50 60 70 80 90 100 110])
        yticklabels({'0','10','20','30','40','50','60','70','80','90','100','110'})
        xlabel('x')
        ylabel('y')
        saveas(gcf,strcat(dir), 'epsc');
        saveas(gcf,strcat(dir), 'jpeg');

    %    CONTOURF *************************************************************

        dir = 'INSERT YOUR DIRECTORY HERE\T(number of your test)_contourf';
        contourf(XX,YY,velocityXY_mean);
        set(gca,'FontSize',16)
        set(gca,'Ydir','reverse')
        colorbar
        xlim([2.135 82.135]);
        ylim([0 110]);
        xticks([2.135 12.135 22.135 32.135 42.135 52.135 62.135 72.135 82.135])    
        xticklabels({'0','10','20','30','40','50','60','70','80'})
        yticks([0 10 20 30 40 50 60 70 80 90 100 110])
        yticklabels({'0','10','20','30','40','50','60','70','80','90','100','110'})
        lim = caxis;
        caxis([0 30])
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
        ylim([0 50])
        xlabel('x')
        ylabel('y')
        xticks([0 10 20 30 40 50])
        yticks([0 10 20 30 40 50])
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
