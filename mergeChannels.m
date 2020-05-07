% function mergeChannels(parentFolder)
clear all; close all; clc;
    
parentFolder= strcat('C:\Users\ACER\Documents\ULPGC\TFM\02 CODIGOS\TFM.git\Data\Test_Data_x4_4x4_0x0');

    Channel_dir = struct2cell(dir(strcat(parentFolder,'\Ch*')));
    Channel_name=Channel_dir(1,:);
    n_channels = length(Channel_name);
    
    Frame_dir = struct2cell(dir(char(strcat(parentFolder,'\',Channel_name(3),'\frame*'))));
    n_frames = length(Frame_dir);

    
    for f = 0:n_frames-1
        for j = 1:n_channels
            mosaics(:,:,j) = imread(strcat(parentFolder,'\Ch',num2str(j),'\frame',num2str(f),'.tif'));
        end
%         image(mosaics);
        imwrite(mosaics, strcat(parentFolder,'\ChM\frame',num2str(f),'.tif'));
    end
    fprintf('Finished merging!');
% end
