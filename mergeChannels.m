function mergeChannels(parentFolder)

    Channel_dir = dir(parentFolder);
    Channel_name=Channel_dir.name;
    n_channels = length(Channel_name) - 2;
    
    Frame_dir = dir(parentFolder);
    Frame_name = Frame_dir.name;
    n_frames = length(Frame_name) - 2;
    
    for f = 1:n_frames
        for j = 1:n_channels
            mosaics(:,:,j) = imread(strcat(parentFolder,'\',Channel_name(f)+2,'\',Frame_name(f)+2));
        end
        imwrite(mosaics, strcat(parentFolder,'\ChM\',Frame_name(f)+2));
    end
end
