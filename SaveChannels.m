function SaveChannels(parentFolder, Img)
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
        for f=1:frame  
            %Create fileName for each frame
            fileName = strcat('\frame',num2str(f-1),'.tif');           
            %Save frame in parentFolder/subFolder/fileName
            imwrite(Img(:,:,b,f), strcat(parentFolder, subFolder,fileName));
        end
    end


end