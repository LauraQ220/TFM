function visualize(graph_test_dir, reference, overlap, frames, cte_frame, cte_overlap, rmseVal, psnrVal, ssimVal)

    % Graph for different overlaps
    % overlap = overlap(1:15);

    if (cte_frame ~= 0) && (cte_overlap == 0) %diferentes overlaps (mismo frame)
        subplot(1,3,1);
        h1 = plot(overlap, rmseVal);
        ax = gca;
        ax.XDir = 'reverse';
        xlim([0.65 1])
        % ylim([10 55])
        title({'Overlap vs RMSE',[reference ' ' num2str(frames(1)) 'x' num2str(frames(1)) ' frames']});
        xlabel('Overlap');
        ylabel('RMSE');
        subplot(1,3,2);
        plot(overlap, psnrVal);
        ax = gca;
        ax.XDir = 'reverse';
        xlim([0.65 1])
        ylim([10 30])
        title({'Overlap vs PSNR',[reference ' ' num2str(frames(1)) 'x' num2str(frames(1)) ' frames']});
        xlabel('Overlap');
        ylabel('PSNR');
        subplot(1,3,3);
        plot(overlap, ssimVal);
        ax = gca;
        ax.XDir = 'reverse';
        xlim([0.65 1])
        ylim([0 1])
        title({'Overlap vs SSIM',[reference ' ' num2str(frames(1)) 'x' num2str(frames(1)) ' frames']});
        xlabel('Overlap');
        ylabel('SSIM');

    %Graphs for different frames
    % frames = frames(1:15);
    elseif (cte_frame == 0) && (cte_overlap ~= 0) %diferentes frames (mismo overlap)
        subplot(1,3,1);
        h1 = plot(frames, rmseVal);
        title({'No of Frames vs RMSE',[reference ' ' num2str(100*overlap(1),2) '%']});
        xlabel('Number of Frames');
        ylabel('RMSE');
        subplot(1,3,2);
        plot(frames, psnrVal);
        title({'No of Frames vs PSNR',[reference ' ' num2str(100*overlap(1),2) '%']});
        xlabel('Number of Frames');
        ylabel('PSNR');
        subplot(1,3,3);
        plot(frames, ssimVal);
        title({'No of Frames vs SSIM',[reference ' ' num2str(100*overlap(1),2) '%']});
        xlabel('Number of Frames');
        ylabel('SSIM');
    else
        fprintf('Error in constant frame (%d) or overlap (%d)',frames(1),overlap(1));
    end
        saveas(h1,graph_test_dir);

end