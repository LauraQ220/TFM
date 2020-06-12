function psnrVal = psnrFun(img1,rmseVal)
    img1 = im2double(img1);

    [height, width, depth] = size(img1);
    maxf = 0;
    for d = 1:depth
        for w = 1:width
            for h= 1:height
                if img1(h,w,d) >= maxf
                    maxf = img1(h,w,d);
                end
            end
        end
    end  
    psnrVal = 20*log10(maxf/rmseVal);

end