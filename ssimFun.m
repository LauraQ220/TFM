function ssimVal = ssimFun(img1,img2)
    img1 = im2double(img1);
    img2 = im2double(img2);

    [height, width, depth] = size(img1);
    sum = 0;
    for d = 1:depth
        for w = 1:width
            for h= 1:height
                sum = sum + ssim(img1(h,w,d), img2(h,w,d));
            end
        end
    end  
    ssimVal = mean(sum);

end