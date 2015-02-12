function [newdelaysegments,newlinesegments] = ...
    connectsegments(delaysegments,linesegments,ind,uref,settings)
%CONNECTSEGMENTS Summary of this function goes here
%   Detailed explanation goes here
%ratt manga fulhack har... gar att gora mycket battre, jamfar
%linjelutnignar ocksa t ex

channels = settings.channels;
refChannel = settings.refChannel;

newdelaysegments = cell(1,settings.mm);
newlinesegments = cell(1,settings.mm);

for ch = channels(channels~=refChannel)
    
    newdelaysegments{ch} = cell(size(delaysegments{ch}));
    newlinesegments{ch} = cell(size(newlinesegments{ch}));
    
    n = numel(linesegments{ch});
    
    u = uref{ch};
    
    for k = 1:n
        segment0 = linesegments{ch}{k};
        index = find(~isnan(segment0),settings.linesOverlap,'last');
        point0 = [ind(index(1)); segment0(index(1))];
        rMax = -Inf;
        for j = k+1:n
            segment1 = linesegments{ch}{j};
            index = find(~isnan(segment1),settings.linesOverlap,'first');
            point1 = [ind(index(end)); segment1(index(end))];
            if point0(1) > point1(1)
                tmp0 = frames2vector(segment0,settings.RANSACframeOverlap,...
                    round((settings.RANSACframeSize+1)/2));
                tmp1 = frames2vector(segment1,settings.RANSACframeOverlap,...
                    round((settings.RANSACframeSize+1)/2));
                index = point1(1):point0(1);
                r = sum(abs(tmp0(index)-tmp1(index)) < 10)/norm(point0-point1);
            else
                ll = null([point0' 1; point1' 1]);
                [rows,cols] = find(~isnan(u));
                index = logical((cols > point0(1)).*(cols < point1(1)));
                rows = rows(index);
                cols = cols(index);
                points = [cols'; u(sub2ind(size(u),rows,cols))'];
                distances = abs(ll'*[points;ones(1,size(points,2))])/norm(ll(1:2));
                r = sum(distances < settings.linesInlierThreshold)/norm(point0-point1);
                if norm(point0-point1) > 300 %...fult
                    r = 0;
                end
            end
            if r > max(settings.linesInlierRatio,rMax)
                rMax = r;
                %Add segment k...
                newdelaysegments{ch}{k} = delaysegments{ch}{k};
                index = ~isnan(delaysegments{ch}{j});
                newdelaysegments{ch}{k}(index) = delaysegments{ch}{j}(index);
                %...and segment j:
                newlinesegments{ch}{k} = linesegments{ch}{k};
                index = ~isnan(linesegments{ch}{j});
                newlinesegments{ch}{k}(index) = linesegments{ch}{j}(index);
                %Copy new connected segments to j:
                delaysegments{ch}(j) = newdelaysegments{ch}(k);
                linesegments{ch}(j) = newlinesegments{ch}(k);
                continue
            elseif j == n
                newdelaysegments{ch}(k) = delaysegments{ch}(k);
                newlinesegments{ch}(k) = linesegments{ch}(k);
            end
        end
    end
end

end