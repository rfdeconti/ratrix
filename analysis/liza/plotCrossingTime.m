function plotCrossingTime(subj)
if ~exist('subj','var') || isempty(subj)
    subj = 'test';
end

%for some reason, compiling these records is failing
%once this is solved we'll load in a single compiled file from ...\ballData\CompiledTrialRecords\
%most of the work in this file does what CompileTrialRecords does

%first, load the trial records and get them in the right order
local = false;
if local
    drive='C:';
else
    drive='\\mtrix5';
end
recordPath = fullfile(drive,'Users','nlab','Desktop','ballData','PermanentTrialRecordStore',subj);

files = dir(fullfile(recordPath,'trialRecords_*.mat'));

bounds = cell2mat(cellfun(@(x)textscan(x,'trialRecords_%u-%u_%*s.mat','CollectOutput',true),{files.name}'));
[bounds,ord] = sort(bounds(:,1));
files = files(ord);

recNum = 0;
for i=1:length(files)
    if bounds(i,1) ~= recNum+1
        error('record file names indicate ordering problem')
    end
    
    fullRecs(i) = load(fullfile(recordPath,files(i).name));
    newRecNum = recNum + length(fullRecs(i).trialRecords);
    records(recNum+1:newRecNum) = fullRecs(i).trialRecords; %extending this struct array is slow, that's why we normally use compiled records
    recNum = newRecNum;
    
    if bounds(i,2) ~= recNum
        error('record file names indicate ordering problem')
    end
    
    fprintf('done with %d of %d\n',i,length(files));
end

trialNums = [records.trialNumber];
if ~all(diff(trialNums) == 1)
    error('records don''t show incrementing trial numbers')
end

startTimes = datenum(cell2mat({records.date}'));
d = diff(startTimes);
sessions = find(d > .02); %this gives us session boundaries whenever there was a half hour gap in the trial start times
if ~all(d > 0)
    error('records don''t show increasing start times')
end

%these session boundaries aren't useful, cuz you may have stopped and started right away again
if ~all(diff([records.sessionNumber]) >= 0)
    error('records don''t show increasing session numbers')
end

%just verify these are empty (not having set this is probably why compiling fails)
if ~all(cellfun(@isempty,{records.correct}))
    error('weird -- records.correct should always be empty (for now we''re not using this field)')
end

%should just be one of two strings -- 'nominal' for most trials, 'manual kill' on the trial where you hit k-q
result = {records.result};
[~,loc] = ismember(result,unique(result));

%this is a record of correct (true) or incorrect (false), but should be empty on 'manual kill' trials
t = [records.trialDetails];
res = cellfun(@(x)f(x),{t.correct});
    function out=f(x)
        if isempty(x)
            out = 2;
        elseif isscalar(x) && islogical(x)
            out = double(x);
        else
            error('unexpected value')
        end
    end

if ~all((res == 2) == (loc == 1))
    error('manual kills didn''t line up with empty corrects')
end

%these trials each have two phases -- a discrimination phase followed by a reinforcement phase
%we take the actual measured reward duration from the reinforcement phase (currently quantized to frame boundaries)
%from the discrimination phase, we take the x,y,t track location measurements
%entries in 'times' are in seconds, corresponding to x,y entries in 'track'
%we also pull out some other info just to do some consistency checking later
[actualRewards nFrames times targ track results] = cellfun(@(x)g(x),{records.phaseRecords},'UniformOutput',false);
    function [a n t targ track r]=g(x)
        if length(x)~=2
            error('expected 2 phases')
        end
        
        a = x(2).actualRewardDurationMSorUL;
        n = x(1).dynamicDetails.nFrames;
        t = x(1).dynamicDetails.times;
        if ~all(diff(t(~isnan(t)))>0)
            error('track timestamps aren''t increasing')
        end
        targ = x(1).dynamicDetails.target;
        track = x(1).dynamicDetails.track;
        if isfield(x(1).dynamicDetails,'result')
            r = x(1).dynamicDetails.result;
            if any(cellfun(@(x)any(isnan(x)),{t track(:)}))
                error('should only happen when there is no result (manual kills)')
            end
        else
            r = '';
            test=repmat(isnan(t),2,1) == isnan(track);
            if ~all(test(:))
                error('test and track didn''t have matching nans')
            end
            if length(find(diff(isnan(t)))) > 1
                error('should be at most one transition from non-nans to nans')
            end
            t=t(~isnan(t));
            track=track(:,~isnan(t));
        end
    end

if ~all(cellfun(@(x,y)length(x)==size(y,2),times,track))
    error('times and track didn''t have same dimension')
end

%no entry was made if there was no motion (and there were missed frames), so the raw number of entries slightly distorts actual duration
len = cellfun(@length,times);
dur = cellfun(@(x)1000*diff(x([1 end])),times);

% i'm seeing a lot of trials (12%) that have only one timestamp
if false %this shows that they position really is past the wall on the first timestamp
    fprintf('%g%% trials have only one timestamp (%g%% of these were correct)\n',100*sum(len==1)/length(len),100*sum(len==1 & res==1)/sum(len==1));
    x=[track{len==1}];
    plot(x(1,:),x(2,:),'.')
end

%verify the following info matches consistently
s = [records.stimDetails];
timeout = [s.nFrames];
targetLocation = [s.target];

if ~all(cell2mat(nFrames)==timeout) % this was the limit on the trial length -- the # of position changes
    error('nFrames didn''t match timeout')
end

if ~all(cell2mat(targ)==targetLocation)
    error('targetLocation and targ didn''t match')
end

if ~all(cellfun(@isempty,results) == (res == 2))
    error('empty results didn''t line up with manual kills')
end

[~,loc]=ismember(results,unique(results));

if ~all(((loc==3) == (res==0)) & ((loc==2) == (res==1)) & ((loc==1) == (res==2)))
    error('correct/timedout results didn''t line up with correctness')
end

%this is set whenever you hit k-ctrl-# to manually open valve
manualRewards = [records.containedForcedRewards];

dur(res~=1 | manualRewards)=nan; %get rid of trials that didn't end nominal correct with no manual rewards

n = 50;
slidingAvg = savg(dur(~isnan(dur)),n);

    function out = savg(x,n)
        out = nanmean(window(pad(x,n,@nan),n));
    end

    function out = pad(x,n,p)
        n = (n-1)/2;
        out = [p(1,ceil(n)) x p(1,floor(n))];
    end

    function out = window(x,n)
        out = x(repmat((1:n)',1,length(x)-n+1)+repmat(0:length(x)-n,n,1));
    end

pTiles = prctile(window(pad(dur,n,@nan),n),25*[-1 1]+50);

alpha=.05;
[~, pci] = binofit(sum(window(res(res~=2),n)),n,alpha);
x=trialNums(res~=2);
x=x(~isnan(pad(zeros(1,size(pci,1)),n,@nan)));

%dig out the reward size we intended to give
r = [records.reinforcementManager];
intendedRewards = [r.rewardSizeULorMS];

%interframe intervals (in secs, should be 1/60 for 60Hz)
s = [records.station];
ifis = [s.ifi];

%plot some stuff!
close all
n = 4;

dotSize=20;
if ismac
    dotSize=10; %usually has to be smaller on mac
    warning('haven''t picked a nice dot size for mac')
end
colormap([1 0 0;0 1 0]); %red for non-corrects, green for corrects
grey = .65*ones(1,3);
transparency=.2; %calling semilogy causes transparency to fail even on other axes!

subplot(n,1,1)
correctPlot(cell2mat(actualRewards));
hold on
plot(trialNums,intendedRewards,'k')
ylims = [0 max(intendedRewards)*1.5];
ylabel('reward size (ms)')
title(subj)
standardPlot(@plot);

    function standardPlot(f)
        ylim(ylims)
        xlim([1 length(records)])
        
        for i=1:length(sessions)
            f(sessions(i)*ones(1,2),ylims,'Color',grey)
        end
    end

    function correctPlot(x)
        scatter(trialNums,x,dotSize,(res==1)+1);
    end

    function rangePlot(x,y)
        fill([x fliplr(x)],[y(1,:) fliplr(y(2,:))],'k','FaceAlpha',transparency,'LineStyle','none');
    end

subplot(n,1,2)
correctPlot(len); %can see occasional red k-q's with len < timeout
hold on
plot(trialNums,timeout,'k')
ylims = [0 max(len)*1.5];
ylabel('movements to crossing')
standardPlot(@plot);

subplot(n,1,3)
if true
    p=@plot;
else
    p=@semilogy; %using semilogy causes transparency in next plot to fail!  using plot resolves it.
end
p(trialNums,dur,'g.')
hold on
xd=trialNums(~isnan(dur));
rangePlot(xd,pTiles);
p(xd,slidingAvg,'k')
p(trialNums,nanmean(dur),'Color',grey);
ylims = [min(dur(dur>0)) max(dur)*1.5]; % semilogy on 0 fails
ylabel('ms to crossing')
standardPlot(p);
a = gca;
set(a,'YScale','log'); %preserves transparency?

subplot(n,1,4)
rangePlot(x,pci');
hold on
ylims = [0 1];
ylabel('% correct')
standardPlot(@plot);

xlabel('trial')
end