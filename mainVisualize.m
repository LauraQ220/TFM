clear all; close all; clc;

%% Insert Parameters
dir_name = 'C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\';
reference = 'RGB';
FOVD = 2; %Field of View Degradation
cte_frame = 2; 
cte_overlap = 0;
if (cte_frame ~= 0) && (cte_overlap == 0) %diferentes overlaps (mismo frame)
    test_name = strcat('Test_Data_',reference,'_x',num2str(FOVD),'_',num2str(cte_frame),'x',num2str(cte_frame));
elseif (cte_frame == 0) && (cte_overlap ~= 0) %diferentes frames (mismo overlap)
    test_name = strcat('Test_Data_',reference,'_x',num2str(FOVD),'_',num2str(cte_overlap),'x',num2str(cte_overlap));
end
load(strcat(dir_name,'Test\',test_name, '.mat'));
% overlap = overlap(1:15);
% frames = frames(1:15);
visualize(dir_name, test_name, reference, overlap, frames, cte_frame, cte_overlap, rmseVal, psnrVal, ssimVal);

