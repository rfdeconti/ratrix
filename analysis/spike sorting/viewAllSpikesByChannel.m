function  viewAllSpikesByChannel(subjectID, path, cellBoundary, spikeDetectionParams, spikeSortingParams)

if ~exist('plottingParams','var') || isempty(plottingParams)
    plottingParams.showSpikeAnalysis = true;
    plottingParams.showLFPAnalysis = true;
    plottingParams.plotSortingForTesting = true;
end
if ~isfield(spikeSortingParams,'plotSortingForTesting')
    if isfield(plottingParams,'plotSortingForTesting')
        spikeSortingParams.plotSortingForTesting = plottingParams.plotSortingForTesting;
    else
        spikeSortingParams.plotSortingForTesting = false;
    end
end

% needed for physLog boundaryType
neuralRecordsPath = fullfile(path, subjectID, 'neuralRecords');
if ~isdir(neuralRecordsPath)
    neuralRecordsPath
    error('unable to find directory to neuralRecords');
end

if ~exist('cellBoundary','var') || isempty(cellBoundary)
    error('cellBoundary must be a valid input argument - default value is too dangerous here!');
elseif iscell(cellBoundary) && length(cellBoundary)==2
    boundaryType = cellBoundary{1};
    switch boundaryType
        case 'trialRange'
            if any(~isnumeric(cellBoundary{2}))
                error('invalid parameters for trialRange cellBoundary');
            end
            switch length(cellBoundary{2})
                case 2
                    %okay, thats normal
                case 1
                    %start trial is the stop trial
                    cellBoundary{2}=[cellBoundary{2} cellBoundary{2}];
                otherwise
                    error('must be length 2 for [start stop] or a single trial number')
            end
            boundaryRange=[cellBoundary{2}(1) 1 cellBoundary{2}(2) Inf]; % [startTrial startChunk endTrial endChunk]
        otherwise
            error('bad type of cellBoundary!');
    end
    if boundaryRange(1) ~= boundaryRange(3)
         boundaryRange
        error('support only for single trials');
    end
elseif iscell(cellBoundary) && length(cellBoundary)==4
    error('masking not supported');    
else
    error('bad cellBoundary input');
end

% if ~exist('plottingParams','var') || isempty(plottingParams)
%     plottingParams.showSpikeAnalysis = true;
%     plottingParams.showLFPAnalysis = true;
%     plottingParams.plotSortingForTesting = true;
% end
%
% if ~exist('frameThresholds','var') || isempty(frameThresholds)
%     frameThresholds.dropBound = 1.5;   %smallest fractional length of ifi that will cause the long tail to be called a drop(s)
%     frameThresholds.warningBound = 0.1; %fractional difference that will cause a warning, (after drop adjusting)
%     frameThresholds.errorBound = 0.5;   %fractional difference of ifi that will cause an error (after drop adjusting)
%     frameThresholds.dropsAcceptableFirstNFrames=2; % first 2 frames won't kill the default quality test
% end


% if ~exist('paramUtil','var') || isempty(paramUtil)
%    paramUtil=[]; % don't do anything
% end

chansRequired = [1:14]; % hard coded here.
currentTrialNum = boundaryRange(1);

% look for currentTrial's neuralRecord
dirStr=fullfile(neuralRecordsPath,sprintf('neuralRecords_%d-*.mat',currentTrialNum));
d=dir(dirStr);
if length(d)==1
    neuralRecordFilename=d(1).name;
    % get the timestamp
    [matches tokens] = regexpi(d(1).name, 'neuralRecords_(\d+)-(.*)\.mat', 'match', 'tokens');
    if length(matches) ~= 1
        %         warning('not a neuralRecord file name');
    else
        timestamp = tokens{1}{2};
        currentTrialStartTime=datenumFor30(timestamp);
    end
    neuralRecordLocation = fullfile(neuralRecordsPath,sprintf('neuralRecords_%d-%s.mat',currentTrialNum,timestamp));
elseif length(d)>1
    error('duplicates present');
else
    error('didnt find anything in d');
end

% % load the neural data
% load(neuralRecordLocation);

%DETERMINE CHUNKS TO PROCESS

disp('checking chunk names... may be slow remotely...'); tic;
chunkNames=who('-file',neuralRecordLocation);
fprintf(' %2.2f seconds',toc)
chunksToProcess=[];
for i=1:length(chunkNames)
    [matches tokens] = regexpi(chunkNames{i}, 'chunk(\d+)', 'match', 'tokens');
    if length(matches)~=0
        chunksToProcess(end+1) =  str2double(tokens{1}{1});
    end
end
% 
% chunksToProcess = who('chunk*');
% [matches tokens] = regexpi(chunkNames{i}, 'chunk(\d+)', 'match', 'tokens');
% for i = 1:length(tokens)
%     chunkNums(i) = tokens{i}{1};
% end
% [chunksOrdered orderOfChunks] = sort(chunkNums);
chunksToProcess = sort(chunksToProcess);

