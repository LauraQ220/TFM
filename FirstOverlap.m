clear all; close all; clc;

%% Import data

Data_dir = dir('C:\Users\ACER\Documents\ULPGC\TFM\02 CODIGOS\Data\Reference');
ground_Truth = imread(strcat('C:\Users\ACER\Documents\ULPGC\TFM\02 CODIGOS\Data\Reference\',char(Data_dir(3).name)));
[gT_height, gT_width, gT_depth] = size(ground_Truth);

%%Define values
FOVD = 2; %Field of View Degradation
error_pixels = 8; %Error in pixels for magnification 20x
error_percentajeX = 0.008; %Error percentaje in X axis for magnification 20x
error_percentajeY = 0.01; %Error percentaje in Y axis for magnification 20x
error_percentaje = error_percentajeY; %Most restrictive one

%ceil(a) rounds each element a to the nearest integer >= than element a.
min_cuts = ceil((error_percentaje-FOVD)/(error_percentaje-1)); %El error marca el minimo solape
max_cuts = ceil((0.94-FOVD)/(0.94-1)); %94% es lo que usaron la gente del paper y tratamos de disminuir

% for c= min_cuts:max_cuts
    c=18;
    i=1;

    fprintf('\n\n\nCut number %d\n',c);
    i = c-min_cuts+1;
    overlap(i) = (c-FOVD)/(c-1); %Same for both X and Y
    fprintf('The overlap percentaje for magnitud %.0fx in X axis is %.2f %% and in Y axis is %.2f %%\n',FOVD,overlap(i)*100,overlap(i)*100);
    dir= strcat('C:\Users\ACER\Documents\ULPGC\TFM\02 CODIGOS\Data\Test_Data_x',num2str(FOVD),'_',num2str(c),'x',num2str(c),'_',num2str(overlap(i),2),'x',num2str(overlap(i),2));

    %1. Cut Image(Data_dir, ground_Truth, FOVD, horizontal_Cuts, vertical_Cuts,error_pixels, save,show)
     CutImage(dir, ground_Truth, FOVD, c, c,0,1,0);
%      mergeChannels(dir);

    %2. Stitch algorithm
    option = 2;%1: first stich rows and then cols; 2: everything together
    if option ==1
        final_Montage = montageRowCol(dir,c,gT_depth); 
    elseif option ==2
        final_Montage = montageImages(dir);
    end
    Montage8Bit = uint8(255 * mat2gray(final_Montage));%From double to uint8
    
     %3. Metric function
    %3.1. Cut Borders
    %noBorderImage = removeBorder(dir, ground_Truth, mosaic, xoverlap, yoverlap, save,show)
    
    [nB_ground_Truth, nB_Montage] = removeBorder(dir, ground_Truth, Montage8Bit, overlap(i), overlap(i), 1,0);

    %3.2.Apply Metrics
    rmseVal(i) = sqrt(immse (nB_Montage, nB_ground_Truth)); %1.RMSE
    fprintf('RMSE = %.2f (The lower de better)\n',rmseVal(i));
    psnrVal(i) = psnr(nB_Montage, nB_ground_Truth);%2.PSNR
    fprintf('PSNR = %.2f (The higher de better)\n',psnrVal(i));
    ssimVal(i) = ssim(nB_Montage,nB_ground_Truth); %3.SSIM
    fprintf('SSIM = %.2f (0: no correlation, 1:equal images)\n',ssimVal(i));
%     ergasVal(i) = ergas(nB_Montage,nB_ground_Truth); %4.ERGAS
%     fprintf('ERGAS = %.2f (The lower de better)\n',ergasVal(i));
%     samVal(i) = sam(nB_Montage,nB_ground_Truth);%5.SAM
%     fprintf('SAM = %.2f (The lower de better)\n',samVal(i));
    
% end

% subplot(1,3,1);
% plot(overlap, rmseVal);
% title('Overlap vs RMSE');
% xlabel('Overlap');
% ylabel('RMSE');
% subplot(1,3,2);
% plot(overlap, psnrVal);
% title('Overlap vs PSNR');
% xlabel('Overlap');
% ylabel('PSNR');
% subplot(1,3,3);
% plot(overlap, ssimVal);
% title('Overlap vs SSIM');
% xlabel('Overlap');
% ylabel('SSIM');

fprintf('\nEnd of Test Bench');
