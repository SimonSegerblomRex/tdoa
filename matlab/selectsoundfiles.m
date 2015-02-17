function [fileNameBase,dataDir,fileExt] = selectsoundfiles(delimeter)
%SELECTSOUNDFILES - Select one of the input sound files
%
%    [fileNameBase,dataDir,fileExt] = SELECTSOUNDFILES()
%    [fileNameBase,dataDir,fileExt] = SELECTSOUNDFILES(delimeter)
%
%    Input (optional):
%    delimeter - string containg the delimeter separating the sound files
%                default value is '-'
%
%    Output:
%    fileNameBase - part of file name before the delimeter
%    dataDir      - path to directory, e.g., 'C:/'
%    fileExt      - file extension, e.g., '.aiff'

if nargin < 1
    delimeter = '-';
end

[file,dataDir] = uigetfile(...
    {'*.wav;*.ogg;*.flac;*.au;*.mp3;*.aac;*.aiff',...
    'Sound files (*.wav, *.ogg, *.flac, *.au, *.mp3, *.aac, *.aiff)';...
    '*.*',  'All Files (*.*)'},...
    'Select one of the sound files in the set');
[~,fileName,fileExt] = fileparts(file);
fileNameBase = strtok(fileName,delimeter);
fileNameBase = [fileNameBase delimeter];
end