% make temporary analysis folder and locate the neuralRecordLocation
analysisPathForTrial = fullfile(path,subjectID,'analysis','tempAnalysisFolder',num2str(currentTrialNum));
% spikeRecord.mat will contain info about all the channels for that trial.
spikeRecordLocation=fullfile(path,subjectID,'analysis','tempAnalysisFolder',num2str(currentTrialNum),'spikeRecords.mat');
% first delete folder if it exists
if exist(analysisPathForTrial,'dir')
    [succ,msg,msgID] = rmdir(analysisPathForTrial,'s');  % includes all subdirectory regardless of permissions
    if ~succ
        msg
        error('failed to remove existing files when running with ''overwriteAll=true''')
    end
end
% now make it again
if ~isdir(analysisPathForTrial)
    mkdir(analysisPathForTrial);
end

for currentChunkInd=1:length(chunksToProcess)
        % =================================================================================
        chunkStr=sprintf('chunk%d',chunksToProcess(currentChunkInd));
        fprintf('*********DOING %s*************\n',chunkStr)
        
        % load the chunk
        neuralRecord=stochasticLoad(neuralRecordLocation,{chunkStr,'samplingRate'});
        temp=neuralRecord.samplingRate;
        neuralRecord=neuralRecord.(chunkStr);
        neuralRecord.samplingRate=temp;
        neuralRecord.neuralDataTimes=linspace(neuralRecord.neuralDataTimes(1),neuralRecord.neuralDataTimes(end),size(neuralRecord.neuralData,1))';
        if ~isfield(neuralRecord,'ai_parameters')
            neuralRecord.ai_parameters.channelConfiguration={'framePulse','photodiode','phys1'};
            if size(neuralRecord.neuralData,2)~=3
                error('only expect old unlabeled data with 3 channels total... check assumptions')
            end
        end
        
        
        photoInd=find(strcmp(neuralRecord.ai_parameters.channelConfiguration,'photodiode'));
        pulseInd=find(strcmp(neuralRecord.ai_parameters.channelConfiguration,'framePulse'));
        allPhysInds = find(~cellfun(@isempty, strfind(neuralRecord.ai_parameters.channelConfiguration,'phys')));
        
        % now loop through the channels
        for thisPhysChannelInd = allPhysInds
            analysisPathByChannel = fullfile(analysisPathForTrial,num2str(thisPhysChannelInd));
            if ~exist(analysisPathByChannel,'dir')
                mkdir(analysisPathByChannel);
                spikeRecordCumulative.channelInd = thisPhysChannelInd;
                spikeRecordCumulative.samplingRate = neuralRecord.samplingRate;
                spikeRecordCumulative.spikes = [];
                spikeRecordCumulative.spikeWaveforms = [];
                spikeRecordCumulative.spikeTimestamps = [];
                spikeRecordCumulative.assignedClusters = []
                spikeRecordCumulative.chunkID=[];
            
            else
                temporary = stochasticLoad(fullfile(analysisPathByChannel,'spikeRecordCumulative.mat'));
                spikeRecordCumulative.channelInd = temporary.spikeRecordCumulative.channelInd;
                spikeRecordCumulative.samplingRate = temporary.spikeRecordCumulative.samplingRate;
                spikeRecordCumulative.spikes = temporary.spikeRecordCumulative.spikes;
                spikeRecordCumulative.spikeWaveforms = temporary.spikeRecordCumulative.spikeWaveforms;
                spikeRecordCumulative.spikeTimestamps = temporary.spikeRecordCumulative.spikeTimestamps;
                spikeRecordCumulative.assignedClusters = temporary.spikeRecordCumulative.assignedClusters;
                spikeRecordCumulative.chunkID=temporary.spikeRecordCumulative.chunkID;
            end
            spikeRecord.spikeDetails=[];
            spikeRecord.samplingRate=neuralRecord.samplingRate;
            spikeDetectionParams.samplingFreq=neuralRecord.samplingRate; % always overwrite with current value
            
            % business happens here
            [spikeRecord.spikes spikeRecord.spikeWaveforms spikeRecord.spikeTimestamps spikeRecord.assignedClusters ...
                spikeRecord.rankedClusters]=...
                getSpikesFromNeuralData(neuralRecord.neuralData(:,thisPhysChannelInd),neuralRecord.neuralDataTimes,...
                spikeDetectionParams,spikeSortingParams,analysisPathByChannel);
            
            spikeRecord.chunkID=ones(length(spikeRecord.spikes),1)*chunksToProcess(currentChunkInd);
            
            spikeRecordCumulative.samplingRate = [spikeRecordCumulative.samplingRate];
            spikeRecordCumulative.spikes = [spikeRecordCumulative.spikes;spikeRecord.spikes];
            spikeRecordCumulative.spikeWaveforms = [spikeRecordCumulative.spikeWaveforms;spikeRecord.spikeWaveforms]
            spikeRecordCumulative.spikeTimestamps = [spikeRecordCumulative.spikeTimestamps;spikeRecord.spikeTimestamps];
            spikeRecordCumulative.assignedClusters = [spikeRecordCumulative.assignedClusters;spikeRecord.assignedClusters]
            spikeRecordCumulative.chunkID=[spikeRecordCumulative.chunkID;spikeRecord.chunkID];
            
           % save the cumulative spikeRecord
           currentCumulativeRecordLocation = fullfile(analysisPathByChannel,'spikeRecordCumulative.mat')
           save(currentCumulativeRecordLocation,'spikeRecordCumulative');
           % rename the model files of klusta here to keep them for the next series
           m
        end
        clear (sprintf('chunk%d',chunksToProcess(currentChunkInd)));
        
end