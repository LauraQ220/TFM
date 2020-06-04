function Montage = insertRectangle(single_test_dir, Montage, FOVD, frames, overlap, cut_Width , cut_Height,save,show)
    
    %Diferent color for each square
    color = {'blue', 'green', 'red', 'cyan', 'magenta', 'black','black', 'white'};
    color_idx = 1;
    %Calculate overlaps
    horizontal_Overlap = overlap; %Number from 0 to 1 
    vertical_Overlap = overlap; %Number from 0 to 1
    [height, width, depth] = size(Montage);

    %Loop para recotar por el eje X
    for x=1:frames
        if x ==1
            horizontal_Coordenates = 0;
        elseif x==frames
            horizontal_Coordenates = width-cut_Width;
        else
            desfaceX = round((cut_Width*(1-horizontal_Overlap)));
            horizontal_Coordenates = horizontal_Coordenates + desfaceX;
        end
        %Loop para recortar por el eje Y (hacia abajo)
        for y=1:1:frames
            if y ==1
                vertical_Coordenates = 0;                 
            elseif y==frames
                vertical_Coordenates = height-cut_Height;        
            else
                desfaceY = round((cut_Height*(1-vertical_Overlap)));
                vertical_Coordenates = vertical_Coordenates + desfaceY;                
            end
            %Recortar imagen
            if (x<=frames)&&(y<=frames)
                Montage = insertShape(Montage,'Rectangle',[horizontal_Coordenates vertical_Coordenates cut_Width cut_Height],'LineWidth',3, 'Color', color(color_idx));
                if color_idx == 8
                    color_idx = 1;
                else
                    color_idx = color_idx +1;
                end
            end
        end
    end



    if save ==1  %Save image   
        imwrite(Montage, strcat(single_test_dir, '\framedMosaic.png'));
    end

    if show ==1 %Show image
        imshow(Montage);
        %Plot title
        sgtitle(strcat('Montage of FOVD: ',num2str(FOVD),'. Overlap in X axis: ',num2str(round(horizontal_Overlap*100)),'% and in Y axis: ',num2str(round(vertical_Overlap*100)),'%'));
    end

end
