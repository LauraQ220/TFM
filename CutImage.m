function CutImage(dir, ground_Truth, FOVD, horizontal_Cuts, vertical_Cuts,error_pixels, save,show)
    
    %Calculate overlaps
    horizontal_Overlap = (horizontal_Cuts-FOVD)/(horizontal_Cuts-1); %Number from 0 to 1 
    vertical_Overlap = (vertical_Cuts-FOVD)/(vertical_Cuts-1); %Number from 0 to 1
    %fprintf('The overlap percentaje in X axis is %.f %% and in Y axis is %.0f %%\n',horizontal_Overlap*100,vertical_Overlap*100);
    
    if (horizontal_Cuts>=FOVD)&&(vertical_Cuts>=FOVD)&&(FOVD<=100)
         
        [gT_height, gT_width, gT_depth] = size(ground_Truth);
        cut_Height = round(gT_height/FOVD)-1;
        cut_Width = cut_Height;
%         cut_Width = round(gT_width/FOVD)-1;

        
        indice = 1;
        %Loop para recotar por el eje Y
        for y=1:vertical_Cuts
            if y ==1
                vertical_Coordenates = 1;
            elseif y==vertical_Cuts
                vertical_Coordenates = gT_height-cut_Height;
            else
                desfaceY = round((cut_Height*(1-vertical_Overlap)));
                vertical_Coordenates = vertical_Coordenates + desfaceY + round(2*error_pixels.*rand(1,1) - error_pixels);
            end

            %Loop para recortar por el eje X
            for x=1:horizontal_Cuts
                if x ==1
                    horizontal_Coordenates = 1;                 
                elseif x==horizontal_Cuts
                    horizontal_Coordenates = gT_width-cut_Width;        
                else
                    desfaceX = round((cut_Width*(1-horizontal_Overlap)));
                    horizontal_Coordenates = horizontal_Coordenates + desfaceX + round(2*error_pixels.*rand(1,1) - error_pixels);                
                end
                               
                %Recortar imagen
                image = imcrop(ground_Truth,[horizontal_Coordenates vertical_Coordenates cut_Width cut_Height]);
%                 [height width depth] = size(image);
                image_Array(:,:,:,indice) = image;
                indice = indice +1;
            end
        end
        

        if save ==1  %Save image 
            SaveChannelsDos(dir,image_Array,vertical_Cuts,horizontal_Cuts);
        end
        
        if show ==1 %Show image
            for i=1:(indice-1)
                subplot(vertical_Cuts,horizontal_Cuts,i)
                imagesc(image_Array(:,:,:,i));
                xticks([]) %Remove x axis
                yticks([])%Remove y axis
            end
            %Plot title
            sgtitle(strcat('FOV Degradation: ',num2str(FOVD),'. Overlap: ',num2str(round(horizontal_Overlap*100))));
%             sgtitle(strcat('FOV Degradation: ',num2str(FOVD),'. Overlap in X axis: ',num2str(round(horizontal_Overlap*100)),'% and in Y axis: ',num2str(round(vertical_Overlap*100)),'%'));
        end
       
    elseif (FOVD>100)
        fprintf('La magnificación es mayor que 100 --> limitación dada por el paso mas pequeño que puede dar la plataforma\n');
    
    else
        fprintf('El numero de cortes en el eje X o Y es menor que la magnificacion --> no habrá suficiente imagenes para recomponer la original\n');
    end
    fprintf('Trimming Finished!\n');
end