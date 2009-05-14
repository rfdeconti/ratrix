function [analysisdata] = physAnalysis(stimManager,spikeData,stimulusDetails,plotParameters,parameters,analysisdata,eyeData)
% stimManager is the stimulus manager
% spikes is a logical vector of size (number of neural data samples), where 1 represents a spike happening
% frameIndices is an nx2 array of frame start and stop indices - [start stop], n = number of frames
% stimulusDetails are the stimDetails from calcStim (hopefully they contain all the information needed to reconstruct stimData)
% photoDiode - currently not used
% plotParameters - currently not used


%SET UP RELATION stimInd <--> frameInd
analyzeDrops=true;
if analyzeDrops
    stimFrames=spikeData.stimIndices;
    frameIndices=spikeData.frameIndices;
else
    numStimFrames=max(spikeData.stimIndices);
    stimFrames=1:numStimFrames;
    firstFramePerStimInd=~[0 diff(spikeData.stimIndices)==0];
    frameIndices=spikeData.frameIndices(firstFramePerStimInd);
end


doSTC=false;

% stimData is the entire movie shown for this trial
% removed 1/26/09 and replaced with stimulusDetails
% reconstruct stimData from stimulusDetails - stimManager specific method
if (ischar(stimulusDetails.strategy) && strcmp(stimulusDetails.strategy,'expert')) || ...
        (exist('fieldsInLUT','var') && ismember('stimDetails.strategy',fieldsInLUT) && strcmp(LUTlookup(sessionLUT,stimulusDetails.strategy),'expert'))
    seeds=stimulusDetails.seedValues;
    spatialDim = stimulusDetails.spatialDim;

    if isfield(stimulusDetails,'distribution')
        switch stimulusDetails.distribution.type
            case 'gaussian'
                std = stimulusDetails.distribution.std;
                meanLuminance = stimulusDetails.distribution.meanLuminance;
            case 'binary'
                p=stimulusDetails.distribution.probability;
                hiLoDiff=(stimulusDetails.distribution.hiVal-stimulusDetails.distribution.lowVal);
                std=hiLoDiff*p*(1-p);
                meanLuminance=(p*stimulusDetails.distribution.hiVal)+((1-p)*stimulusDetails.distribution.lowVal);
        end
    else
        %old convention prior to april 17th, 2009
        stimulusDetails.distribution.type='gaussian';
        std = stimulusDetails.std;
        meanLuminance = stimulusDetails.meanLuminance;
    end
end

height=stimulusDetails.height;
width=stimulusDetails.width;

%  stimData=zeros(height,width,length(seeds)); % method 1
stimData=nan(spatialDim(2),spatialDim(1),length(stimFrames)); % method 2
for i=1:length(stimFrames)

    %recompute stim - note: all sha1ing would have to happen w/o whiteVal and round
    whiteVal=255;
    switch stimulusDetails.distribution.type
        case 'gaussian'
            % we only have enough seeds for a single repeat of whiteNoise; if numRepeats>1, need to modulo
            %randn('state',seeds(mod(stimFrames(i)-1,length(seeds))+1));
            randn('state',seeds(stimFrames(i)));
            stixels = round(whiteVal*(randn(spatialDim([2 1]))*std+meanLuminance));
            stixels(stixels>whiteVal)=whiteVal;
            stixels(stixels<0)=0;
        case 'binary'
            rand('state',seeds(mod(stimFrames(i)-1,length(seeds))+1));
            stixels = round(whiteVal* (stimulusDetails.distribution.lowVal+(double(rand(spatialDim([2 1]))<stimulusDetails.distribution.probability)*hiLoDiff)));
        otherwise
            error('never')
    end

    %stixels=randn(spatialDim);  % for test only
    % =======================================================
    % method 1 - resize the movie frame to full pixel size
    % for each stixel row, expand it to a full pixel row
    %                         for stRow=1:size(stixels,1)
    %                             pxRow=[];
    %                             for stCol=1:size(stixels,2) % for each column stixel, repmat it to width/spatialDim
    %                                 pxRow(end+1:end+factor) = repmat(stixels(stRow,stCol), [1 factor]);
    %                             end
    %                             % now repmat pxRow vertically in stimData
    %                             stimData(factor*(stRow-1)+1:factor*stRow,:,i) = repmat(pxRow, [factor 1]);
    %                         end
    %                         % reset variables
    %                         pxRow=[];
    % =======================================================
    % method 2 - leave stimData in stixel size
    stimData(:,:,i) = stixels;

    % =======================================================
