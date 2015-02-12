function [delaysegments,linesegments] = connectlines(delays,lines,ind,settings)
%

channels = settings.channels;
refChannel = settings.refChannel;

frameOverlap = settings.RANSACframeOverlap;

delaysegments = cell(1,settings.mm);
linesegments = cell(1,settings.mm);

for ch = channels(channels~=refChannel)
    
    delaysegments(ch) = {{NaN(size(ind))}};
    linesegments(ch) = {{NaN(size(ind))}};
    
    pp = numel(delaysegments{ch});
    prev = cellfun(@(c) c(end-floor(frameOverlap/2),1),linesegments{ch})';
    for k = 1:size(ind,2)
        curr = lines{ch}(:,frameOverlap-floor(frameOverlap/2),k);
        lineInd = find(~isnan(curr));
        tmpMin = Inf(size(prev));
        for j = lineInd'
            [mv,tmp] = nanmin(abs(prev-curr(j)));
            if (mv < min(settings.lineDistanceThreshold,tmpMin(tmp)))
                %Connect to old segment:
                delaysegments{ch}{tmp}(:,k) = delays{ch}(j,:,k)';
                linesegments{ch}{tmp}(:,k) = lines{ch}(j,:,k)';
                tmpMin(tmp) = mv;
            else
                %New segment:
                delaysegments{ch}{pp}(:,k) = delays{ch}(j,:,k)';
                linesegments{ch}{pp}(:,k) = lines{ch}(j,:,k)';
                delaysegments{ch}(pp+1) = {NaN(size(ind))};
                linesegments{ch}(pp+1) = {NaN(size(ind))};
                pp = pp + 1;
            end
        end
        prev = cellfun(@(c) c(end-floor(frameOverlap/2),k),linesegments{ch})';
    end
    
    if pp > 1
        delaysegments{ch} = delaysegments{ch}(1:end-1);
        linesegments{ch} = linesegments{ch}(1:end-1);
    end
end

end