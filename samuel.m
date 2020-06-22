%% >>>>>>> load images and calculate their transformation <<<<<<< %%
im1 = imread('C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\Test_Data_automatic__RGB_x2_0.94x0.94_3x3\Channels\Ch1\frame0.tif');
im2 = imread('C:\Users\ACER\Documents\ULPGC\TFM\02_CODIGOS\Data\Test_Data_automatic__RGB_x2_0.94x0.94_3x3\Channels\Ch1\frame1.tif');
imshowpair(im1, im2, 'montage');

% calculate features on grayscale image
im1g = rgb2gray(im1);
im2g = rgb2gray(im2);
points1 = detectSURFFeatures(im1g);
[features1, points1] = extractFeatures(im1g, points1);
points2 = detectSURFFeatures(im2g);
[features2, points2] = extractFeatures(im2g, points2);

% Find correspondences between im1 and im2
indexPairs = matchFeatures(features1, features2, 'Unique', true);
matchedPoints1 = points1(indexPairs(:,1), :);
matchedPoints2 = points2(indexPairs(:,2), :);

% Identity transformation
transform_eye = projective2d(eye(3));
% Estimate the transformation between im1 and im2
% we use a 'similarity' transform (translation/rotation), which treats the
% images as rigid bodys. 'affine' / 'projective' transformations allow for
% warping the images itself (the overlap might not be a rectangle).
transform = estimateGeometricTransform(matchedPoints1, matchedPoints2,...
    'similarity', 'Confidence', 99.9, 'MaxNumTrials', 2000);

%% >>>>>>> apply transformation to images <<<<<<< %%

% create a world coordinate system (RF) that has space to store 
% the reference image (im1) and the transformed image (im2)
R2 = imref2d(size(im2));
[~, R2T]=imwarp(im2,R2,transform);
xLimits=[min(0.5,R2T.XWorldLimits(1)) max(size(im1,2), R2T.XWorldLimits(2))];
yLimits=[min(0.5,R2T.YWorldLimits(1)) max(size(im1,1), R2T.YWorldLimits(2))];
width  = round(xLimits(2) - xLimits(1));
height = round(yLimits(2) - yLimits(1));
RF = imref2d([height width], xLimits, yLimits);

% transform both images with regard to the world coordinate system RF
im1t=imwarp(im1,transform_eye,'OutputView',RF); % im1 stays in place (identity transform)
im2t=imwarp(im2,transform,'OutputView',RF); % im2 is transformed

% visualize result
imOverlay = im1t/2 + im2t/2; 
imshow(imOverlay);

%% >>>>>>> get the overlap area only <<<<<<< %%
% if you only want the overlap area, apply the transform to image masks
im1bw = ones(size(im1)); % mask1
im2bw = ones(size(im2)); % mask2
im1bwt=imwarp(im1bw,transform_eye,'OutputView',RF); % im1 stays in place (identity transform)
im2bwt=imwarp(im2bw,transform,'OutputView',RF); % im2 is transformed

% visualize result
maskOverlap = im1bwt + im2bwt - 1; 
imshow(maskOverlap);
% maskOverlap is a bw image that contains 'true' for overlap pixels
% you can use that for cropping imOverlay or
% use bwarea or regionprops to calculate the are