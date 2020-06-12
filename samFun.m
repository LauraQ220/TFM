function samVal = samFun(img1,img2)
% HYPERSAM Computes the spectral angle error (in radians) between two vectors

    [height, width, depth] = size(img1);
    vector1 = [];
    vector2 = [];
    for d = 1:depth
        for w = 1:height
            vector1 = [vector1 img1(w,:,d)];
            vector2 = [vector2 img2(w,:,d)];
        end
    end  
    
    vector1 = transpose(vector1);
    vector2 = transpose(vector2);
    
    
    [p,N] = size(vector1);
    errRadians = zeros(1,N);
    samVal = 0;
    for k=1:N
        tmp = vector1(:,k);
        errRadians(k) = acos(dot(tmp, vector2)/ (norm(vector2) * norm(tmp)));
        samVal = errRadians(k);
    end
end