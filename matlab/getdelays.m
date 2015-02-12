function u = getdelays(scores,settings)
%GETDELAYS -
%

u = cell(settings.mm);

%Getting indeces indu only for the pairs that we have to calculate:
ii = zeros(1,settings.mm);
ii(settings.channels) = 1;
ind = logical(ii'*ii);
indu = triu(ind);

if settings.nbrOfPeaks == 1 %special case for 1 peak (for optimization)
    for k = find(indu)'
        [v,ii] = max(scores{k});
        ii(v < settings.minPeakHeight) = NaN;
        u{k} = ii-settings.sw-1;
    end
else
    for k = find(indu)' 
        [~,ii] = localmax(scores{k},settings.minPeakHeight,settings.nbrOfPeaks);
        u{k} = ii-settings.sw-1;
    end
end

%Filling in the pairs not in indu by mirroring the data:
tmp =  cellfun(@(A) -A,u','UniformOutput',false);
u(tril(ind,-1)) = tmp(tril(ind,-1));
end