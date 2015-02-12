function segmentplot(scores,u,ind,f,settings)
%SEGMENTPLOT Summary of this function goes here
%   Detailed explanation goes here

marks = '+o*.xsd^v><ph';
for ch = settings.channels(settings.channels~=settings.refChannel)
    subplot(2,round(settings.mm/2),ch)
    nel = cellfun(@(c) numel(find(~isnan(c))),u{ch});
    indd = f(nel);
    colors = hsv(numel(indd));
    %scoreplot(scores{ch},settings)
    hold on
    pp = 1;
    for kk = indd
        mar = marks(mod(pp-1,numel(marks))+1);
        col = colors(pp,:);
        tmp = u{ch}{kk};
        tmpind = ~isnan(tmp);
        plot(ind(tmpind),tmp(tmpind)+settings.sw+1,mar,'color',col);
        pp = pp + 1;
    end
    setaxes(settings)
end

end