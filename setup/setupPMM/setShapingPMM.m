function r=setShapingPMM(r,subjects, protocolType, protocolVersion, defaultSettingsDate, persistTrainingSteps)
%master shaping template for detection, goTo, or tilt discrimination tasks

if ~exist('subjects', 'var')  || isempty(subjects)
    subjects={'test','test2'}
end

if ~exist('protocolType', 'var')  || isempty(protocolType)
    protocolType='goToSide'
end

if ~exist('protocolVersion', 'var') || isempty(protocolVersion)
    protocolVersion='1_0'
end

if ~exist('defaultSettingsDate', 'var') || isempty(defaultSettingsDate)
    defaultSettingsDate='Oct.09,2007'  %datestr(now,22)
end

if ~exist('persistTrainingSteps', 'var')
    persistTrainingSteps=1; %this is if you have to reinit... we'll give you the trainingStep from previous ratrix
end




%% define shared and constant parameters for all rats

%% default for all of pmeier stims
default=getDefaultParameters(ifFeatureGoRightWithTwoFlank,protocolType,protocolVersion,defaultSettingsDate);

%% parameters for each shaping step

nameOfShapingStep{1} = sprintf('Step 2a: Easy %s, friendly', protocolType);
parameters=default;
parameters.requestRewardSizeULorMS             =30;
parameters.msPenalty=1000;
parameters.scheduler=minutesPerSession(90,3);
%parameters.scheduler = nTrialsThenWait([1000],[1],[0.01],[1]);
%%noTimeOff()
parameters.graduation = rateCriterion(5,5);
[easy previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});

switch protocolVersion
    case '1_2'
        %optional step overrides easy but lacks weening off of ms request reward duration
        nameOfShapingStep{1} = sprintf('Step 2x: Easy %s, with Hint', protocolType);
        parameters=default;
        parameters.requestRewardSizeULorMS=30; % make this go down?
        parameters.msPenalty=4000;
        parameters.positionalHint=0.2;
        parameters.scheduler=minutesPerSession(90,3);
        parameters.graduation = performanceCriterion([0.85, 0.8],int16([200, 500])); %this could become a criteria that weens rats off of hint
        %parameters.graduation = performanceCriterion([0.95,0.9,0.85, 0.8],int16([50,100,200, 500]));
        [easyHint previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});
        parameters=previousParameters;
        parameters.positionalHint=0;
    case '2_5validate'
        parameters=previousParameters;

%         dynamicSweep.sweepMode={'ordered'};
%         dynamicSweep.sweptValues=[];
%         dynamicSweep.sweptParameters={'targetOrientation', 'flankerOrientation'};
%         dynamicSweep.ISI=10;
%         dynamicSweep.ISMean=0.5;
% 
%         fitRF.fitMethod='elipse';
%         fitRF.which='last';
%         fitRF.medianFilter=logical(ones(3));
%         fitRF.alpha=0.05;
%         fitRF.numSpotsPerSTA=1;
%         fitRF.spotSizeInSTA=10;

        %basic setup
        parameters.blocking.blockingMethod='nTrials';
        parameters.blocking.nTrials=3; %100
        parameters.blocking.sweptParameters={'targetOrientations','flankerOrientations'};
        parameters.blocking.sweptValues=generateFlankerFactorialCombo(ifFeatureGoRightWithTwoFlank, parameters.blocking.sweptParameters, {'ordered'}, parameters);

    otherwise
        parameters=previousParameters;
end

nameOfShapingStep{end+1} = sprintf('Step 2b: Easy %s, stringent', protocolType);

parameters.requestRewardSizeULorMS=0;
switch protocolType
    case 'goToRightDetection'
        parameters.msPenalty=4000; % keep at 4 secs
    case 'goToLeftDetection'
        parameters.msPenalty=4000; % keep at 4 secs
    otherwise
        parameters.msPenalty=10000;
end

switch protocolVersion
    case '2_1' %easier graduation
        parameters.graduation = performanceCriterion([0.83,0.8],int16([100,200])); %lower bound CI: ~0.74
    otherwise
        parameters.graduation = performanceCriterion([0.85, 0.8],int16([200, 500]));
