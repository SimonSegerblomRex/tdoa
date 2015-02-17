function v = frames2vector(F,frameOverlap,start)
%VECTOR2FRAMES Summary of this function goes here
%   Detailed explanation goes here
% dont' forget to crop the output vector!

frameSize = size(F,1);
hw = (frameSize-1)/2;

if frameOverlap >= 0
    v = F(1:end-frameOverlap,:);
    v = v(:);
    if start <= hw
        v = v(hw-start+2:end);
    end
    v = [v; F(end-frameOverlap+1:end,end)];
else
    F = [zeros(-frameOverlap,size(F,2)); F];
    v = F(1:end,:);
    v = v(:);
end

end