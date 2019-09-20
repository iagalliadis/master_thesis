%function [Ext,Flx, RawData] = load_data(crossValidationTestFold, dataSet, windowLength)%dataSet : 'train' or 'test' or 'evaluation'
function [Ext,Flx, RawData] = load_data(dataSet, windowLength)
%% some constants
mainFolderExtension = 'C:\Temp\MATLAB\masterthesis-data\Final_Database\cutted\G14\ext\';
mainFolderFlexion = 'C:\Temp\MATLAB\masterthesis-data\Final_Database\cutted\G14\flx\';

%% variables holding data
RawData.Ext = {};
RawData.Flx = {};
OutData.Ext = {};
OutData.Flx = {};

if  strcmp(dataSet,'evaluation')
    dirnameExtension = fullfile(mainFolderExtension, dataSet);
    dirnameFlexion = fullfile(mainFolderFlexion, dataSet);
else
    dirnameExtension = fullfile(mainFolderExtension, dataSet);%, num2str(crossValidationTestFold));
    dirnameFlexion = fullfile(mainFolderFlexion, dataSet);%, num2str(crossValidationTestFold));
end

if ~isdir(dirnameExtension);  error(['dir ' dirnameExtension ' does not exist']);  end
if ~isdir(dirnameFlexion);    error(['dir ' dirnameFlexion ' does not exist']);    end

directoryExtensionData = dir(dirnameExtension);
directoryFlexionData = dir(dirnameFlexion);

%% Load raw data from CSV file
for i = 1 : numel(directoryExtensionData)
    filename = fullfile(dirnameExtension,directoryExtensionData(i).name);
    if ~isdir(filename)
        RawData.Ext{numel(RawData.Ext)+1} = csvread(filename);
    end
end

for i = 1 : numel(directoryFlexionData)
    filename = fullfile(dirnameFlexion,directoryFlexionData(i).name);
    if ~isdir(filename)
        RawData.Flx{numel(RawData.Flx)+1} = csvread(filename);
    end
end


%% Obtain windows of length windowLength from raw data and create a long input data matrix
indexCut = [];
for i = 1 : numel(RawData.Ext)
    
    [rows, ~] = size(RawData.Ext{i});
    if rows >= windowLength
        for jj = 0:64: rows - windowLength %%64 is the step
            OutData.Ext{numel(OutData.Ext) + 1} = RawData.Ext{i}(jj+1: jj+windowLength , 2:9);
        end
    else
        indexCut(length(indexCut) + 1) = i;
    end
    Ext = vertcat(OutData.Ext{:});
    droppedExt = length(indexCut);
end

% OutData.Flatten_Ext = zeros(length(OutData.Ext), windowLength*8);
% for i = 1:length(OutData.Ext)
%     OutData.Flatten_Ext(i,:) = OutData.Ext{1,i}(:); % flatten the channels per window
% end


indexCut = [];
for i = 1 : numel(RawData.Flx)
    
    [rows, ~] = size(RawData.Flx{i});
    if rows >= windowLength
        for jj = 0 :64: rows - windowLength %64 is the step
            OutData.Flx{numel(OutData.Flx) + 1} = RawData.Flx{i}(jj+1 : jj+windowLength , 2:9);
        end
    else
        indexCut(length(indexCut) + 1) = i;
    end
    Flx = vertcat(OutData.Flx{:});
    droppedFlx = length(indexCut);
end

% OutData.Flatten_Flx = zeros(length(OutData.Flx), windowLength*8);
% for i = 1:length(OutData.Flx)
%     OutData.Flatten_Flx(i,:) = OutData.Flx{1,i}(:); % flatten the channels per window
% end


end