end

%parameters.graduation = performanceCriterion([0.85, 0.8],int16([10, 500])); % just for testing
[stringent previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});

nameOfShapingStep{end+1} = sprintf('Step 2c: Linearized %s, stringent', protocolType);
parameters=previousParameters;
parameters.mean = 0.5;
parameters.typeOfLUT= 'linearizedDefault';
parameters.rangeOfMonitorLinearized=[0.0 0.5];
[linearized previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});

nameOfShapingStep{end+1} = sprintf('Step 2d: Thinner %s, stringent', protocolType);
parameters=previousParameters;
parameters.pixPerCycs =32;
[thinner previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});

nameOfShapingStep{end+1} = sprintf('Step 2e: Smaller %s, stringent', protocolType);
parameters=previousParameters;
parameters.stdGaussMask = 1/16;
[smaller smallParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});


%optional alternate for some protocols
nameOfShapingStep{end+1} = sprintf('Step 2f: Shrinking %s, stringent', protocolType);
parameters=previousParameters;
if parameters.stdGaussMask>=1/5;
    %we always expect this to shrink the mask for tilters
    parameters.stdGaussMask = 1/5;
else
    %sometimes we started out with something smaller (go to side)
    %but this does not rely on the size shinking yet
    %but it would be okay, it
    if default.stdGaussMask<1/5 && ismember(protocolType,{'goToSide','tiltDiscrim'})
        %started out that small, okay in all goToSide and some
        %tiltDiscrim with positional hint (1/8)
        %will just start shrinking form its previous size
    else
        error('don''t make it bigger!  only goToSide is expected to be smaller as of now')
    end

end

parameters.shapedParameter='stdGaussMask';
parameters.shapingMethod='linearChangeAtCriteria';
parameters.shapingValues.numSteps=int8(9);
parameters.shapingValues.performanceLevel= [0.9,0.85,0.82,0.8];   %using conf at ~.78;   for confidence at .85: [0.95,0.9,0.85,0.8];
parameters.shapingValues.numTrials=int16([50,100,200,500]); %*** return the 3 to 50, 3*!*
parameters.shapingValues.startValue=parameters.stdGaussMask;
parameters.shapingValues.currentValue=parameters.stdGaussMask;
parameters.shapingValues.goalValue=1/32;
parameters.graduation = parameterThresholdCriterion('.stimDetails.stdGaussMask','<=',1/32);

[shrinking branchParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});

nameOfShapingStep{end+1} = sprintf('Step 2g: varyingTargetPosition %s, stringent', protocolType);
parameters=branchParameters;
parameters.stdGaussMask = 1/16;

parameters.shapedParameter='xPosNoise';
parameters.shapingMethod='linearChangeAtCriteria';
parameters.shapingValues.numSteps=int8(5);
parameters.shapingValues.startValue=0.01;
parameters.shapingValues.currentValue=0.01;
parameters.shapingValues.goalValue=.1;
parameters.graduation = parameterThresholdCriterion('.stimDetails.xPosNoiseStd','>=',.1);

[varyTargetPos unUsed]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});
% end optional


nameOfShapingStep{end+1} = sprintf('Step 3a: Dim flankers %s, stringent', protocolType);
parameters=smallParameters;
parameters.fractionNoFlanks=.05;
parameters.flankerContrast = [ 0.1]; % **!! miniDatabase overwrites this (for rats on this step)  if rebuilding ratrix
parameters.flankerOffset = 3;
%for all stimuli with displayTargetAndDistractor = 0, these will not matter
parameters.distractorYokedToTarget=1;
parameters.distractorFlankerYokedToTargetFlanker = 1;
parameters.distractorContrast = 0;

