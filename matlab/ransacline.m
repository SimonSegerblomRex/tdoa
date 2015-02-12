function [delays,lines] = ransacline(A,settings)
% non-repeating

delays = NaN(settings.RANSACmaxNbrOfGroups,size(A,2));
lines = NaN(settings.RANSACmaxNbrOfGroups,size(A,2));

tmp = find(sum(~isnan(A)));
if numel(tmp) < settings.RANSACminNbrOfInliers
    return
end

%Non-nan points in A:
[rows,cols] = find(~isnan(A));
points = [cols'; A(sub2ind(size(A),rows,cols))'];

%All possible combinations:
n = length(points);
[r,c] = meshgrid(1:n,1:n);
pairs = unique(sort([r(:),c(:)],2)','rows'); 
pairs = pairs(:,randperm(length(pairs))); %shuffling

%RANSAC:
nbrOfIterations = settings.RANSACnbrOfIterations;
tmpdelays = NaN(nbrOfIterations,size(A,2));
tmplines = NaN(nbrOfIterations,size(A,2));
for k = 1:min(settings.RANSACnbrOfIterations,length(pairs))
    %Line using two random points:
    p = [points(:,pairs(1,k)) points(:,pairs(2,k))];
    ll = null([p' ones(2,1)]);
    okSlope = abs(ll(1)/ll(2)) < settings.RANSACmaxSlope;
    if ~okSlope
        continue
    end
    distances = abs(ll'*[points;ones(1,size(points,2))])/norm(ll(1:2));
    ind = distances < settings.RANSACinlierThreshold;
    enoughInliers = sum(ind) >= settings.RANSACminNbrOfInliers;
    if enoughInliers
        %Line fitting using all the inliers:
        pp = [points(1,ind)' ones(size(points(1,ind)'))]\points(2,ind)';
        ll = [pp(1)/pp(2); -1/pp(2); 1];
        x = 1:size(A,2);
        y = (-ll(3)-ll(1)*x)/ll(2);
        distances = abs(ll'*[points;ones(1,size(points,2))])/norm(ll(1:2));
        ind = distances < settings.RANSACinlierThreshold;
        tmpdelays(k,points(1,ind)) = points(2,ind);
        tmplines(k,:) = y;
    end
end

%Deleting NaN-rows:
ind = ~all(isnan(tmpdelays),2);
tmpdelays = tmpdelays(ind,:);
tmplines = tmplines(ind,:);

%Getting rid of duplicate lines:
for k = 1:settings.RANSACmaxNbrOfGroups
    if isempty(tmpdelays)
        return
    end
    nbrOfInliers = sum(~isnan(tmpdelays),2);
    [~,ind] = max(nbrOfInliers);
    delays(k,:) = tmpdelays(ind,:);
    lines(k,:) = tmplines(ind,:);
    ind = ~(sum(ismember(tmpdelays,delays(k,:)),2) >= ....
        settings.RANSACsharedPointsThreshold);
    tmpdelays = tmpdelays(ind,:);
    tmplines = tmplines(ind,:);
end

end