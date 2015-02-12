function [delays,lines,ind] = fitdelayswithransac(u,settings)
%FITDELAYSWITHRANSAC Summary of this function goes here
%   Detailed explanation goes here

channels = settings.channels;
refChannel = settings.refChannel;

frameSize = settings.RANSACframeSize;
frameOverlap = settings.RANSACframeOverlap;
maxNbrOfGroups = settings.RANSACmaxNbrOfGroups;

start = round((frameSize+1)/2);
ind = vector2frames(1:max(cellfun('length',u)),frameSize,frameOverlap,start);
ind = ind(:,1:end-1); %since there might be zeros in the last column
n = size(ind,2);

delays = cell(1,settings.mm);
lines = cell(1,settings.mm);

for ch = channels(channels~=refChannel)
    delays(ch) = {NaN(maxNbrOfGroups,frameSize,n)};
    lines(ch) = {NaN(maxNbrOfGroups,frameSize,n)};
    for k = 1:n
        [delays{ch}(:,:,k),lines{ch}(:,:,k)] = ransacline(u{ch}(:,ind(:,k)),settings);
    end
end

end