parameters.shapedParameter='flankerContrast';
parameters.shapingMethod='linearChangeAtCriteria';
parameters.shapingValues.numSteps=int8(4);
parameters.shapingValues.performanceLevel= [0.9,0.85,0.82,0.8];   %using conf at ~.78;   for confidence at .85: [0.95,0.9,0.85,0.8];
parameters.shapingValues.numTrials=int16([50,100,200,500]); %*** return the 5 to 50 *!*
parameters.shapingValues.startValue=parameters.flankerContrast;
parameters.shapingValues.currentValue=parameters.flankerContrast;
parameters.shapingValues.goalValue=0.5;
parameters.graduation = parameterThresholdCriterion('.stimDetails.flankerContrast','>=',0.49);

if ismember(protocolVersion,{'1_0','1_1','1_2','1_3'}) %early versions shaped flankerContrast all the way to 1
    parameters.shapingValues.goalValue=1;
    parameters.shapingValues.numSteps=int8(9);
    parameters.graduation = parameterThresholdCriterion('.stimDetails.flankerContrast','>=',0.99);
end
[dimFlankers previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});


nameOfShapingStep{end+1} = sprintf('Step 3b: Dimmer target %s, stringent', protocolType);
parameters=previousParameters;
parameters.flankerContrast = [ 0.4];
parameters=setLeftAndRightContrastInParameterStruct(parameters, protocolType, .8);  % **skip .9 ; miniDatabase overwrites this (for rats on this step)  if rebuilding ratrix

parameters.shapedParameter='targetContrast';
parameters.shapingMethod='linearChangeAtCriteria';
parameters.shapingValues.numSteps=int8(6);
parameters.shapingValues.startValue=.8;
parameters.shapingValues.currentValue=.8;
parameters.shapingValues.goalValue=0.2;
parameters.graduation = parameterThresholdCriterion('.stimDetails.currentShapedValue','<',0.29);

[dimmerTarget previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});


