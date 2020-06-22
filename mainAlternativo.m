clear all; close all; clc;

fixed = imread('C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\Test_Data_automatic__FUN400_x2_0.94x0.94_3x3\montage.tif');
moving = imread('C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\Test_Data_automatic__FUN400_x2_0.94x0.94_3x3\gT.tif');

fixed = fixed(:,:,1);
moving = moving(:,:,1);


[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.009; 
optimizer.Epsilon = 1.5e-4; 
optimizer.GrowthFactor = 1.01; 
optimizer.MaximumIterations = 300;

moving_reg = imregister(moving,fixed,'affine',optimizer,metric);
imshowpair(fixed, moving_reg,'Scaling','joint')



[MOVINGREG] = registerImages(frame(:,:,:,i),frame(:,:,:,i+1));
image = MOVINGREG.RegisteredImage;
diff = imsubtract(frame(:,:,:,i+1),image);
ans = [zeros(25*i,400); diff];
aux = [aux; zeros(25,400)];
%     ans = imcrop(diff, [0 376 400 24]);
[height, width, depth] = size(image);
%     for d = 1: depth
%         for w = 1:width
%             for h = 1:height
            final= max(ans,aux);
%             end
%         end
%     end
aux = final;

imshow(final);




A = imread(strcat('C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\Test_Data_automatic__RGB_x2_0.94x0.94_3x3\ChannelsMerged\frame0.tif'));
Ir = imread(strcat('C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\Test_Data_automatic__RGB_x2_0.94x0.94_3x3\ChannelsMerged\frame0.tif'));
% Calculate mask of images 1.jpg and 2.jpg
% (for this example, let's say that 'outside' black pixels are
% background pixels)
maskA = imfill(original ~= 0, 'holes');
maskB = imfill(rgb2gray(Ir) ~= 0, 'holes');
% Mask area where these 2 pictures overlap 
overlapMask = maskA & maskB;
% ...and extend it to 3 dimensional RGB image
overlapMaskRGB = cat(3, overlapMask, overlapMask, overlapMask);
% Now, as Image Analyst suggested, sum pixels in non overlap regions
% and in overlap regions, compute the average value.
% You can, for example, sum both images, and in overlaped area divide it by 2
C = A+Ir;
C(overlapMaskRGB) = C(overlapMaskRGB)/2;
figure; 
imshow(C);