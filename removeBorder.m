function [nB_ground_Truth, nB_Montage] = removeBorder(dir, ground_Truth, Montage, guardar, xoverlap, yoverlap, save,show)
    
    %Calculate parameters 
    [gT_height, gT_width, gT_depth] = size(ground_Truth);

%     gT_cut_width = ceil(gT_width*xoverlap);
%     gT_cut_height = ceil(gT_height*yoverlap);
%     gT_cut_width = 431;
%     gT_cut_height = 738;
    [m_height, m_width, m_depth] = size(Montage);
%     gT_cut_width = ceil(guardar*m_width-((guardar-1)*xoverlap));
%     gT_cut_height = ceil(guardar*m_height-((guardar-1)*yoverlap));
    gT_cut_width = m_width;
    gT_cut_height = m_height;
    
    %Ground Truth without border (overlap) has to be smaller than
    %montage image
    if (m_width>=gT_cut_width) &&(m_height>=gT_cut_height) &&(gT_depth==m_depth)
        for c = 1:gT_depth
            %Ground Truth
    %         gT_horizontal_Coordenates = ceil((gT_width - gT_cut_width)/2);
    %         gT_vertical_Coordenates = ceil((gT_height - gT_cut_height)/2);
            gT_horizontal_Coordenates = 0;
            gT_vertical_Coordenates = 0;
            nB_ground_Truth(:,:,c) = imcrop(ground_Truth(:,:,c),[gT_horizontal_Coordenates gT_vertical_Coordenates gT_cut_width gT_cut_height]);


            %Montage
            m_horizontal_Coordenates = ceil((m_width - gT_cut_width)/2);
            m_vertical_Coordenates = ceil((m_height - gT_cut_height)/2);
            nB_Montage(:,:,c) = imcrop(Montage(:,:,c),[m_horizontal_Coordenates m_vertical_Coordenates gT_cut_width gT_cut_height]);
        end


    else
        nB_ground_Truth = 0;
        nB_Montage = 0;
        fprintf('Montage smaller than Ground Thruth\n');
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
    fprintf('Borders Removed!\n');

end