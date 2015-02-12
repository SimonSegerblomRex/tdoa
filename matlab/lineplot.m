function lineplot(u,ind,settings)
%LINEPLOT Summary of this function goes here
%   Detailed explanation goes here

marks = '+o*.xsd^v><ph';
colors = hsv(12);

rows = find(~all(all(isnan(u),3),2))';
n = rows(end);

p = zeros(n,1);

hold on
for k = 1:n
    mar = marks(mod(k-1,numel(marks))+1);
    col = colors(k,:);
    tmp = squeeze(u(k,:,:)+settings.sw+1);
    tmpind = ~isnan(tmp);
    tmp = plot(ind(tmpind),tmp(tmpind),mar,'Color',col);
    p(k) = tmp(1);
end
legend(p,'1st line','2nd line','3rd line','4th line','5th line')
setaxes(settings)

end