function setaxes(settings)
%SETAXES Summary of this function goes here
%   Detailed explanation goes here

%x-axis:
xlim([1,settings.nbrOfFrames])
x = 1:settings.nbrOfFrames;
t = x*settings.nbrOfSamples/settings.nbrOfFrames/settings.sr;
tticks = 5*unique(floor(t/5));
tind = arrayfun(@(x) find(t-x>0,1,'first'),tticks);
set(gca,'XTick',x(tind));
set(gca,'XTickLabel',tticks);
xlabel('Position $t$')

%y-axis:
ylim([1,2*settings.sw+1])
y = 1:2*settings.sw+1;
u = (y-settings.sw)/settings.sr*settings.v;
uticks = 1*unique(floor(u/1));
uind = arrayfun(@(x) find(u-x>0,1,'first'),uticks);
set(gca,'YTick',y(uind));
set(gca,'YTickLabel',uticks);
set(gca,'YDir','reverse');
ylabel('Offset $u$')

end

