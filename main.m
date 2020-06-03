clear all; close all; clc;
%% Import data

dir_name = 'C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\';
Data_dir = dir(dir_name);
% ground_Truth = imread(strcat('C:\Users\ACER\Documents\ULPGC\TFM\02 CODIGOS\Data\Reference\',char(Data_dir(3).name)));
reference = 'RGB';
ground_Truth1 = (load(strcat(dir_name,'Reference\',reference, '.mat')));
ground_Truth = ground_Truth1.image;
[gT_height, gT_width, gT_depth] = size(ground_Truth);

%% Select bands
% bands = 10;
% idx=1;
% for j=1:round(275/bands):275
%     w(idx) = j;
%     I(:,:,idx) = imcrop(image(:,:,w(idx)),[0 0 800 800]);
%     idx =idx+1;
% end

%% Define initial values
FOVD = 4; %Field of View Degradation
error_pixels = 8; %Error in pixels for magnification 20x
error_percentajeX = 0.008; %Error percentaje in X axis for magnification 20x
error_percentajeY = 0.01; %Error percentaje in Y axis for magnification 20x
error_percentaje = error_percentajeY; %Most restrictive one

%ceil(a) rounds each element a to the nearest integer >= than element a.
min_cuts = ceil((error_percentaje-FOVD)/(error_percentaje-1)); %El error marca el minimo solape
max_cuts = ceil((0.94-FOVD)/(0.94-1)); %94% es lo que usaron la gente del paper y tratamos de disminuir
cuts = (min_cuts:max_cuts);
    

%% TEST BENCH
%Select 0 if want it to variate. Select a number if wanted constant
cte_frame = 0; 
cte_overlap = 0.94;
if (cte_frame ~= 0) && (cte_overlap == 0) %diferentes overlaps (mismo frame)
    test_name = strcat('Test_Data_',reference,'_x',num2str(FOVD),'_',num2str(cte_frame),'x',num2str(cte_frame));
    test_dir = strcat(dir_name,'Test\',test_name,'.mat');
elseif (cte_frame == 0) && (cte_overlap ~= 0) %diferentes frames (mismo overlap)
    test_name = strcat('Test_Data_',reference,'_x',num2str(FOVD),'_',num2str(cte_overlap),'x',num2str(cte_overlap));
    test_dir = strcat(dir_name,'Test\',test_name,'.mat');
end
    
for i = 1:length(cuts)
   
    fprintf('\n\nTest number %d\n',i);
    
    if (cte_frame ~= 0) && (cte_overlap == 0) %diferentes overlaps (mismo frame)
        frames(i)= cte_frame;
        overlap(i) = (cuts(i)-FOVD)/(cuts(i)-1); %Same for both X and Y
        fprintf('Overlap percentaje in X axis is %.2f %% and in Y axis is %.2f %%\n',overlap(i)*100,overlap(i)*100);
        single_test_dir = strcat(dir_name,test_name, '_',num2str(overlap(i),2),'x',num2str(overlap(i),2));
    elseif (cte_frame == 0) && (cte_overlap ~= 0) %diferentes frames (mismo overlap)
        frames(i)= cuts(i)-1;
        overlap(i) = cte_overlap; %Same for both X and Y
        fprintf('Frames in X axis are %d and in Y axis are %d \n',frames(i),frames(i));
        single_test_dir = strcat(dir_name,test_name, '_',num2str(frames(i)),'x',num2str(frames(i)));
    end
   

    %1. Cut Image(Data_dir, ground_Truth, frame, FOVD, horizontal_Cuts, vertical_Cuts,error_pixels, save,show)
     CutImageDos(single_test_dir, ground_Truth, FOVD, frames(i),overlap(i),cuts(i), cuts(i),8,1,0);
%      mergeChannels(dir);

    %2. Stitch algorithm
    %      manual_montage = manualMontageImages(dir, c, c);

    option = 2;%1: first stich rows and then cols; 2: everything together
    if option ==1
        final_Montage = montageRowCol(single_test_dir,c,gT_depth); 
    elseif option ==2
%       final_Montage = montageImages(dir,save);
        final_Montage = montageImages(single_test_dir,1);
    end
%     Montage8Bit = uint8(255 * mat2gray(final_Montage));%From double to uint8


    %3. Cut Borders
    %[nB_ground_Truth, nB_Montage] = removeBorder(dir, ground_Truth, mosaic, frame, xoverlap, yoverlap, save,show)
    [nB_ground_Truth, nB_Montage] = removeBorder(single_test_dir, ground_Truth, final_Montage, frames(i), overlap(i), overlap(i), 1,0);
    nB_ground_Truth = im2double(nB_ground_Truth);
    nB_Montage = im2double(nB_Montage);


    %4. Metrics
    rmseVal(i) = sqrt(immse (nB_Montage, nB_ground_Truth)); %1.RMSE
    fprintf('RMSE = %.2f (The lower de better)\n',rmseVal(i));
    psnrVal(i) = psnr(nB_Montage, nB_ground_Truth);%2.PSNR
    fprintf('PSNR = %.2f (The higher de better)\n',psnrVal(i));
    ssimVal(i) = ssim(nB_Montage,nB_ground_Truth); %3.SSIM
    fprintf('SSIM = %.2f (0: no correlation, 1:equal images)\n',ssimVal(i));

end

%% Save Variables
save(test_dir,'reference','overlap','frames','rmseVal','psnrVal','ssimVal');

%% Plot Graphs
test_dir = strcat(dir_name,'\Graphs\',test_name,'.jpg');
visualize(0, reference, overlap, frames, rmseVal, psnrVal, ssimVal);

fprintf('\nEnd of Test Bench');
