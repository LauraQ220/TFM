function ssimVal = ssimFun(img1,img2)
    [height, width, depth] = size(img1);


    for d = 1:depth
        A(d) = ssim(img1(:,:,d), img2(:,:,d));      
    end
    A = im2double(A);
%     img2 = im2double(img2);
    ssimVal = mean(A);
    
%https://www.cns.nyu.edu/~lcv/ssim/ssim.m
end