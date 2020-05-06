function [Output] = sam(Image,Library)

% Spectral Angle Mapper
% Silas J. Leavesley, PhD
% University of South Alabama
% Last Updated: 2/7/2017

% To visualize output data:
% figure(1)
% for i = 1:length(Output.data(1,1,:))
%   subplot(1,length(Output.data(1,1,:)),i)
%   imagesc(Output.data(:,:,i))
% end
% colormap(gray) % or any other colormap, as desired

% Mathematical description:
% sam x=acos((a.*b)./(mag_a.*mag_b))
% where a=unknown and b=reference
% mag_vect=norm(vect)
% arccos=acos(x)

tic

Library=double(Library);
Image=double(Image);

[O P Q] = size(Library);
Library_Reshaped=(reshape(Library,(O*P),Q))'; %o p are x y q=wavelength
[L M N]=size(Image);
Image_Reshaped=(reshape(Image,(L*M),N))'; %l m are x y n=wavelength

for i = 1:P
    for j = 1:(L*M)
        Angle_Image(j,i) = 90-((180./pi()).*acos(sum(Image_Reshaped(:,j).* Library_Reshaped(:,i))./ (norm(Image_Reshaped(:,j)).*norm(Library_Reshaped(:,i))) ));
    end
end
Output.data=reshape(Angle_Image,L,M,P);
toc