switch protocolVersion
    case {'1_0','1_1','1_2','1_3','1_4','1_5','1_6','1_7','1_8','1_9','2_0','2_1','2_2'}
           nameOfShapingStep{end+1} = sprintf('Step 3c: Stronger flanker %s, stringent', protocolType);
        parameters=previousParameters;
        parameters.flankerContrast = [ 0.4]; %miniDatabase overwrites this (for rats on this step) if rebuilding ratrix
        parameters=setLeftAndRightContrastInParameterStruct(parameters, protocolType, .3);  % **this is the best they learned in the previous step

        parameters.shapedParameter='flankerContrast';
        parameters.shapingMethod='linearChangeAtCriteria';
        parameters.shapingValues.numSteps=int8(6);
        parameters.shapingValues.startValue=parameters.flankerContrast;
        parameters.shapingValues.currentValue=parameters.flankerContrast;
        parameters.shapingValues.goalValue=1;
        parameters.graduation = parameterThresholdCriterion('.stimDetails.flankerContrast','>=',0.99);

        [strongerFlanker previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});


        nameOfShapingStep{end+1} = sprintf('Step 3d: Full contrast flankers %s, stringent', protocolType);
        parameters=previousParameters;
        parameters.shapedParameter=[];
        parameters.shapingMethod=[];
        parameters.shapingValues=[];
        parameters.flankerContrast = [1];
        parameters.graduation = performanceCriterion([0.85, 0.8],int16([200,500]));
        [fullFlankers previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});

        nameOfShapingStep{end+1} = sprintf('Step 3e: Flankers also toggle %s, stringent', protocolType);
        parameters=previousParameters;
        parameters.persistFlankersDuringToggle = 0; %
        [flanksToggleToo previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});
    otherwise %{'2_3','2_4'} and onwards %some skip full contrast flankers, and move right to toggle then sweep

        nameOfShapingStep{end+1} = sprintf('Step 3e: Flankers also toggle %s, stringent', protocolType);
        parameters=previousParameters;
        parameters.shapedParameter=[];
        parameters.shapingMethod=[];
        parameters.shapingValues=[];
        targetContrast=[.75]; %reasonably easy after the lowering,

        parameters=setLeftAndRightContrastInParameterStruct(parameters, protocolType, targetContrast);

        %Remove correlation for experiments
        parameters.maxCorrectOnSameSide=int8(-1);
        parameters.percentCorrectionTrials=0;  %beware this is overpowered by the minidatabase setting!

        parameters.persistFlankersDuringToggle = 0; %
        %parameters.graduation = timeCriterion(32);
        %parameters.graduation = experimenterControlled([16,28,32],[0,0,0]);
        parameters.graduation = performanceCriterion([0.99],int16([9999]));
        [flanksToggleToo previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});


        nameOfShapingStep{end+1} = sprintf('Expt 1: contrast sweep', protocolType);
        parameters=previousParameters;
        %targetContrast= [0.6 0.8]; %a guess for thresh!
        %[0.015625 0.5 0.75 1 ] 1/log2 idea: 2.^[-6,-2,-1,0]
        targetContrast=[.25 0.5 0.75 1]; % starting sweep (rational: match acuity, but if at chance on .25 don't swamp more than you need, if above chance then add in something smaller, also easier ones will keep up moral )
        parameters=setLeftAndRightContrastInParameterStruct(parameters, protocolType, targetContrast);




        [sweepContrast previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});

        nameOfShapingStep{end+1} = sprintf('Expt 2: position sweep', protocolType);
        targetContrast=[.75]; %reasonably easy , garaunteed contrast sensitive
        parameters=setLeftAndRightContrastInParameterStruct(parameters, protocolType, targetContrast);
        parameters.flankerOffset = [2.5 3 3.5 5];
        [sweepFlankerPosition]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});

        nameOfShapingStep{end+1} = sprintf('Expt 3: flanker orientation sweep', protocolType);
        parameters.flankerOffset=3;
        parameters.fpaRelativeTargetOrientation=0;  % always align to fpa
        %rfo=[-pi/2 -pi/4 -pi/8 -pi/16 0 0 pi/16 pi/8 pi/4 pi/2];  % 9 best with more samples at 0
        rfo=[-pi/2 -pi/6 -pi/12 -pi/24 0 0 pi/24 pi/12 pi/6 pi/2];  % 9 best with more samples at 0
        parameters.fpaRelativeFlankerOrientation=rfo;
        required=repmat(rfo,size(parameters.flankerPosAngle,2),1)-repmat(parameters.flankerPosAngle',1,size(rfo,2));
        parameters.flankerOrientations=unique(required(:)); % find what you need
        parameters.phase=0;
        [sweepFlankerOrientation ]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});
     
end




nameOfShapingStep{end+1} = sprintf('Step 3f: Flankers change positions %s, stringent', protocolType);
parameters=previousParameters;
parameters.flankerOffset = [2.5 3 3.5 5]; %
[varyPosition previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});


%% experiment mode

% expt 1:
% 2* contrasts, 4 relative phases, 2 flanker contexts (VV and VH), 1
% spatial offset (==3)
% goal: compare VV to VH, don't bias a particular phase for expt 2
% -->32 days

nameOfShapingStep{end+1} = sprintf('Expt 1: VV-VH', protocolType);
targetContrast= [0.6 0.8]; %a guess for thresh!
parameters=setLeftAndRightContrastInParameterStruct(parameters, protocolType, targetContrast);

numPhase = 4; parameters.phase= 2*pi * [0: numPhase-1]/numPhase;
parameters.flankerOffset = [3];

%Remove correlation for experiments
parameters.maxCorrectOnSameSide=int8(-1);
parameters.percentCorrectionTrials=0;

%And then the 'default' parameters (which would not need to be set if testing steps are added to the end of the protocol)
%     parameters.goRightOrientations = [0];
%     parameters.goLeftOrientations =  [0];
%     parameters.flankerOrientations = [0,pi/2]; %choose a random orientation from this list\
%
%     parameters.stdGaussMask = 1/16;
%     parameters.positionalHint=0;
%     parameters.displayTargetAndDistractor=1;
%end default parameters

%parameters.graduation = timeCriterion(32);
%parameters.graduation = experimenterControlled([16,28,32],[0,0,0]);
parameters.graduation = performanceCriterion([0.99],int16([9999]));
[vvVH previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});

