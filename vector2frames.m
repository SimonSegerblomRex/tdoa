function F = vector2frames(v,frameSize,frameOverlap,start)
%VECTOR2FRAMES Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4
    start = 1;
end

v = v(:); %ensure v is a column vector

hw = round((frameSize-1)/2);
if frameOverlap > 0
    n = hw-frameOverlap;
else
    n = hw;
end

if (start <= hw)
    z = zeros(hw-start+1,1);
    v = [z; v];
    start = hw+1;
end

F = buffer(v(start-n:end),frameSize,frameOverlap,v(start-hw:start-hw+frameOverlap-1));

end