function [nB_ground_Truth, nB_Montage] = removeBorder(dir, ground_Truth, Montage, xoverlap, yoverlap, save,show)
    
    %Calculate parameters 
    [gT_height, gT_width, gT_depth] = size(ground_Truth);
    gT_cut_width = round(gT_width*xoverlap);
    gT_cut_height = round(gT_height*yoverlap);
    [m_height, m_width, m_depth] = size(Montage);
    
    %Ground Truth without border (1-overlap) has to be smaller than
    %montage image
    if (m_width>=gT_cut_width) &&(m_height>=gT_cut_height) 

        %Ground Truth
        gT_horizontal_Coordenates = round((gT_width - gT_cut_width)/2);
        gT_vertical_Coordenates = round((gT_height - gT_cut_height)/2);
        nB_ground_Truth = imcrop(ground_Truth,[gT_horizontal_Coordenates gT_vertical_Coordenates gT_cut_width gT_cut_height]);


        %Montage
        m_horizontal_Coordenates = round((m_width - gT_cut_width)/2);
        m_vertical_Coordenates = round((m_height - gT_cut_height)/2);
        nB_Montage = imcrop(Montage,[m_horizontal_Coordenates m_vertical_Coordenates gT_cut_width gT_cut_height]);


    else
        nB_ground_Truth = 0;
        nB_Montage = 0;
        fprintf('Montage smaller than Ground Thruth');
    end


    
    if save ==1  %Save image 
        imwrite(nB_ground_Truth, strcat(dir,'\noBorderGroundTruth.png'));
        imwrite(nB_Montage, strcat(dir,'\noBorderMosaic.png'));
    end
        
    if show ==1 %Show image
        imagesc(nB_ground_Truth);
        xticks([]) %Remove x axis
        yticks([])%Remove y axis
        %Plot title
        sgtitle(strcat('Reference Image without Border: ',num2str(xoverlap),'x',num2str(yoverlap)));
    end

end