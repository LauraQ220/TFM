function showCuts(single_test_dir, Montage, FOVD, frames, overlap, cut_Width , cut_Height,save,show)

     mergeChannels(single_test_dir);


% 
%     if save ==1  %Save image   
%         imwrite(Montage, strcat(single_test_dir, '\framedMosaic.png'));
%     end
% 
%     if show ==1 %Show image
%         imshow(Montage);
%         %Plot title
%         sgtitle(strcat('Montage of FOVD: ',num2str(FOVD),'. Overlap in X axis: ',num2str(round(horizontal_Overlap*100)),'% and in Y axis: ',num2str(round(vertical_Overlap*100)),'%'));
%     end
end

