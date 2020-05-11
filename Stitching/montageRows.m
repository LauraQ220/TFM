function montage = montageRows(Data_dir,first_frame,last_frame)

    % Mosaics multi-channel data using methods described in *INSERT PAPER*



%     Data_dir = 'C:\Users\ACER\Documents\ULPGC\TFM\02 CODIGOS\1stOverlap\Data\Test_Data_x2_20x20_0.95x0.95'; % Data Directory
%     Data_dir = 'Test_Data';

    channel_dirs = dir(strcat(Data_dir,'\Channels'));
    %Data Directory has a sub-folder for each data channel
    n_channels = length(channel_dirs) - 2;
    
    
   %Loop to read all frames
    for i = 1:n_channels
        current_ch_dir = dir([Data_dir '\Channels\' channel_dirs(i+2).name]);
%         n_frames = length(current_ch_dir) - 2;
        n_frames = last_frame - first_frame+1;
        for j = 1:n_frames
            original_frames(:,:,i,j) = imread([Data_dir '\Channels\' channel_dirs(i+2).name '\frame' num2str(j-2+first_frame) '.tif']);
        end
    end

    original_frames = double(original_frames)/255; %Normaliza la imagen

    yres = size(original_frames,  1);%tama�o de x axis
    xres = size(original_frames,  2);%tama�o de y axis


    %% If a GPU device is available, use it for increased calculation speed
% 
%     try
%        canUseGPU = parallel.gpu.GPUDevice.isAvailable;
%     catch ME
%        canUseGPU = false;
%     end
% 
%     if canUseGPU
%         original_frames_GPU = gpuArray(original_frames);
%     end

    %% Allocate variables for mosaicking
    mosaics = original_frames(:,:,:,1);
    dx = 0; dy = 0; dxt = 0; dyt = 0;
    trustvector = normalize(double(ones(1,n_channels)),'norm', 1);

    %% Calculate mosaics
    for f = 1:n_frames-1
        dxp = dx;
        dyp = dy;

        I1 = original_frames(:,:,:,f);
        I2 = original_frames(:,:,:,f+1);

%         if canUseGPU
%             I1_GPU = original_frames_GPU(:,:,:,f);
%             I2_GPU = original_frames_GPU(:,:,:,f+1);
%             [dy, dx, err] = mchannel_nxcorr_reg_GPU(I1_GPU, I2_GPU, trustvector);
%         else
%             [dy, dx, err] = mchannel_nxcorr_reg_GPU(I1, I2, trustvector);
%         end       

        % Only include next line if you want dynamic weighted averaging based on individual error rates
        % trustvector = 0*trustvector + 1./(err+1);

        dxt = dxt + dx;
        dyt = dyt + dy;

        tform = affine2d;
        tform.T = double([1 0 0; 0 1 0; dxt dyt 1]);

        imageSize = size(mosaics(:,:,1));
        Mind = mosaics;
        mosaics = [];
        Mtind = [];
        I2t = [];

        [xlim, ylim] = outputLimits(tform, [1 xres], [1 yres]);
        xMin = min([1; xlim(:)]);
        xMax = max([imageSize(2); xlim(:)]);
        yMin = min([1; ylim(:)]);
        yMax = max([imageSize(1); ylim(:)]);
        width = round(xMax-xMin);
        height = round(yMax-yMin);

        xLimits = [xMin xMax];
        yLimits = [yMin yMax];
        panoramaView = imref2d([height width], xLimits, yLimits);
        frame_number = (last_frame/(last_frame-first_frame+1))-1;


        for j = 1:n_channels
            Mtind(:,:,j) = imwarp(Mind(:,:,j), affine2d, 'nearest', 'OutputView', panoramaView);
            I2t(:,:,j) = imwarp(I2(:,:,j), tform, 'OutputView', panoramaView);
            mosaics(:,:,j) = double(stitchImages(Mtind(:,:,j), I2t(:,:,j)))/255;
            imwrite(mosaics(:,:,j), strcat(Data_dir,'\Rows\Ch',num2str(j),'\frame', num2str(frame_number), '.tif'));
        end
    end

%     mosaico = montage(mosaics, 'Size', [1 n_channels]);
%     frame_number = last_frame/(last_frame-first_frame+1);
%     imwrite(mosaics, strcat(Data_dir, '\Mosaic.png'));
    montage = mosaics;
    fprintf('Stitching Finished!\n');

end