% expt 2:
% 2* contrasts, 4 relative phases, 1 flanker contexts (VV), 1 spatial offset (==3)
% goal:  compare effect of relative phase
% -->16 days
nameOfShapingStep{end+1} = sprintf('Expt 2: VV phases', protocolType);
parameters.flankerOrientations = [0];
targetContrast= [1]; %warning: you would expect this to be the same thresh as above, but flunk for 135
parameters=setLeftAndRightContrastInParameterStruct(parameters, protocolType, targetContrast);
%parameters.graduation = timeCriterion(16);
%parameters.graduation = experimenterControlled([8,12,16],[0,0,0]);
parameters.graduation = performanceCriterion([0.99],int16([9999]));
[vvPhases previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});


% expt 3:
% 2* contrasts, 1 "aligned" phase, 1 flanker contexts (VV), 5 spatial
% offset (i.e. 2 2.5 3 3.5 4)
% goal:  compare effect at a range of distances
nameOfShapingStep{end+1} = sprintf('Expt 3: VV offsets', protocolType);
parameters.flankerYokedToTargetPhase =0;
parameters.flankerOffset = [2 2.5 3 3.5 4];
%parameters.flankerOffset = [2.5 3 3.5 5]; % **!! confirm this!
%parameters.graduation = timeCriterion(40);
%parameters.graduation = experimenterControlled([20,35,40],[0,0,0]);
parameters.graduation = performanceCriterion([0.99],int16([9999]));
[vvOffsets previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});


% expt 4-5  combine spatial offset with phase or orientation... only if
% you have an effect
% goal:  view the differential effects on performance at different
% distances...as in literature
nameOfShapingStep{end+1} = sprintf('Expt 4: VV phasesOffset', protocolType);
parameters.flankerYokedToTargetPhase =1;
%parameters.graduation = timeCriterion(50);
%parameters.graduation = experimenterControlled([10,30,50],[0,0,0]);
parameters.graduation = performanceCriterion([0.99],int16([9999]));
[vvPhasesOffset previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});

nameOfShapingStep{end+1} = sprintf('Expt 5: VV-VH offsets', protocolType);
parameters.flankerYokedToTargetPhase =1;
%parameters.graduation = timeCriterion(50);
%parameters.graduation = experimenterControlled([10,30,50],[0,0,0]);
parameters.graduation = performanceCriterion([0.99],int16([9999]));
[vvVHOffsets previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});


parameters.flankerYokedToTargetPhase =1;
%parameters.graduation = timeCriterion(50);
%parameters.graduation = experimenterControlled([10,30,50],[0,0,0]);
parameters.graduation = performanceCriterion([0.99],int16([9999]));
[vvVHOffsets previousParameters]=setFlankerStimRewardAndTrialManager(parameters, nameOfShapingStep{end});


fd1TM = makeFreeDrinksTM(0.01); %juicy
fd2TM = makeFreeDrinksTM(0.001); % some
[fd3TM, SM] = makeFreeDrinksTM(0); % none


grad1 = rateCriterion(4,1); %(3,2)? (3,3)?
grad2 = rateCriterion(5,2); % how likely is it that false positives trigger a graduation without rat licks? -pmm
grad3 = rateCriterion(6,3); % rateCriterion(10,3) % (20,1)? (5,20)?


fd1 = trainingStep(fd1TM, SM, grad1, minutesPerSession(90,3), parameters.svnRev); %nTrialsThenWait([1000],[1],[0.001],[1])
fd2 = trainingStep(fd2TM, SM, grad2, minutesPerSession(90,3), parameters.svnRev);
fd3 = trainingStep(fd3TM, SM, grad3, minutesPerSession(90,3), parameters.svnRev);
%fdSteps=protocol('contrasty gabor free drinks weening',{fd1, fd2, fd3});


