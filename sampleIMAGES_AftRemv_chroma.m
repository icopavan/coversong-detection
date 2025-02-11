function patches = sampleIMAGES_AftRemv()
% sampleIMAGES
% Returns a number of patches for training

load dataAftRemv;    % load images from disk 

patchsize =144*10;  % we'll use 8x8 patches 
%numpatches = round(72779*0.7); % Since this number will change due to
%different values of numAftRemv caused by rms setting50127*0.7
[m,n]=size(recordingAftRemv);
m=round(m);
n=round(n);
numpatches=floor(m/144);
% Initialize patches with zeros.  Your code will fill in this matrix--one
% column per patch, 10000 columns. 
patches = zeros(patchsize, numpatches);


%  IMAGES is a 3D array containing 10 images
%  Image 1
%{
for i=1:10
    r=randi(513-patchsize,numpatches/10,2);
    for j=1:numpatches/10
        patches(:,(i-1)*numpatches/10+j)=reshape(IMAGES(r(j,1):r(j,1)+patchsize-1,r(j,2):r(j,2)+patchsize-1,i),[patchsize*patchsize,1]);
    end;
end;
%}
for i=1:numpatches%35729
    patches(:,i)=reshape(recordingAftRemv((i-1)*144+1:i*144,:),[patchsize,1]);
end

%% ---------------------------------------------------------------
% For the autoencoder to work well we need to normalize the data
% Specifically, since the output of the network is bounded between [0,1]
% (due to the sigmoid activation function), we have to make sure 
% the range of pixel values is also bounded between [0,1]
patches = normalizeData(patches);

end


%% ---------------------------------------------------------------
function patches = normalizeData(patches)

% Squash data to [0.1, 0.9] since we use sigmoid as the activation
% function in the output layer

% Remove DC (mean of images). 
patches = bsxfun(@minus, patches, mean(patches));

% Truncate to +/-3 standard deviations and scale to -1 to 1
pstd = 3 * std(patches(:));
patches = max(min(patches, pstd), -pstd) / pstd;

% Rescale from [-1,1] to [0.1,0.9]
patches = (patches + 1) * 0.4 + 0.1;

end

