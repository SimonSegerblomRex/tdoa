function uout = clipdata(u,settings)
%CLIPDATA Summary of this function goes here
%   Detailed explanation goes here

leftLim = max(cell2mat(cellfun(@(c) find(~isnan(c),1,'first'),u,'UniformOutput',false)));
rightLim = min(cell2mat(cellfun(@(c) find(~isnan(c),1,'last'),u,'UniformOutput',false)));

uout = NaN(settings.mm,max(cellfun('length',u)));
for ch = settings.channels(settings.channels~=settings.refChannel)
    uout(ch,leftLim:rightLim) = u{ch}(leftLim:rightLim);
end
uout(settings.refChannel,leftLim:rightLim) = 0;

end