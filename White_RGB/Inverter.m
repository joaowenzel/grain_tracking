% Here is made a manual binarization. In order to get a better tracer iden-
% tification is possible to adjust your own binarization threshold, by 
% changing the variable "Level".

function [inverter] = Inverter(I)

    Igray = rgb2gray(I);

    Icomp = imcomplement(Igray);

    IClearBorder = imclearborder(Icomp);

    Threshold = graythresh(IClearBorder);
    
    Level = 1.6;

    [m,n] = size(IClearBorder);

    Ibin = ones(m,n);    

    for i = 1:m
        for j = 1:n
            if (IClearBorder(i,j) > Threshold*Level*256)
                Ibin(i,j) = 1;    
            else
                Ibin(i,j) = 0;
            end        
        end
    end

    I255 = Ibin*255;
    inverter = uint8(I255);

end
