function errRadians = getSam(a, b)
% GETSAM computes the spectral angle error between the vector b and
% every column of matrix a (or just the first column, if a is a vector)

[~,N] = size(a);
errRadians = zeros(1,N);

for k=1:N
    tmp = a(:,k);
    errRadians(k) = acos(dot(tmp, b)/ (norm(b) * norm(tmp)));
end