%% fd test
%s = subject('fdtest', 'rat', 'long-evans', 'male', '08/20/2006', '09/20/2006', 'unknown', 'Jackson Laboratories'); r=addSubject(r,s,'pmm');
%[s r]=setProtocolAndStep(s,fdSteps,1,0,1,1,r,'first try','pmm');  %juicey  (0.01)
%[s r]=setProtocolAndStep(s,fdSteps,1,0,1,2,r,'first try','pmm'); %some (0.001)
%[s r]=setProtocolAndStep(s,fdSteps,1,0,1,3,r,'first try','pmm'); %no
%stochastic

%%  make new ratrix station and box, if you don't have one

if isempty(r)
    error('old code')
    if ispc
        rootPath='C:\pmeier\Ratrix\'; %**!!hard coded path
        pathSep='\';
        screenNum = 0;
        soundOn = 1;
    elseif isosx
        rootPath='/Users/pmmeier/Desktop/Ratrix/';
        pathSep='\';
        screenNum = 0;
        %rect=Screen('Rect', screenNum); screenWidth=rect(3); screenHeight=rect(4); %set in default now
        soundOn = 0;
    else  %use default
        %rootPath='C:\Ratrix\';
        'must enter rootPath'
        pathSep='\';
        screenNum =2;
        screenWidth= 800;  screenHeight=600;
        soundOn = 1;
    end

    screenWidth= 1024;  screenHeight=768;
    r=ratrix([rootPath 'ServerData' pathSep],1);
    %st=station(int8(1),int8([6,7,8]),int8([4,2,3]),1280,1024,'ptb','keyboard'    ,[rootPath 'Stations' pathSep 'station1' pathSep],[]    ,int8(screenNum),int8(1),logical(soundOn));
    %st =station(int8(1),int8([6,7,8]),int8([4,2,3]),screenWidth,screenHeight,'ptb','parallelPort',[rootPath 'Stations' pathSep 'station1' pathSep] ,'037F',int8(screenNum),int8(1),logical(soundOn)); %PMM COMPUTER
    st =station(int8(1),int8([6,7,8]),int8([4,2,3]),screenWidth,screenHeight,'ptb','parallelPort',[rootPath 'Stations' pathSep 'station1' pathSep] ,'0378',int8(screenNum),int8(1),logical(soundOn)); %STATIONS DOWNSTAIRS
    %st =station(int8(1),int8([6,7,8]),int8([4,2,3]),screenWidth,screenHeight,'ptb','keyboard',[rootPath 'Stations' pathSep 'station1' pathSep] ,[]K23,int8(screenNum),int8(1),logical(soundOn)); %STATIONS DOWNSTAIRS
    %old bomb? %st =station(int8(1),int8([7,6,8]),int8([3,4,2]),screenWidth,screenHeight,'ptb','parallelPort',[rootPath 'Stations' pathSep 'station1' pathSep] ,'0378',int8(screenNum),int8(1),logical(soundOn));
    b=box(int8(1),[rootPath 'Boxes' pathSep 'box1' pathSep]);
    r=addBox(r,b);
    r=addStationToBoxID(r,st,getID(b));
end


%% assemble the protocol
%nameOfProtocol=[protocolType '_v' protocolVersion];
nameOfProtocol=generateProtocolName(nameOfShapingStep,protocolVersion,defaultSettingsDate)

