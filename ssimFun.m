function ssimVal = ssimFun(img1,img2)
    img1 = im2double(img1);
    img2 = im2double(img2);

    [height, width, depth] = size(img1);
    for h= 1:height 
        for w = 1:width
            sum1 = 0;
            sum2 = 0;
            for d = 1:depth
                sum1 = sum1 + img1(h,w,d);
                sum2 = sum2 + img2(h,w,d);
            end
            graycolor1 (h,w) = sum1/depth;
            graycolor2 (h,w) = sum2/depth;
        end
    end
    ssimVal = ssim(graycolor1, graycolor2);

end