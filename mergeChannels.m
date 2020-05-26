function mergeChannels(parentFolder)
    
    Channel_dir = struct2cell(dir(strcat(parentFolder,'\Channels\Ch*')));
    Channel_name=Channel_dir(1,:);
    n_channels = length(Channel_name);
    
    Frame_dir = struct2cell(dir(char(strcat(parentFolder,'\Channels\',Channel_name(1),'\frame*'))));
    Frame_name=Frame_dir(1,:);
    n_frames = length(Frame_name);

    mkdir(strcat(parentFolder,'\ChannelsMerged'));

    
    for f = 0:n_frames-1
        for j = 1:n_channels
            mosaics(:,:,j) = imread(strcat(parentFolder,'\Channels\Ch',num2str(j),'\frame',num2str(f),'.tif'));
        end
        imwrite(mosaics, strcat(parentFolder,'\ChannelsMerged\frame',num2str(f),'.tif'));
    end
    fprintf('Finished merging!');
end