end

if any(isnan(stimData))
    error('missed a frame in reconstruction')
end


% refreshRate - try to retrieve from neuralRecord (passed from stim computer)
if isfield(parameters, 'refreshRate')
    refreshRate = parameters.refreshRate;
else
    refreshRate = 100;
end

% timeWindowMs
timeWindowMs=[300 50]; % parameter [300 50]

%Check num stim frames makes sense
if size(spikeData.frameIndices,1)~=size(stimData,3)
    calculatedNumberOfFrames = size(spikeData.frameIndices,1)
    storedNumberOfFrames = size(stimData,3)
    error('the number of frame start/stop times does not match the number of movie frames');
end

%CHOOSE CLUSTER
spikes=spikeData.spikes; %all waveforms
waveInds=find(spikes); % location of all waveforms
if isstruct(spikeData.spikeDetails) && ismember({'processedClusters'},fields(spikeData.spikeDetails))
    thisCluster=spikeData.spikeDetails.processedClusters==1;
else
    thisCluster=logical(ones(size(waveInds)));
    %use all (photodiode uses this)
end
spikes(waveInds(~thisCluster))=0; % set all the non-spike waveforms to be zero;


% count the number of spikes per frame
% spikeCount is a 1xn vector of (number of spikes per frame), where n = number of frames
spikeCount=zeros(1,size(frameIndices,1));
for i=1:length(spikeCount) % for each frame
    spikeCount(i)=sum(spikes(frameIndices(i,1):frameIndices(i,2)));  % inclusive?  policy: include start & stop
end

% calculate the number of frames in the window for each spike
timeWindowFrames=ceil(timeWindowMs*(refreshRate/1000));


%figure out which spikes to use based on eyeData
if ~isempty(eyeData) & 0
    [px py crx cry eyeTime]=getPxyCRxy(eyeData);
    eyeSig=[crx-px cry-py];


    if length(unique(eyeSig(:,1)))>10 % if at least 10 x-positions
        
        regionBoundsXY=[.5 .5]; % these are CRX-PY bounds of unknown degrees
        [within ellipses]=selectDenseEyeRegions(eyeSig,1,regionBoundsXY);

        
        % currently only look at frames in which each sample was within
        % bounds (conservative)
        %framesEyeSamples=unique(eyeData.eyeDataFrameInds);  % this is not every frame!
        framesSomeEyeWithin=unique(eyeData.eyeDataFrameInds(within));  % at least one sable within
        framesSomeEyeNotIn=unique(eyeData.eyeDataFrameInds(~within));  % at least one smple without
        framesAllEyeWithin=setdiff(framesSomeEyeWithin,framesSomeEyeNotIn);
  

        
        if 0 %remove when eye out of bound and view temporal selected data
            warning('don''t know if eyeDataFrameInds are the correct values -  need to check frame drops, etc')
            %stimFrameseyeData.eyeDataFrameInds)...?
            %stimFrames(framesSomeEyeNotIn)...?
            
            figure
            %plot(eyeTime, eyeSig(:,1),'k',eyeTime(within), eyeSig(within,1),'c.')
            plot(eyeData.eyeDataFrameInds, eyeSig(:,1),'k',eyeData.eyeDataFrameInds(within), eyeSig(within,1),'c.')
            hold on; plot(stimFrames,spikeCount,'r')
            
            spikeCount(framesSomeEyeNotIn)=0;  % need to know if these are stimFramesor Nth frame that occured...
            plot(stimFrames,spikeCount,'c');
        end
        
    end
end


