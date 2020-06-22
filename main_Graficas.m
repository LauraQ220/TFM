clear all; close all; clc;

dir_name = 'C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\';
folder_name = 'Test\';
test_name = '2x2';
Data_dir = dir(strcat(dir_name, folder_name, test_name));

for i = 1 : length(Data_dir)-2
    rmseVal(i) = load(strcat(dir_name,folder_name, test_name, '/', Data_dir(i+2).name), 'rmseVal');
    psnrVal(i) = load(strcat(dir_name,folder_name, test_name, '/', Data_dir(i+2).name), 'psnrVal');
    ssimVal(i) = load(strcat(dir_name,folder_name, test_name, '/', Data_dir(i+2).name), 'ssimVal');
    frames(i) = load(strcat(dir_name,folder_name, test_name, '/', Data_dir(i+2).name), 'frames');
    overlap(i) = load(strcat(dir_name,folder_name, test_name, '/', Data_dir(i+2).name), 'overlap');
    reference(i) = load(strcat(dir_name,folder_name, test_name, '/', Data_dir(i+2).name), 'reference');
end

if (frames(1).frames(1) == frames(1).frames(2)) %diferentes overlaps (mismo frame)
    num = [num2str(frames(1).frames(1)) 'x' num2str(frames(1).frames(1))];
    %RMSE
    h1 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
    for j = 1:length(Data_dir)-2
       lg_name{j} = reference(j).reference;
       plot(overlap(j).overlap, rmseVal(j).rmseVal);
       hold on 
    end
    ax1 = gca;
    ax1.XDir = 'reverse';
%     xlim([2 20])
%     ylim([10 55])
    title({'Overlap vs RMSE';num});
    xlabel('Overlap');
    ylabel('RMSE');
    hleg = legend(lg_name);
    hold off

    
    %PSNR
    psnr_name = 0;
    h2 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
    for j = 1:length(Data_dir)-2
       plot(overlap(j).overlap, psnrVal(j).psnrVal);
      psnr_name = char(psnr_name,reference(j).reference); 
       hold on 
    end
    ax2 = gca;
    ax2.XDir = 'reverse';
%     xlim([2 20])
%     ylim([10 55])
    title({'Overlap vs PSNR';num});
    xlabel('Overlap');
    ylabel('PSNR');
    legend(hleg.String{:}); 
    hold off

    %SSIM
    ssim_name = 0;
    h3 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
    for j = 1:length(Data_dir)-2
       plot(overlap(j).overlap, ssimVal(j).ssimVal);
       ssim_name = char(ssim_name,reference(j).reference); 
       hold on 
    end
    ax3 = gca;
    ax3.XDir = 'reverse';
%     xlim([2 20])
%     ylim([10 55])
    title({'Overlap vs SSIM';num});
    xlabel('Overlap');
    ylabel('SSIM');
    legend(hleg.String{:})
    hold off

elseif (overlap(1).overlap(1) == overlap(1).overlap(2)) %diferentes frames (mismo overlap)
    %RMSE
    h1 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
    for j = 1:length(Data_dir)-2
       lg_name{j} = reference(j).reference;
       plot(frames(j).frames, rmseVal(j).rmseVal);
       hold on 
    end
    ax1 = gca;
    xlim([2 20])
%     ylim([10 55])
    title({'No of frames vs RMSE';'94%'});
    xlabel('Number of Frames');
    ylabel('RMSE');
    hleg = legend(lg_name);
    hold off

    
    %PSNR
    psnr_name = 0;
    h2 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
    for j = 1:length(Data_dir)-2
       plot(frames(j).frames, psnrVal(j).psnrVal);
      psnr_name = char(psnr_name,reference(j).reference); 
       hold on 
    end
    ax2 = gca;
    xlim([2 20])
%     ylim([10 55])
    title({'No of frames vs PSNR';'94%'});
    xlabel('Number of Frames');
    ylabel('PSNR');
    legend(hleg.String{:}); 
    hold off

    %SSIM
    ssim_name = 0;
    h3 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
    for j = 1:length(Data_dir)-2
       plot(frames(j).frames, ssimVal(j).ssimVal);
       ssim_name = char(ssim_name,reference(j).reference); 
       hold on 
    end
    ax3 = gca;
    xlim([2 20])
%     ylim([10 55])
    title({'No of frames vs SSIM';'94%'});
    xlabel('Number of Frames');
    ylabel('SSIM');
    legend(hleg.String{:})
    hold off

end

%All together
h4 = figure('Renderer', 'painters', 'Position', [10 10 1500 600]); %create new figure
%     name ={name_rmse, name_psnr, name_ssim};
s1 = subplot(1,3,1,'parent',h4);
copyaxes(ax1,s1, true); 
legend(s1,hleg.String{:});
s2 = subplot(1,3,2,'parent',h4);
copyaxes(ax2,s2, true);
legend(s2,hleg.String{:});
s3 = subplot(1,3,3,'parent',h4);
copyaxes(ax3,s3, true); 
legend(s3,hleg.String{:});

%Save
RMSE_test_dir = strcat(dir_name,'GraphsTotal\',test_name,'_RMSE.jpg');
saveas(h1,RMSE_test_dir);
PSNR_test_dir = strcat(dir_name,'GraphsTotal\',test_name,'_PSNR.jpg');
saveas(h2,PSNR_test_dir);
SSIM_test_dir = strcat(dir_name,'GraphsTotal\',test_name,'_SSIM.jpg');
saveas(h3,SSIM_test_dir);
graph_test_dir = strcat(dir_name,'GraphsTotal\',test_name,'.jpg');
saveas(h4,graph_test_dir);
