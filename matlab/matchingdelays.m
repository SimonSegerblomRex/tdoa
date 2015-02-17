function uref = matchingdelays(u,settings)
%MATCHINGDELAYS - Limits the delay candidates
%
%    This function...
%
%    uref = MATCHINGDELAYS(u,settings)
%
%    Input:
%    u  - delay data output from getdelays
%    settings - struct that must have...
%
%    Output:
%    uref - delays for

channels = settings.channels;
refChannel = settings.refChannel;
[m,n] = size(u{channels(1),channels(1)});

uref = cell(1,settings.mm);
for ch = channels(channels~=refChannel)
    candidates = NaN(1+m*m*(numel(channels)-2),n);
    candidates(1:m,:) = u{refChannel,ch};
    %Using u{refChannel,ch} = urefChannel{refChannel,k}-u{ch,k}:
    pp = 1; %loop counter
    for k = setdiff(channels,[refChannel,ch])
        candidates(2+(pp-1)*m*m:pp*m*m+1,:) = dfcombs(u{refChannel,k},u{ch,k});
        pp = pp+1;
    end
    %Finding the candidates that have at least minNbrOfInliers inliers:
    [bin,binNbr] = histc(candidates,-settings.sw:settings.binSize:settings.sw);
    ind = bin > settings.minNbrOfInliers;
    urch = NaN(max(sum(ind)),size(bin,2));
    for cc = find(sum(ind) > 0)
        pp = 1; %loop counter
        for k = find(ind(:,cc))'
            urch(pp,cc) = median(candidates(binNbr(:,cc) == k,cc));
            pp = pp+1;
        end
    end
    uref{ch} = urch;
end

end

%Help function:
function combs = dfcombs(A,B)
%...
%  A, B, same size

[m,n] = size(A);
combs = NaN(m*m,n);
for k = 1:m
    combs(1+(k-1)*m:k*m,:) = A-B;
    B = circshift(B,-1);
end
end