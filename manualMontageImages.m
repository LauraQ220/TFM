% function montage = manualMontageImages(Data_dir, cols, rows)
clear all; close all; clc;
cols = 2; 
rows = 2;
    
    Data_dir = 'C:\Users\ACER\Documents\ULPGC\TFM\02 CODIGOS\Data\Test_Data_x2_2x2_0x0'; % Data Directory

    Frame_dir = dir(strcat(Data_dir,'\ChannelsMerged'));
    n_frames = length(Frame_dir)-2;
        
    
%    %Loop to read all frames
%     for j = 1:n_frames
%         original_frames(:,:,:,j) = imread([Data_dir '\ChannelsMerged\frame' num2str(j-1) '.tif']);
%     end
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
    montage(original_frames);
    %Paste frames one next to each other

% end