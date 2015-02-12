%% Outputs data compatible with tdoasystem_v5
%Run main first to make sure that all necessary data is available in the
%workspace.

%Additional settings for compatibility with tdoasystem_v5
settings.in = length(uout);
settings.swstep = 1;
settings.wlist = [settings.frameSize];
settings.scorefunction = 'score1';
settings.xinorm = [1 2 4];
settings.doplot = 1;
settings.doverbose = 0;
settings.doprint = 0;
settings.nn = size(a,2);
settings.tt = settings.nn/settings.sr;
settings.isel = floor((1:(settings.in-1))*settings.nn/settings.in);
settings.dsel = (-settings.sw):settings.swstep:settings.sw;
settings.xtid = settings.isel/settings.sr;
settings.ymeter = settings.dsel*settings.v/settings.sr;

%Renaming:
[~,leftLim] = ind2sub(size(uout),find(~isnan(uout),1,'first'));
[~,rightLim] = ind2sub(size(uout),find(~isnan(uout),1,'last'));
matches.uij = uout(:,leftLim:rightLim);
matches.u = matches.uij*settings.v/settings.sr;
matches.uindex = leftLim:rightLim;
matches.utimes = matches.uindex*length(a)/settings.in/settings.sr;
matches.uok = isfinite(matches.uij);

rawmatches = matches;
rns = scores(settings.refChannel,:);
for ch = settings.channels(settings.channels~=settings.refChannel)
    rns{ch} = 1-rns{ch}./repmat(max(rns{ch}),size(rns{ch},1),1);
end

save([dataDir fileNameBase 'A'],'rns','settings','rawmatches')