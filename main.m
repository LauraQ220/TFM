clear all; close all; clc;

%% Import data
dir_name = 'C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\';
Data_dir = dir(dir_name);
% ground_Truth = imread(strcat('C:\Users\ACER\Documents\ULPGC\TFM\02 CODIGOS\Data\Reference\',char(Data_dir(3).name)));
reference = 'RGB';
want2save = 1;
want2show = 0;
ground_Truth1 = load(strcat(dir_name, 'Reference\',reference,'.mat'));
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
FOVD = 2; %Field of View Degradation
error_pixels = 8; %Error in pixels for magnification 20x
error_percentajeX = 0.008; %Error percentaje in X axis for magnification 20x
error_percentajeY = 0.01; %Error percentaje in Y axis for magnification 20x
error_percentaje = error_percentajeY; %Most restrictive one

%ceil(a) rounds each element a to the nearest integer >= than element a.
min_cuts = ceil((error_percentaje-FOVD)/(error_percentaje-1)); %El error marca el minimo solape
% min_cuts = 2; 
max_cuts = ceil((0.94-FOVD)/(0.94-1)); %94% es lo que usaron la gente del paper y tratamos de disminuir
cuts = (min_cuts:max_cuts);
    

%% TEST BENCH
%Select 0 if want it to variate. Select a number if wanted constant
cte_frame = 18; 
cte_overlap = 0;
start = 1;
if (cte_frame ~= 0) && (cte_overlap == 0) %diferentes overlaps (mismo frame)
    test_name = strcat('Test_Data_',reference,'_x',num2str(FOVD),'_',num2str(cte_frame),'x',num2str(cte_frame));
    fprintf('Constant frames in X axis are %d and in Y axis are %d \n',cte_frame,cte_frame);
%     start = cte_frame;
elseif (cte_frame == 0) && (cte_overlap ~= 0) %diferentes frames (mismo overlap)
    test_name = strcat('Test_Data_',reference,'_x',num2str(FOVD),'_',num2str(cte_overlap),'x',num2str(cte_overlap));
    fprintf('Constant overlap percentaje in X axis is %.2f %% and in Y axis is %.2f %%\n',cte_overlap*100,cte_overlap*100);
end
 

%% Manual montage
if (cte_frame == cuts(length(cuts))) && (cte_overlap == 0) %diferentes overlaps (mismo frame)
        test_dir = strcat(dir_name, test_name, '_',num2str(cte_overlap),'x',num2str(cte_overlap));
        [nada1 , nada] = CutImageDos(test_dir, ground_Truth, FOVD, cte_frame, cte_overlap,FOVD, FOVD,8,1,want2show);
        manual_montage = manualMontageImages(test_dir, FOVD, FOVD,want2save,want2show);
end
 
%% Automatic montage
for i = 1:length(cuts)
   
    fprintf('\n\nTest number %d\n',i);
%     i = j-length(cuts)+1;
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
     [cut_Width , cut_Height] = CutImageDos(single_test_dir, ground_Truth, FOVD, frames(i),overlap(i),cuts(i), cuts(i),8,1,want2show);
     %      mergeChannels(dir);
%     showCuts(single_test_dir, Montage, FOVD, frames(i), overlap(i), cut_Width , cut_Height,want2save,want2show)


    %2. Stitch algorithm
    %      manual_montage = manualMontageImages(dir, c, c);

    
    %MONITOR_MEMORY_WHOS uses the WHOS command and evaluates inside the BASE
    %workspace and sums up the bytes.  The output is displayed in MB. Taken
    %from:
    % https://de.mathworks.com/matlabcentral/answers/uploaded_files/1861/monitor_memory_whos.m
    in_mem = monitor_memory_whos;
    tic;
    automatic_montage = montageImages(single_test_dir,want2save);
    elapsed_time(i)= toc;
    out_mem = monitor_memory_whos;
    elapsed_mem (i) = out_mem - in_mem;

    
%     Montage8Bit = uint8(255 * mat2gray(final_Montage));%From double to uint8
    if (want2save == 1) || (want2show == 1)
        framedMontage = insertRectangle(single_test_dir, automatic_montage, FOVD, frames(i), overlap(i), cut_Width , cut_Height,want2save,want2show);
    end

    %3. Cut Borders
    %[nB_ground_Truth, nB_Montage] = removeBorder(dir, ground_Truth, mosaic, frame, xoverlap, yoverlap, save,show)
    % A vs B
    A = 'manual_montage'; %reference
    B = 'automatic_montage';
    [A_nB, B_nB] = removeBorder(single_test_dir, A, B, frames(i), overlap(i), overlap(i), want2save,want2show);
    A_double = im2double(A_nB);
    B_double = im2double(B_nB);


    %4. Metrics
    rmseVal(i) = sqrt(immse (B_double, A_double)); %1.RMSE
    fprintf('RMSE = %.2f (The lower de better)\n',rmseVal(i));
    psnrVal(i) = psnr(B_double, A_double);%2.PSNR
    fprintf('PSNR = %.2f (The higher de better)\n',psnrVal(i));
    ssimVal(i) = ssim(B_double,A_double); %3.SSIM
    fprintf('SSIM = %.2f (0: no correlation, 1:equal images)\n',ssimVal(i));

end

% Plot Graphs
overlap = overlap(1:14);
frames = frames(1:14);
visualize(dir_name, test_name, reference, overlap, frames, cte_frame, cte_overlap, rmseVal, psnrVal, ssimVal);

%% Save Variables
test_dir = strcat(dir_name,'Test\',test_name,'.mat');
save(test_dir,'reference','overlap','frames','elapsed_time', 'elapsed_mem', 'rmseVal','psnrVal','ssimVal');

fprintf('\nEnd of Test Bench');


% Plot overlap vs number of frames
% Nsi = (3:18);
% overlap = (Nsi-2)./(Nsi-1);
% plot(Nsi,overlap);
% xlim([3 19]);
% ylim([0.5 1]);
% title('Overlap vs number of frames for FOVD = 2');
% xlabel('Number of frames');
% ylabel('Overlap'); 

