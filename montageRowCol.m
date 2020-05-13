function final_Montage = montageRowCol(parentFolder, c,gT_depth)

    %Create new directories
    mkdir(strcat(parentFolder,'\Rows'));
    % Create new directories
    for k = 1:gT_depth
        subfolder = strcat(parentFolder,'\Rows\Ch',num2str(k));
        mkdir(subfolder);
    end
    %read
    for k = 1:gT_depth
        for m=1:18
            Montage(:,:,k,m)= imread([parentFolder '\Channels\Ch' num2str(k) '\frame' num2str(m-1) '.tif']);
        end
    end
    
    
    
    %Stitch
    for m=1:18
        montageRows(parentFolder,m,m+1); %Montar cada fila
%         Montage(:,:,:,m) = montageRows(parentFolder,(m*c)-c+1,m*c); %Montar cada fila

    end
%     final_Montage = montageCols(parentFolder,1,c); %Juntar todas las filas

end

