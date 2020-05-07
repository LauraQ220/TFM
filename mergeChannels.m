function mergeChannels(parentFolder)
    
    Channel_dir = struct2cell(dir(strcat(parentFolder,'\Ch*')));
    Channel_name=Channel_dir(1,:);
    n_channels = length(Channel_name);
    
    Frame_dir = struct2cell(dir(char(strcat(parentFolder,'\',Channel_name(3),'\frame*'))));
    n_frames = length(Frame_dir);

    mkdir(strcat(parentFolder,'\ChM'));

    
    for f = 0:n_frames-1
        for j = 1:n_channels
            mosaics(:,:,j) = imread(strcat(parentFolder,'\Ch',num2str(j),'\frame',num2str(f),'.tif'));
        end
        imwrite(mosaics, strcat(parentFolder,'\ChM\frame',num2str(f),'.tif'));
    end
    fprintf('Finished merging!');
end
