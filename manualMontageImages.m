function mon = manualMontageImages(Data_dir, cols, rows)
   
    Frame_dir = dir(strcat(Data_dir,'\ChannelsMerged'));
    n_frames = length(Frame_dir)-2;
        
    f = 1;
    for r=0:rows-1
            for c = 0:cols-1
                if rem(c,2)==0
                    indice = c*rows+r; %Hacia abajo
                else
                    indice = (c+1)*rows-(r+1); %Hacia arriba
                end
                %Read frames in proper order
                original_frames(:,:,:,f) = imread([Data_dir '\ChannelsMerged\frame' num2str(indice) '.tif']);
                f=f+1;
            end         
    end
    
    %Paste frames one next to each other
    mon = montage(original_frames);

end