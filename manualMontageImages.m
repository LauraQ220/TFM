function mon = manualMontageImages(Data_dir, cols, rows, save, show)
    
    mergeChannels(Data_dir);
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
    
    %Manual stitch
    idx = 1;
    for l = 1:rows
        C = [];
        for n=1:cols
            C= [C original_frames(:,:,:,idx)];
            idx = idx+1;
        end
        filas(:,:,:,l) = C;
    end
    idx2=1;
    mon = [];
    for m=1:rows
        mon = [mon; filas(:,:,:,idx2)];
        idx2 = idx2+1;
    end 
    
    %Paste frames one next to each other
    if save==1
        imwrite(mon, strcat(Data_dir, '\manual_Mosaic.tif'));
    end
    if show==1
        imshow(mon);
    end
    fprintf('\nFinish montage!\n');
end