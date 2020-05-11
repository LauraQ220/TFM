function final_Montage = montageRowCol(parentFolder, c,gT_depth)

    %Create new directories
    mkdir(strcat(parentFolder,'\Rows'));
    % Create new directories
    for k = 1:gT_depth
        subfolder = strcat(parentFolder,'\Rows\Ch',num2str(k));
        mkdir(subfolder);
    end
    
    %Stitch
    for m=1:c
        Montage(:,:,:,m) = montageRows(parentFolder,(m*c)-c+1,m*c); %Montar cada fila
    end
    final_Montage = montageCols(parentFolder,1,c); %Juntar todas las filas

end

