function samVal = artificialsamFun(img1,img2)
% HYPERSAM Computes the spectral angle error (in radians) between two vectors

    [height, width, depth] = size(img1);
    samVal = [];

    for w = 1:width
        for h = 1:height
            vector1 = [];
            vector2 = [];
            for d = 1:depth
   
            end
%             vector1 = transpose(vector1);
%             vector2 = transpose(vector2);
%             [p,N] = size(vector1);
%             errRadians = zeros(1,N);
%             for k=1:N
%                 tmp = vector1(:,k);
%                 errRadians(k) = acos(dot(tmp, vector2)/ (norm(vector2) * norm(tmp)));
%                 samMatrix(w,h) = errRadians(k);
%             end
        end
    end
    

    
    
%     imshow(samMatrix);
    B = reshape(samMatrix, width*height, 1);
    suma = sum(abs(B));
    samVal = suma/(width*height);


    
    

end