switch protocolVersion
    case {'1_0', '1_1'}
        p=protocol(nameOfProtocol,{fd1,fd2,fd3,easy,stringent,linearized,thinner,smaller,dimFlankers,fullFlankers,flanksToggleToo,varyPosition})
    case '1_2'
        p=protocol(nameOfProtocol,{fd1,fd2,fd3,easyHint,stringent,linearized,thinner,smaller,dimFlankers,fullFlankers,flanksToggleToo,varyPosition})
    case {'1_3', '1_4'}
        p=protocol(nameOfProtocol,{fd1,fd2,fd3,easy,stringent,linearized,thinner,smaller,dimFlankers,fullFlankers,flanksToggleToo,varyPosition,vvVH,vvPhases,vvOffsets,vvPhasesOffset,vvVHOffsets})
    case '1_5' %used by adam, no distractors, includes a hint
        p=protocol(nameOfProtocol,{fd1,fd2,fd3,easyHint,stringent,linearized,thinner,smaller})
    case {'1_6','1_7', '1_8', '1_9', '2_1'}
        p=protocol(nameOfProtocol,{fd1,fd2,fd3,easy,stringent,linearized,thinner,smaller,dimFlankers,dimmerTarget,strongerFlanker,fullFlankers,flanksToggleToo,varyPosition})
    case '2_0'
        p=protocol(nameOfProtocol,{fd1,fd2,fd3,easy,stringent,linearized,thinner,shrinking,varyTargetPos})
    case '2_2' %detection first learn on linearized small thin target
        p=protocol(nameOfProtocol,{fd1,fd2,fd3,easy,smaller,dimFlankers,dimmerTarget,flanksToggleToo,varyPosition}) %
    case {'2_3','2_4','2_5validate'} %sweep contrast as first expt, then position, then orientation; manual graduations don't control order
        p=protocol(nameOfProtocol,{fd1,fd2,fd3,easy,stringent,linearized,thinner,smaller,dimFlankers,dimmerTarget,flanksToggleToo,sweepContrast,sweepFlankerPosition,sweepFlankerOrientation})
    otherwise
        error('bad protocol type')
end

% don't add, just check that they are there
% r=addTheseRats(r,subjects,p,persistTrainingSteps);

for i=1:size(subjects,2)
    if ~any(strcmp(subjects{i}, getSubjectIDs(r)))
        allIDs = getSubjectIDs(r)
        thisID = subjects{i}
        %error('rats should already be there')
        warndlg(sprintf('adding rat %s',subjects{i}),'rats should already be there')
        s = subject(char(subjects(i)), 'rat', 'long-evans', 'male', '01/01/2005', '01/02/2005', 'unknown', 'Jackson Laboratories');
        r=addSubject(r,s,'pmm');
    else
        s = getSubjectFromID(r, subjects{i});
    end

    miniDatabasePath = fullfile(getRatrixPath, 'setup','setupPMM');
    %miniDatabaseFile = fullfile(getRatrixPath, 'setup','setupPMM','miniDatabase.mat')
    if persistTrainingSteps;
        stepNum=getMiniDatabaseFact(getSubjectFromID(r,subjects{i}),'stepNumber',miniDatabasePath); %this is if you have to reinit...
        %    stepNum = getLastTrainingStep(ratID,getPermanentStorePath(r)); %persist previous step but can't flunk or advance
    else
        stepNum=1;
    end

    stepNum
    subjects(i)
    [s  r]=setProtocolAndStep(s ,p,1,0,1,stepNum,r,'from pmm master Shaping','pmm');
    if persistTrainingSteps
        r=setValuesFromMiniDatabase(s,r,miniDatabasePath);
    end
end





%% test graduation

testGraduation=0;
if testGraduation
    load 'C:\Documents and Settings\rlab\Desktop\localAnalysis\out\trialRecords.mat'
    c=rateCriterion(10,3);
    % c=performanceCriterion([.8,.5,.95],[20,200,2000]);
    ts=getTrainingStep(p,4); %why bother passing this in if we already know criteria?
    %trialRecords.correct=rand(1,300)>0.5;
    graduate = checkCriterion(c,s,ts,trialRecords)
end

%% stim test

stimTest=1;
if stimTest
    clc
    trialManagerClass = class(getTrialManager(thinner));
    frameRate = 60;
    responsePorts = [1 3];
    totalPorts = [3];
    width=1024;
    height=768;
    trialRecords = [];

    stimManager=getStimManager(thinner)
    resolutions=[];
    displaySize=[];
    LUTbits=[];
    [stimManager junk2 resInd im a b c d e details interTrialLuminance text] =...
        calcStim(stimManager,trialManagerClass,resolutions,displaySize,LUTbits,responsePorts,totalPorts,trialRecords);
    details
    subplot(1, 2, 1); imagesc(im(:,:,1))
    subplot(1, 2, 2); imagesc(im(:,:,2))
    colormap(gray)
end
