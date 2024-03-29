function r = setProtocolHvV_center_vertical(r,subjIDs)

if ~isa(r,'ratrix')
    error('need a ratrix')
end

if ~all(ismember(subjIDs,getSubjectIDs(r)))
    error('not all those subject IDs are in that ratrix')
end

sm=makeStandardSoundManager();

rewardSizeULorMS          =80;
requestRewardSizeULorMS   =20;
requestMode               ='first';
msPenalty                 =3500;
fractionOpenTimeSoundIsOn =1;
fractionPenaltySoundIsOn  =1;
scalar                    =1;
msAirpuff                 =msPenalty;

% sca
% keyboard

if ~isscalar(subjIDs)
    error('expecting exactly one subject')
end
switch subjIDs{1}
   case 'gcam33lt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 70;
%    case 'sg4lt'
%          requestRewardSizeULorMS = 0;
%          rewardSizeULorMS        = 100;
   case 'gcam17rn'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 30;
   case 'gcam21rt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 60;
   case 'wg4rt'
        requestRewardSizeULorMS = 0; 
   case 'gcam30lt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 80;
   case 'gcam30rn'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 60;
   case 'gcam35lt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 60;    
%    case 'gcam39rt'
%         requestRewardSizeULorMS = 0;
%         rewardSizeULorMS        = 100;
   case 'gcam39tt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 50; 
   case 'gcam40lt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 60;
   case 'gcam44lt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 45;
   case 'gcam45tt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 35;
   case 'gcam53ln'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 45; 
   case 'g54a11rt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 80;   
   case 'g54a11tt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 60;     
   case 'gcam25rt'
        requestRewardSizeULorMS = 0;
        rewardSizeULorMS        = 70;
   case 'bfly21rt'
       requestRewardSizeULorMS = 5;
       rewardSizeULorMS        = 80;
       
    otherwise
        warning('unrecognized mouse, using defaults')
end

noRequest = constantReinforcement(rewardSizeULorMS,requestRewardSizeULorMS,requestMode,msPenalty,fractionOpenTimeSoundIsOn,fractionPenaltySoundIsOn,scalar,msAirpuff);

percentCorrectionTrials = .5;

maxWidth  = 1920;
maxHeight = 1080;

[w,h] = rat(maxWidth/maxHeight);
textureSize = 10*[w,h];
zoom = [maxWidth maxHeight]./textureSize;

svnRev = {'svn://132.239.158.177/projects/ratrix/trunk'};
svnCheckMode = 'session';

interTrialLuminance = .5;

stim.gain = 0.7 * ones(2,1);
stim.targetDistance = 500 * ones(1,2);
stim.timeoutSecs = 10;
stim.slow = [40; 80]; % 10 * ones(2,1);
stim.slowSecs = 1;
stim.positional = false;
stim.cue = true;
stim.soundClue = true;

pixPerCycs             = [100]; %*10^9;
targetOrientations     = 0
distractorOrientations = []; %-targetOrientations;
mean                   = .5;
radius                 = .35;
contrast               = 1;
thresh                 = .00005;
normalizedPosition      = [.5];
scaleFactor            = 0; %[1 1];
axis                   = pi/2;







% s = orientedGabors([pixPerCycs],[targetOrientations],[distractorOrientations],mean,radius,contrasts,thresh,normalizedPosition,maxWidth,maxHeight,scaleFactor,interTrialLuminance,[waveform],[normalizedSizeMethod],[axis])
% orientations in radians
% mean, contrasts, normalizedPosition (0 <= value <= 1)

% stim.stim = orientedGabors(pixPerCycs,targetOrientations,distractorOrientations,mean,radius,contrast,thresh,yPosPct,maxWidth,maxHeight,zoom,interTrialLuminance);
% ballSM = trail(stim,maxWidth,maxHeight,zoom,interTrialLuminance);
%;
% ts1 = trainingStep(ballTM, ballSM, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode); %ball

%%% abstract orientation (e.g. 0 = go left, pi/2 = go right)
targetOrientations = pi/2;
distractorOrientations = 0;

stim.stim = orientedGabors(pixPerCycs,{distractorOrientations [] targetOrientations},'abstract',mean,radius,contrast,thresh,normalizedPosition,maxWidth,maxHeight,scaleFactor,interTrialLuminance,[],[],axis);
 ballSM = trail(stim,maxWidth,maxHeight,zoom,interTrialLuminance);
 ballTM = ball(percentCorrectionTrials,sm,noRequest);
 
 ballSM = setReinfAssocSecs(trail(stim,maxWidth,maxHeight,zoom,interTrialLuminance),1);
 %change stim to stay on for 1 sec after
 
 ts1 = trainingStep(ballTM, ballSM, repeatIndefinitely(), noTimeOff(), svnRev, svnCheckMode); %ball
 
 p=protocol('mouse',{ts1});
%p=protocol('mouse',{ts1,ts2});

stepNum=uint8(1);
subj=getSubjectFromID(r,subjIDs{1});
[subj r]=setProtocolAndStep(subj,p,true,false,true,stepNum,r,'LY01 (40,80), R=36','edf');
end