function urefsmooth = smoothdelays(newdelaysegments,newlinesegments,uref,settings)
%SMOOTHDELAYS Summary of this function goes here
%   Detailed explanation goes here

%smooth with spline first?

channels = settings.channels;
refChannel = settings.refChannel;

longestdelaysegments = cell(1,settings.mm);
longestlinesegments = cell(1,settings.mm);
for ch = channels(channels~=refChannel)
    nel = cellfun(@(c) numel(find(~isnan(c))),newlinesegments{ch});
    [~,indd] = max(nel);
    longestdelaysegments(ch) = newdelaysegments{ch}(indd);
    longestlinesegments(ch) = newlinesegments{ch}(indd);
end

urefsmooth = cell(1,settings.mm);

for ch = channels(channels~=refChannel)
    
    ur = uref{ch};
    
    u = frames2vector(longestdelaysegments{ch},settings.RANSACframeOverlap,...
        round((settings.RANSACframeSize+1)/2));
    
    %Fit spline:
    x = find(~isnan(u));
    y = smooth(x,u(x),settings.smoothingDegree);
    xx = x(1):x(end);
    yy = spline(x,y,xx);
    
    y = NaN(1,size(ur,2));
    y(xx) = yy;
    
    d = abs(ur-repmat(y,size(ur,1),1));
    cind = find(sum(d < settings.smoothingDistance) > 0);
    [~,rind] = min(d(:,cind));
    ind = sub2ind(size(ur),rind,cind);
    tmp = ur(ind);

    y(cind) = tmp;
    
    urefsmooth{ch} = y;    
    %pp = csapi(1:1000,uij{8}(2,:));x=fnplt(pp);
end

end