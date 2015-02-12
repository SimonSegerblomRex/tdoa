% Script description...

%% Read audio files:
settings.v = 340;        %speed of sound
settings.mm = 8;         %number of microphones
settings.channels = 1:8; %channels to read
settings.refChannel = 1; %reference channel
%[340,8,1:8,1]

[fileNameBase,dataDir,fileExt] = selectsoundfiles();
[a,settings.sr] = readaudio([dataDir fileNameBase],fileExt,settings.mm,...
    settings.channels);
settings.nbrOfSamples = length(a);

%% Correlation:
settings.wf = @(x) 1./(abs(x)+(abs(x)<5e-3)); %weighting function
settings.firstSamplePoint = 1; %center sample point of first frame
settings.frameSize = 2048;     %width of frame in sample points
settings.dx = 1000;            %distance between frames in sample points
settings.frameOverlap = settings.frameSize-settings.dx; %overlap between frames
settings.sw = 800;             %clipping of search window
%Default: [@(x) 1./(abs(x)+(abs(x)<5e-3)),1,2048,1048,800]

scores = gccscores(a,settings);

settings.nbrOfFrames = size(scores{1,1},2);

%Plot:
ch = settings.channels(2); %channel to plot 
figure(1),scoreplot(scores{settings.refChannel,ch},settings)

%% Delays:
settings.nbrOfPeaks = 4;       %max number of peaks
settings.minPeakHeight = 0.01; %min value of local maxima
%Default: [4,0.01]

u = getdelays(scores,settings);

%Plot:
figure(2),scoreplot(scores{settings.refChannel,ch},settings),hold on
plot(1:size(u{settings.refChannel,ch},2),u{settings.refChannel,ch}+settings.sw+1,'*')
legend('1st peak','2nd peak','3rd peak','4th peak')

%% Clean up delays:
settings.binSize = 3;         %inlier threshold
settings.minNbrOfInliers = 3; %min number of matching equations
%Default values: [3,3]

uref = matchingdelays(u,settings);

%Plot:
figure(3),scoreplot(scores{settings.refChannel,ch},settings),hold on
plot(1:size(uref{ch},2),uref{ch}+settings.sw+1,'g*')

%% RANSAC:
settings.RANSACnbrOfIterations = 350;     %number of RANSAC iterations
settings.RANSACframeSize = 21;            %line width
settings.RANSACframeOverlap = 1;          %overlap of lines
settings.RANSACmaxNbrOfGroups = 5;        %max nbr of lines
settings.RANSACminNbrOfInliers = 6;       %min nbr of inliers
settings.RANSACinlierThreshold = 1;     %max distance to line
settings.RANSACsharedPointsThreshold = 2; %max nbr of shared points
settings.RANSACmaxSlope = 3.5;            %max derivative
%Default valuesOld: [350,21,1,5,5,1.5,2,3.5]
%Default valuesOld: [350,21,1,5,7,1.5,2,3.5]
%Default values: [350,21,1,5,6,1,2,3.5]

[delays,lines,ind] = fitdelayswithransac(uref,settings);

%Plot:
figure(4),lineplot(delays{ch},ind,settings)
figure(5),lineplot(lines{ch},ind,settings)

%% Connect lines:
settings.lineDistanceThreshold = 10; %max vertical distance between lines
%Default value: [10]

[delaysegments,linesegments] = connectlines(delays,lines,ind,settings);

%Plot:
figure(6)
segmentplot(scores(settings.refChannel,:),delaysegments,ind,@(x)find(x>0),settings)

%% Connect line-segments:
settings.linesInlierThreshold = 10;
settings.linesOverlap = 5;
settings.linesInlierRatio = 0.15;
[newdelaysegments,newlinesegments] = connectsegments(delaysegments,linesegments,ind,uref,settings);
%Default values: [10,5,0.1]

%Plot:
figure(7)
segmentplot(scores(settings.refChannel,:),newdelaysegments,ind,@(x)find(x==max(x),1,'first'),settings)

%% Smoothing:
settings.smoothingDegree = 0.01; %degree of smoothing of uref
settings.smoothingDistance = 2;  %set to 0 to keep smoothed curve
%Default values: [0.01,2]

urefsmooth = smoothdelays(newdelaysegments,newlinesegments,uref,settings);

%Plot:
figure(8),scoreplot(scores{settings.refChannel,ch},settings),hold on
plot(urefsmooth{ch}+settings.sw+1,'g.')

%% Clip data:
uout = clipdata(urefsmooth,settings);

%Plot:
figure(9),pl = plot(1:length(uout),uout+settings.sw+1,'*');
marks = {'+','o','*','.','x','s','d','^','v','>','<','p','h'}.';
colors = num2cell(hsv(settings.mm),2);
set(pl,{'Marker'},marks(1:settings.mm),{'MarkerFaceColor'},colors,{'MarkerEdgeColor'},colors);
leg = num2cell(1:settings.mm);
leg = cellfun(@(k) ['Channel ' num2str(k)],leg,'UniformOutput',false);
legend(leg)
setaxes(settings)

%% Save data:
if ~exist([fileNameBase 'data.mat'],'file')
    save([fileNameBase 'data'],'settings','u','uref','delays','lines','ind',...
        'delaysegments','linesegments','newdelaysegments','newlinesegments',...
        'urefsmooth','uout')
end

%% Export data:
%Only if you intend to use the 'tdoasystem'-package
exportdata