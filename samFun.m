function samVal = samFun(img1,img2)
% HYPERSAM Computes the spectral angle error (in radians) between two vectors

    [height, width, depth] = size(img1);
    A = [];
    for w = 1:width
        for h = 1:height
            nominador = 0;
            denominador1 = 0;
            denominador2 = 0;  
            for d = 1:depth
                nominador = nominador + (img1(w,h,d)*img2(w,h,d));
                denominador1 = denominador1 + (img1(w,h,d)*img1(w,h,d));
                denominador2 = denominador2 + (img2(w,h,d)*img2(w,h,d)); 
            end
            A(w,h) = acos(nominador/((sqrt(denominador1))*(sqrt(denominador2))));
        end
    end  
%     imshow(A);
    B = reshape(A, width*height, 1);
%     nan = sum(isnan(B));
    suma = nansum(abs(B));
    samVal = suma/(width*height);

end