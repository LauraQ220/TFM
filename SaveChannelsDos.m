function SaveChannelsDos(parentFolder, Img, cols, rows, type)
    [height width depth frame] = size(Img);    
    %Create Parent Folder
    if ~exist(parentFolder, 'dir')
        % Folder does not exist so create it.
            mkdir(strcat(parentFolder,'\Channels'));
    end   
    %Loop through bands of the image
    for b=1:depth        
        %Create subFolder for each band/channel
        subFolder = strcat('\Channels\Ch',num2str(b));
        fullpath = strcat(subFolder,subFolder);
        if ~exist(fullpath, 'dir')
            % Folder does not exist so create it.
            mkdir(parentFolder, subFolder);
        end       
        %Loop through each cutted image (frame)
        f=1;
        if type == "serpertine"
            for c=0:cols-1
                for r = 0:rows-1
                    if rem(c,2)==0
                        indice = c*rows+r; %Hacia abajo
                    else
                        indice = (c+1)*rows-(r+1); %Hacia arriba
                    end
                    %Create fileName for each frame
                    fileName = strcat('\frame',num2str(indice),'.tif');           
                    %Save frame in parentFolder/subFolder/fileName
                    imwrite(Img(:,:,b,f), strcat(parentFolder, subFolder,fileName));
                    f=f+1;
                end         
            end
        elseif type == "normal"
            for c=0:cols-1
                for r = 0:rows-1
                    indice = c*rows+r; %Hacia abajo
                    %Create fileName for each frame
                    fileName = strcat('\frame',num2str(indice),'.tif');           
                    %Save frame in parentFolder/subFolder/fileName
                    imwrite(Img(:,:,b,f), strcat(parentFolder, subFolder,fileName));
                    f=f+1;
                end         
            end
        end
    end


end