% grab the window for each spike, and store into triggers
% triggers is a 4-d matrix:
% each 3d element is a movie corresponding to the spike (4th dim)
numSpikingFrames=sum(spikeCount>0);
numSpikes = sum(spikeCount)
triggerInd = 1;
% triggers = zeros(stim_width, stim_height, # of window frames per spike, number of spikes)
%initialize trigger with mean values for temporal border padding
meanValue=whiteVal*meanLuminance;
triggers=meanValue(ones(size(stimData,1),size(stimData,2),sum(timeWindowFrames)+1,numSpikes)); % +1 is for the frame that is on the spike
for i=find(spikeCount>0) % for each index that has spikes
    %every frame with a spike count, gets included... it is multiplied by the number of spikes in that window
    framesBefore = timeWindowFrames(1);
    framesAfter = timeWindowFrames(2);
    % border handling (if spike was in first frame, cant get any framesBefore)
    if i-framesBefore <= 0
        framesBefore = i-1;
    end
    if i+framesAfter > size(stimData,3)
        framesAfter = size(stimData,3) - i - 1;
    end
    % and in a stim trigger for each spike
    triggers(:,:,1:framesBefore+framesAfter+1,triggerInd:(triggerInd+spikeCount(i)-1))= ...
        repmat(stimData(:,:,[i-framesBefore:i+framesAfter]),[1 1 1 spikeCount(i)]); % pad for border handling?
    triggerInd = triggerInd+spikeCount(i);
end

% spike triggered average
STA=mean(triggers,4);    %the mean over instances of the trigger
try
    STV=var(triggers,0,4);  %the variance over instances of the trigger (not covariance!)
    % this is not the "unbiased variance" but the second moment of the sample about its mean
catch ex
    getReport(ex); % common place to run out of memory
    STV=nan(size(STA)); % thus no confidence will be reported
end
doSpatial=~(size(STA,1)==1 & size(STA,2)==1); % if spatial dimentions exist

if doSTC & strcmp(stimulusDetails.distribution.type,'gaussian') % - not allowed on binary w/o adjustment
    st=cumprod(size(triggers));
    if ~doSpatial
        figure(min(analysisdata.cumulativeTrialNumbers))
        subplot(1,2,2)
        t=shiftDim(triggers)';
        sta1=(mean(t)-128);
        sta1=sta1./norm(sta1,2);
        c=cov(t-repmat(mean(t),size(t,1),1));
        [u s v]=svd(c);
        eig=diag(s); e=eig/max(eig); n=sum(cumsum(e)<0.1*sum(e)); %10% of variance
        hold off; plot(e-min(e),'color',[.8 1 .8]);
        hold on; plot([1:n],e(1:n)-min(e),'.g')
        a=plot(v(:,1),'r'); b=plot(sta1);
        legend([a b],{'sta','stc1'},'location','southwest')
        set(gca,'XTick',[],'XLim',[1 length(sta1)]);
        set(gca,'YTick',[])
        ylabel('RGB(gunVal)')
        xlabel(sprintf('msec - STC trial (%d)',analysisdata.trialNumber))
        subplot(1,2,1)
    end
end

% fill in analysisdata with new values
analysisdata.STA = STA;
analysisdata.STV = STV;
analysisdata.numSpikes = numSpikes;
analysisdata.trialNumber=parameters.trialNumber;
% if the cumulative values don't exist (first analysis)
if ~isfield(analysisdata, 'cumulativeSTA')  || hasNewParameters(stimManager,analysisdata,stimulusDetails) %first trial through with these parameters

    analysisdata.cumulativeSTA = STA;
    analysisdata.cumulativeSTV = STV;
    analysisdata.cumulativeNumSpikes = analysisdata.numSpikes;
    analysisdata.cumulativeTrialNumbers=parameters.trialNumber;
    analysisdata.distribution=stimulusDetails.distribution;
    analysisdata.singleTrialTemporalRecord=[];
    addSingleTrial=true;
elseif ~ismember(parameters.trialNumber,analysisdata.cumulativeTrialNumbers) %only for new trials

    % set STA and STV to weighted probability mass of num events (==spike count)
    analysisdata.cumulativeSTA = (analysisdata.cumulativeSTA*analysisdata.cumulativeNumSpikes + STA*analysisdata.numSpikes) / ...
        (analysisdata.cumulativeNumSpikes + analysisdata.numSpikes);
    analysisdata.cumulativeSTV = (analysisdata.cumulativeSTV*analysisdata.cumulativeNumSpikes + STV*analysisdata.numSpikes) / ...
        (analysisdata.cumulativeNumSpikes + analysisdata.numSpikes);
    %then increment the cumulative count
    analysisdata.cumulativeNumSpikes = analysisdata.cumulativeNumSpikes + analysisdata.numSpikes;
    analysisdata.cumulativeTrialNumbers(end+1)=parameters.trialNumber;

    addSingleTrial=true;

else % repeat sweep through same trial
    %do nothing
    addSingleTrial=false;
end

if  addSingleTrial
    %this trial..history of bright ones saved
    analysisdata.singleTrialTemporalRecord(end+1,:)=getTemporalSignal(STA,STV,numSpikes,'bright');
end

% cumulative
[brightSignal brightCI brightInd]=getTemporalSignal(analysisdata.cumulativeSTA,analysisdata.cumulativeSTV,analysisdata.cumulativeNumSpikes,'bright');
[darkSignal darkCI darkInd]=getTemporalSignal(analysisdata.cumulativeSTA,analysisdata.cumulativeSTV,analysisdata.cumulativeNumSpikes,'dark');

rng=[min(analysisdata.cumulativeSTA(:)) max(analysisdata.cumulativeSTA(:))];


%figure(plotParameters.handle); % make the figure current and then plot into it
figure(min(analysisdata.cumulativeTrialNumbers)) % trialBased is better
set(gcf,'position',[100 400 800 700])



% %% spatial signal (best via bright)
if doSpatial


    %fit model to best spatial
    stdThresh=1;
    [STAenvelope STAparams] =fitGaussianEnvelopeToImage(analysisdata.cumulativeSTA(:,:,brightInd(3)),stdThresh,false,false,false);
    cx=STAparams(2)*size(STAenvelope,2)+1;
    cy=STAparams(3)*size(STAenvelope,1)+1;
    stdx=size(STAenvelope,2)*STAparams(5);
    stdy=size(STAenvelope,1)*STAparams(5);
    e1 = fncmb(fncmb(rsmak('circle'),[stdx*1 0;0 stdy*1]),[cx;cy]);
    e2 = fncmb(fncmb(rsmak('circle'),[stdx*2 0;0 stdy*2]),[cx;cy]);
    e3 = fncmb(fncmb(rsmak('circle'),[stdx*3 0;0 stdy*3]),[cx;cy]);


    %get significant pixels and denoised spots
      switch stimulusDetails.distribution.type
        case 'gaussian'
             stdStimulus = std*whiteVal;
        case 'binary'
            stdStimulus = std*whiteVal*100; % somthing very large to prevent false positives... need to figure it out analytically.. maybe use different function
            %std=hiLoDiff*p*(1-p);
    end
    meanLuminanceStimulus = meanLuminance*whiteVal;
    [bigSpots sigPixels]=getSignificantSTASpots(analysisdata.cumulativeSTA(:,:,brightInd(3)),analysisdata.cumulativeNumSpikes,meanLuminanceStimulus,stdStimulus,ones(3),3,0.05);
    [bigIndY bigIndX]=find(bigSpots~=0);
    [sigIndY sigIndX]=find(sigPixels~=0);


    subplot(2,2,1)
    imagesc(squeeze(analysisdata.cumulativeSTA(:,:,brightInd(3))),rng);
    colorbar; %colormap(blueToRed(meanLuminanceStimulus,rng));
    hold on; plot(brightInd(2), brightInd(1),'yo')
    hold on; plot(darkInd(2)  , darkInd(1),  'yo')
    hold on; plot(bigIndX     , bigIndY,     'y.')
    hold on; plot(sigIndX     , sigIndY,     'y.','markerSize',1)
    xlabel(sprintf('cumulative %s (%d-%d)',stimulusDetails.distribution.type,min(analysisdata.cumulativeTrialNumbers),max(analysisdata.cumulativeTrialNumbers)))
    fnplt(e1,1,'g'); fnplt(e2,1,'g'); fnplt(e3,1,'g'); % plot elipses


    subplot(2,2,2)
    hold off; imagesc(squeeze(STA(:,:,brightInd(3))),[min(STA(:)) max(STA(:))]);
    hold on; plot(brightInd(2), brightInd(1),'yo')
    hold on; plot(darkInd(2)  , darkInd(1),'yo')
    colorbar;  
    colormap(gray);
    %colormap(blueToRed(meanLuminanceStimulus,rng,true));
    fnplt(e1,1,'g'); fnplt(e2,1,'g'); fnplt(e3,1,'g'); % plot elipses
    xlabel(sprintf('this trial (%d)',analysisdata.trialNumber))

    subplot(2,2,3)


end

timeMs=linspace(-timeWindowMs(1),timeWindowMs(2),size(STA,3));
ns=length(timeMs);
hold off; plot(timeWindowFrames([1 1])+1, [0 whiteVal],'k');
hold on;  plot([1 ns],meanLuminance([1 1])*whiteVal,'k')
plot([1:ns], analysisdata.singleTrialTemporalRecord, 'color',[.8 .8 1])

fh=fill([1:ns fliplr([1:ns])]',[darkCI(:,1); flipud(darkCI(:,2))],'b'); set(fh,'edgeAlpha',0,'faceAlpha',.5)
fh=fill([1:ns fliplr([1:ns])]',[brightCI(:,1); flipud(brightCI(:,2))],'r'); set(fh,'edgeAlpha',0,'faceAlpha',.5)
plot([1:ns], darkSignal(:)','b')
plot([1:ns], brightSignal(:)','r')

peakFrame=find(brightSignal==max(brightSignal(:)));
peakFrame=peakFrame(1); % if tied, take first
timeInds=[1 peakFrame timeWindowFrames(1)+1 size(STA,3)];

set(gca,'XTickLabel',unique(timeMs(timeInds)),'XTick',unique(timeInds),'XLim',minmax(timeInds));
set(gca,'YLim',[minmax([analysisdata.singleTrialTemporalRecord(:)' darkCI(:)' brightCI(:)'])+[-5 5]])
ylabel('RGB(gunVal)')
xlabel(sprintf('msec -- cumulative STA(%d-%d)',min(analysisdata.cumulativeTrialNumbers),max(analysisdata.cumulativeTrialNumbers)))

if doSpatial 
    subplot(2,2,4)
    
    if false % turn off montage for eye data
        montage(reshape(analysisdata.cumulativeSTA,[size(STA,1) size(STA,2) 1 size(STA,3) ] ),'DisplayRange',rng)
        colormap(blueToRed(meanLuminanceStimulus,rng,true));
        % %% spatial signal (all)
        % for i=1:
        % subplot(4,n,2*n+i)
        % imagesc(STA(:,:,i),'range',[min(STA(:)) min(STA(:))]);
        % end
    else  
        if exist('ellipses','var')
            plotEyeElipses(eyeSig,ellipses,within,true);
        else
            msg=sprintf('no good eyeData on trial %d\n will analyze all data',parameters.trialNumber)
            text(.5,.5, msg)
        end       
    end
end

drawnow

function [sig CI ind]=getTemporalSignal(STA,STV,numSpikes,selection)

switch selection
    case 'bright'
        [ind]=find(STA==max(STA(:)));  %shortcut for a relavent region
    case 'dark'
        [ind]=find(STA==min(STA(:)));
    otherwise
        error('bad selection')
end

ind=ind(1); %use the first one if there is a tie. (more common with low samples)

[X Y T]=ind2sub(size(STA),ind);
ind=[X Y T];
sig = STA(X,Y,:);
if nargout>1
    er95= sqrt(STV(X,Y,:)/numSpikes)*1.96; % b/c std error(=std/sqrt(N)) of mean * 1.96 = 95% confidence interval for gaussian, norminv(.975)
    CI=repmat(sig(:),1,2)+er95(:)*[-1 1];
end


function new=hasNewParameters(stimManager,analysisdata,stimulusDetails) %first trial through with these parameters
new=false;

%different size
if  ~all(size(analysisdata.STA)==size(analysisdata.cumulativeSTA)) 
    new=true;
end

%different distribution
if ~strcmp(analysisdata.distribution.type,stimulusDetails.distribution.type) 
        new=true;
end

%different parameters - a pretty general check of the params
if ~new % only  check if they are the same distribution
    f=fields(stimulusDetails.distribution);
    numFields=length(f); 
    %check all numverical parameters (note for future: won't work for uneven vector lengths or strings)
    for i=2:numFields; % skip type i=1
        if ~all(stimulusDetails.distribution.(f{i})==analysisdata.distribution.(f{i}))
             new=true;
        end
    end
end
            
            
    