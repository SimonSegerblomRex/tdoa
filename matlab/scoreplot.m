function scoreplot(score,settings)
%SCOREPLOT Summary of this function goes here
%   Detailed explanation goes here

c = 2; %set to 1 not to clip any colors
mm = max(max(score))/c;
imagesc(score,[0,mm]),colormap(gray)

setaxes(settings)

end