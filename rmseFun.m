function rmseVal = rmseFun(img1,img2)

    img1 = im2double(img1);
    img2 = im2double(img2);

    [height, width, depth] = size(img1);
    sum = 0;
    for d = 1:depth
        for w = 1:width
            for h= 1:height
                sum = (img1(h,w,d)-img2(h,w,d))*(img1(h,w,d)-img2(h,w,d))+sum; %1.RMSE
            end
        end
    end
    mean_se = sum/(depth*width*height);
    rmseVal = sqrt(mean_se);

end
