clear all; close all; clc;
profile on

%% Import data
dir_name = 'C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\';
Data_dir = dir(dir_name);
% ground_Truth = imread(strcat('C:\Users\ACER\Documents\ULPGC\TFM\02 CODIGOS\Data\Reference\',char(Data_dir(3).name)));
reference = 'RGB';
want2save = 1;
want2show = 0;
want2frame = 0;
automatic =1; %1 for automatic, 0 for manual
ground_Truth1 = load(strcat(dir_name, 'Reference\',reference,'.mat'));
ground_Truth = ground_Truth1.image;
% ground_Truth = im2double(ground_Truth);
[gT_height, gT_width, gT_depth] = size(ground_Truth);

% 
% % Select bands
% bands = 7;
% w = ground_Truth1.reducedWavelength;
% w = transpose (w);
% idx=1;
% for j=1:round(275/bands):275
%     wavelength(idx) = w(j);
%     image(:,:,idx) = imcrop(ground_Truth(:,:,j),[0 0 800 800]);
%     idx =idx+1;
% end

% for i = 1: 4
% image(:,:,i) = imcrop(ground_Truth(:,:,i), [0 0 400 400]);
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
overlap_vector = (cuts-FOVD)./(cuts-1);

%% MANUAL TEST
% It can only be done one per FOVD, since overlap is 0
if (automatic == 0)&&(want2save==1) %diferentes overlaps (mismo frame)
    manual_dir = strcat(dir_name,'Test_Data_manual__',reference,'_x',num2str(FOVD),'_0x0_',num2str(FOVD),'x',num2str(FOVD));
    [nada1 , nada] = CutImageTres(manual_dir, ground_Truth, FOVD, FOVD, 0,FOVD, FOVD,2,1,want2show);
    manual_montage = manualMontageImages(manual_dir, FOVD, FOVD,1,0);
    [manual_ground_Truth, manual_montage] = removeBorder(manual_dir, ground_Truth, manual_montage, FOVD, 0, 0, want2save,want2show);
    manual_montage_double = im2double(manual_montage);
    manual_ground_Truth_double = im2double(manual_ground_Truth);
%     manual_montage = AddGaussianNoise(ground_Truth,6,1);
%     imshow(manual_montage);

    %Metrics
    manual_rmseVal = rmseFun(manual_montage_double, manual_ground_Truth_double);
    fprintf('RMSE = %.2f (The lower the better)\n',manual_rmseVal);    
    manual_psnrVal = psnrFun(manual_montage_double, manual_rmseVal);
    fprintf('PSNR = %.2f dB(The higher the better)\n',manual_psnrVal);  
    manual_ssimVal = ssimFun(manual_montage_double,manual_ground_Truth_double);
    fprintf('SSIM = %.2f (0: no correlation, 1:equal images)\n',manual_ssimVal);
%     manual_samVal= samFun(manual_montage_double,manual_ground_Truth_double);
%     fprintf('SAM = %.2f rad(angle between images )\n',manual_samVal);

end


%% TEST BENCH
%Select 0 if want it to variate. Select a number if wanted constant

for f = 1:16
    for o = 1:1
        frame = f+2; 
        overlap = overlap_vector(2);        
                    
        fprintf('\n\nTest number frame: %d and overlap : %f\n',f, overlap);
        test_name = strcat('Test_Data_',reference,'_x',num2str(FOVD),'_',num2str(frame),'x',num2str(frame),'_',num2str(overlap),'x',num2str(overlap));
        test_dir = strcat(dir_name,test_name);
        % Montage
        horizontal_Cuts = ceil((overlap-FOVD)/(overlap-1));
        vertical_Cuts = ceil((overlap-FOVD)/(overlap-1));

        %1. Cut Image(Data_dir, ground_Truth, frame, FOVD, horizontal_Cuts, vertical_Cuts,error_pixels, save,show)
         [cut_Width , cut_Height] = CutImageTres(test_dir, ground_Truth, FOVD, frame,overlap,horizontal_Cuts, vertical_Cuts, error_pixels,1,want2show);
%           mergeChannels('C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\Test_Data_automatic__FUN400_x2_0.94x0.94_3x3');
    %     showCuts(single_test_dir, Montage, FOVD, frames(i), overlap(i), cut_Width , cut_Height,want2save,want2show)


            %2. Stitch algorithm

            in_mem = monitor_memory_whos;
            montage = 0;
            montage = montageImages(test_dir,want2save);
            out_mem = monitor_memory_whos;
            elapsed_mem (f,o) = out_mem - in_mem; 



        %     Montage8Bit = uint8(255 * mat2gray(final_Montage));%From double to uint8
            if (want2frame == 1) 
                framedMontage = insertRectangle(single_test_dir, montage, FOVD, frames, overlap, cut_Width , cut_Height,want2save,want2show);
            end

            %3. Cut Borders
            %[nB_ground_Truth, nB_Montage] = removeBorder(dir, ground_Truth, mosaic, frame, xoverlap, yoverlap, save,show)
            % A vs B
        %     A = 'ground_Truth'; %reference
        %     B = 'montage';
            [ground_Truth_rb, montage] = removeBorder(test_dir, ground_Truth, montage, frame, overlap, overlap, want2save,want2show);
        %         [ground_Truth_rb, montage] = removeBorder('C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\Test_Data_automatic__FUN400_x2_0.94x0.94_3x3', ground_Truth, montage, 3, 0.94, 0.94, 0,0);

            ground_Truth_double = im2double(ground_Truth_rb);
            montage_double = im2double(montage);
        % hold on;
        % subplot(2,1,1)
        % imshow(montage_double(:,:,3))
        % subplot(2,1,2)
        % imshow(ground_Truth_double(:,:,3))
        % imwrite(ground_Truth(:,:,:), 'C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\Test_Data_automatic__FUN400_x2_0.94x0.94_3x3\gT.tif');


            %Metrics
            rmseVal(f,o) = rmseFun(montage_double, ground_Truth_double);
            fprintf('RMSE = %.2f (The lower the better)\n',rmseVal(f,o));    
            psnrVal(f,o) = psnrFun(montage_double, rmseVal(f,o));
            fprintf('PSNR = %.2f dB(The higher the better)\n',psnrVal(f,o) );  
            ssimVal(f,o) = ssim(montage_double,ground_Truth_double);
            fprintf('SSIM = %.2f (0: no correlation, 1:equal images)\n',ssimVal(f,o));
        %     samVal(i) = samFun(montage_double,ground_Truth_double);
        %     fprintf('SAM = %.2f rad(angle between images )\n',samVal(i));


    end
end

% Plot Graphs
% ssimVal = ssimVal(1:13);
% frames = frames(1:13);
% visualize(dir_name, test_name, reference, overlap, frames, cte_frame, cte_overlap, rmseVal, psnrVal, ssimVal, manual_rmseVal, manual_psnrVal, manual_ssimVal);
% visualize(dir_name, test_name, reference, overlap, frames, cte_frame, cte_overlap, rmseVal, psnrVal, ssimVal, manual_rmseVal, manual_psnrVal, manual_ssimVal);

%% Save Variables
test__test_dir = strcat(dir_name,'Test\',test_name,'ultimate.mat');
p = profile('info');
if (automatic == 0)&&(want2save==0)
    save(test__test_dir,'reference','p', 'elapsed_mem', 'rmseVal','psnrVal','ssimVal');
%     visualize(dir_name, test_name, reference, overlap, frames, cte_frame, cte_overlap, rmseVal, psnrVal, ssimVal, 0,0,0);
else
    save(test__test_dir,'reference','p', 'elapsed_mem', 'rmseVal','psnrVal','ssimVal', 'manual_rmseVal', 'manual_psnrVal', 'manual_ssimVal');
%     visualize(dir_name, test_name, reference, overlap, frames, cte_frame, cte_overlap, rmseVal, psnrVal, ssimVal, manual_rmseVal, manual_psnrVal, manual_ssimVal);
end

fprintf('\nEnd of Test Bench');

cuts = (3:14);
overlap_vector = (cuts-2)./(cuts-1);


surf(overlap_vector, cuts, psnrVal)
xlabel('overlap')
ylabel('frames')
zlabel('psnr')
% % Plot overlap vs number of frames
% Nsi = (2:18);
% overlap = (Nsi-2)./(Nsi-1);
% plot(Nsi,overlap);
% xlim([0 19]);
% ylim([0 1]);
% title('Overlap vs number of frames for FOVD = 2');
% xlabel('Number of frames');
% ylabel('Overlap'); 

