function visualize(dir_name, test_name, reference, overlap, frames, cte_frame, cte_overlap, rmseVal, psnrVal, ssimVal)


    % Graph for different overlaps

    if (cte_frame ~= 0) && (cte_overlap == 0) %diferentes overlaps (mismo frame)
        hold on;
        %RMSE
        h1 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
        plot(overlap, rmseVal);
        ax1 = gca;
        ax1.XDir = 'reverse';
        xlim([0.65 1])
        % ylim([10 55])
        title({'Overlap vs RMSE',[reference ' ' num2str(frames(1)) 'x' num2str(frames(1)) ' frames']});
        xlabel('Overlap');
        ylabel('RMSE');
       %PSNR
        h2 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
        plot(overlap, psnrVal);
        ax2 = gca;
        ax2.XDir = 'reverse';
        xlim([0.65 1])
        ylim([10 30])
        title({'Overlap vs PSNR',[reference ' ' num2str(frames(1)) 'x' num2str(frames(1)) ' frames']});
        xlabel('Overlap');
        ylabel('PSNR');
       %SSIM
        h3 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
        plot(overlap, ssimVal);
        ax3 = gca;
        ax3.XDir = 'reverse';
        xlim([0.65 1])
        ylim([0 1])
        title({'Overlap vs SSIM',[reference ' ' num2str(frames(1)) 'x' num2str(frames(1)) ' frames']});
        xlabel('Overlap');
        ylabel('SSIM'); 
        % Prepare subplots
        % test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots
        h4 = figure('Renderer', 'painters', 'Position', [10 10 1500 600]); %create new figure
        s1 = subplot(1,3,1,'parent',h4);
        s2 = subplot(1,3,2,'parent',h4);
        s3 = subplot(1,3,3,'parent',h4);
        copyaxes(ax1,s1, true); 
        copyaxes(ax2,s2, true);
        copyaxes(ax3,s3, true);
        

    %Graphs for different frames
    elseif (cte_frame == 0) && (cte_overlap ~= 0) %diferentes frames (mismo overlap)
        hold on;
        %RMSE
        h1 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
        plot(frames, rmseVal);
        ax1 = gca;
%         xlim([0.65 1])
        % ylim([10 55])
        title({'No of Frames vs RMSE',[reference ' ' num2str(100*overlap(1),2) '%']});
        xlabel('Number of Frames');
        ylabel('RMSE');
        %PSNR
        h2 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
        plot(frames, psnrVal);
        ax2 = gca;
%         xlim([0.65 1])
%         ylim([10 30])
        title({'No of Frames vs PSNR',[reference ' ' num2str(100*overlap(1),2) '%']});
        xlabel('Number of Frames');
        ylabel('PSNR');
        %SSIM
        h3 = figure('Renderer', 'painters', 'Position', [10 10 600 600]);
        plot(frames, ssimVal);
        ax3 = gca;
%         xlim([0.65 1])
%         ylim([0 1])
        title({'No of Frames vs SSIM',[reference ' ' num2str(100*overlap(1),2) '%']});
        xlabel('Number of Frames');
        ylabel('SSIM');
        % Prepare subplots
        % test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots
        h4 = figure('Renderer', 'painters', 'Position', [10 10 1500 600]); %create new figure
        s1 = subplot(1,3,1,'parent',h4);
        s2 = subplot(1,3,2,'parent',h4);
        s3 = subplot(1,3,3,'parent',h4);
        copyaxes(ax1,s1, true); 
        copyaxes(ax2,s2, true);
        copyaxes(ax3,s3, true);   
        
    else
        fprintf('Error in constant frame (%d) or overlap (%d)',frames(1),overlap(1));
    end

    RMSE_test_dir = strcat(dir_name,'\Graphs\',test_name,'_RMSE.jpg');
    saveas(h1,RMSE_test_dir);
    PSNR_test_dir = strcat(dir_name,'\Graphs\',test_name,'_PSNR.jpg');
    saveas(h2,PSNR_test_dir);
    SSIM_test_dir = strcat(dir_name,'\Graphs\',test_name,'_SSIM.jpg');
    saveas(h3,SSIM_test_dir);
    graph_test_dir = strcat(dir_name,'\Graphs\',test_name,'.jpg');
    saveas(h4,graph_test_dir);

end