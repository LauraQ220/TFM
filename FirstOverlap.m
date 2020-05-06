clear all; close all; clc;

%% Import data

Data_dir = dir('C:\Users\ACER\Documents\ULPGC\TFM\02 CODIGOS\Data');
Data_name=Data_dir(3).name;
ground_Truth = imread(strcat('Data\Reference\',char(Data_name)));

%%Define values
FOVD = 1.06; %Magnification of the microscope
[gT_height, gT_width, gT_depth] = size(ground_Truth);

error_pixels = 8;
error_percentajeX = 0.008;
error_percentajeY = 0.01;
error_percentaje = error_percentajeY;

%ceil(X) rounds each element of X to the nearest integer greater than or equal to that element.
min_cuts = ceil((error_percentaje-FOVD)/(error_percentaje-1)); %Nos acoplamos a lo más restrictivo
max_cuts = ceil((0.94-FOVD)/0.94-1); %94% es lo que usaron la gente del paper

% for c= min_cuts:max_cuts
    c=2;
    overlap = (c-FOVD)/(c-1); %Same for both X and Y
    fprintf('The overlap percentaje for magnitud x%.2f in X axis is %.2f %% and in Y axis is %.2f %%\n',FOVD,overlap*100,overlap*100);
    dir= strcat('Data\Test_Data_x',num2str(FOVD),'_',num2str(c),'x',num2str(c),'_',num2str(overlap,2),'x',num2str(overlap,2));


    
    
    %1. Cut Image(Data_dir, ground_Truth, magnification, horizontal_Cuts, vertical_Cuts,error_pixels, save,show)
     CutImage(dir, ground_Truth, FOVD, c, c,0,1,0);
    
    %2. Stitch algorithm
     Montage = montageImages(dir);
    Montage8Bit = uint8(255 * mat2gray(Montage));
    
     %3. Metric function
    %3.1. Cut Borders
    %noBorderImage = removeBorder(dir, ground_Truth, xoverlap, yoverlap, save,show)
    
    [nB_ground_Truth, nB_Montage] = removeBorder(dir, ground_Truth, Montage8Bit, overlap, overlap, 1,0);

    %3.2.Apply Metrics
    rmseVal = sqrt(immse (nB_Montage, nB_ground_Truth)) %1.RMSE
    psnrVal = psnr(nB_Montage, nB_ground_Truth)%2.PSNR
    ssimVal = ssim(nB_Montage,nB_ground_Truth) %3.SSIM
%     ergasVal = ergas(nB_Montage,nB_ground_Truth) %4.ERGAS
    samVal = sam(nB_Montage,nB_ground_Truth)%5.SAM
    
% end

fprintf('\nEnd of Test Bench');
