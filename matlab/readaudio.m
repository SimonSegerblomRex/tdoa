function [a,sr] = readaudio(fileNameBase,fileExtension,mm,channels)
%READAUDIO - Read audio files
%
%    This function returns a matrix containing audio data from the files 
%    specified with the input arguments. All files must have the same
%    sample rate and names ending with 1,..,mm
%
%    [a,sr] = READAUDIO(fileNameBase,fileExtension,mm)
%
%    Input:
%    fileNameBase  - filenamebase including path, e.g, 'C:/foo-' if the
%                    filenames are 'C:/foo-1.aiff','C:/foo-2.aiff',...
%    fileExtension - file extension, e.g., '.aiff'
%    channels      - vector with channel numbers, e.g., 1:8, or [2,3,5,8]
%
%    Output:
%    a  - matrix where each row contains the samples of corresponding file
%    sr - sample rate

ainfo = audioinfo([fileNameBase num2str(channels(1)) fileExtension]);
sr = ainfo.SampleRate;
a = zeros(mm,ainfo.TotalSamples);
for k = channels
    a(k,:) = audioread([fileNameBase num2str(k) fileExtension]);
end
end