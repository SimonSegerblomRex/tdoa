function scores = gccscores(a,settings)
%GCCSCORES -
%
%    This function...
%
%    scores = GCCSCORES(a,settings)
%
%    Input:
%    a - matrix
%    settings - struct that must have...
%
%    Output:
%    scores - two-dimensional cell-array containg...

%Calculating matrices containing the DFT of all frames:
fftframes = cell(1,settings.mm);
for k = settings.channels
    frames = single(vector2frames(a(k,:),settings.frameSize,...
        settings.frameOverlap,settings.firstSamplePoint));
    %frames = frames-repmat(mean(frames),size(frames,1),1);
    fftframes{k} = fft(frames,2*size(frames,1)-1);
end
clear frames;

%Getting indeces indu only for the pairs that we have to calculate:
ii = zeros(1,settings.mm);
ii(settings.channels) = 1;
ind = logical(ii'*ii);
indu = triu(ind);

%Cross-correlation for all pairs with indeces indu:
scores = cell(settings.mm);
for k = find(indu)'
    [ii,jj] = ind2sub(size(ind),k);
    tmp = fftframes{jj}.*conj(fftframes{ii});
    tmp = fftshift(ifft(tmp.*settings.wf(tmp)),1);
    scores{ii,jj} = tmp(round(end/2)-settings.sw:round(end/2)+settings.sw,:);
end
clear fftframes;

%Filling in the pairs not in indu by mirroring the data:
tmp = cellfun(@flipud,scores','UniformOutput',false);
scores(tril(ind,-1)) = tmp(tril(ind,-1));
end