function [stimSpecs startingStimSpecInd] = phaseify(trialManager,stim,type,...
    targetPorts,distractorPorts,requestPorts,scaleFactor,interTrialLuminance,hz)
% this method takes the output from calcStim of a non-phased stim manager, and converts it to stimSpecs according to the trialManager class
% output is cell arrays of stimSpecs

startingStimSpecInd=1; % which phase to start with (passed to stimOGL->runRealTimeLoop)
% this allows us to have an optional 'waiting for request' phase in nAFC and not mess up sound handling

if strmatch(class(trialManager), 'nAFC')
    if iscell(type) && strcmp(type{1},'timedFrames') && type{2}(end)~=0
        framesUntilTransition=sum(type{2});
    else
        framesUntilTransition=[];
    end
    
    % waiting for request
    criterion = {requestPorts, 2};
    stimSpecs{1} = stimSpec(interTrialLuminance,criterion,'loop',0,framesUntilTransition,[],0,0,hz,[]);
    
    % waiting for response
    criterion = {targetPorts, 3, distractorPorts, 4};
    stimSpecs{2} = stimSpec(stim,criterion,type,0,[],[],scaleFactor,0,hz,[]);
    
    % correct
    criterion = {[], 5};
    stimSpecs{3} = stimSpec(interTrialLuminance,criterion,'cache',0,[],[],0,0,hz,'correct'); % timeout assigned during runRealTimeLoop
    
    % wrong
    criterion = {[], 5};
    % the error phase has an empty stim, because we dont know how long of a stim to compute using errorStim(stimManager,numErrorFrames) until
    % we get to the error phase and call calcReinforcement!
    stimSpecs{4} = stimSpec([],criterion,'cache',0,[],[],scaleFactor,0,hz,'error');
    
    % final
    criterion = {[], 1};
    stimSpecs{5} = stimSpec(interTrialLuminance,criterion,'cache',0,1,[],0,1,hz,[]);
    
    if isempty(requestPorts)
        startingStimSpecInd=2;
    end
    
elseif strmatch(class(trialManager), 'freeDrinks')

    % waiting for response phase
    criterion = {targetPorts, 2};
    stochasticP = getFreeDrinkLikelihood(trialManager);
    stimSpecs{1} = stimSpec(stim, criterion,'loop',0,[],{stochasticP,1,stochasticP,2,stochasticP,3},scaleFactor,0,hz,[]);

    % correct phase (always correct)
    criterion = {[], 3};
    stimSpecs{2} = stimSpec(interTrialLuminance,criterion,'cache',0,[],[],0,0,hz,'correct');
    
    % final
    criterion = {[], 1};
    stimSpecs{3} = stimSpec(interTrialLuminance,criterion,'cache',0,1,[],0,1,hz,[]);

elseif strcmp(class(trialManager), 'autopilot')

    % just put in loop mode, one phase
    criterion = {[], 2};
    stimSpecs{1} = stimSpec(stim, criterion,'loop',0,[],[],scaleFactor,0,hz,[]);

    % final phase
    criterion = {[], 1};
    stimSpecs{2} = stimSpec(interTrialLuminance,criterion,'cache',0,1,[],0,1,hz,[]);

else
    error('only nAFC, freeDrinks, and autopilot for now');
end

