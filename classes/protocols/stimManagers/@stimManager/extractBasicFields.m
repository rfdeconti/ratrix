function [out compiledLUT]=extractBasicFields(sm,trialRecords,compiledLUT)

%note many of these are actually restricted by the trialManager -- ie
%nAFC has scalar targetPorts, but freeDrinks doesn't.

bloat=false;
% fields to extract from trialRecords:
%   trialNumber
%   sessionNumber
%   date
%   station.soundOn
%   station.physicalLocation
%   station.numPorts
%   trainingStepNum
%   trainingStepName
%   protocolName
%   numStepsInProtocol
%   protocolVersion.manualVersion
%   protocolVersion.autoVersion
%   protocolVersion.protocolDate
%   correct
%   trialManagerClass
%   stimManagerClass
%   schedulerClass
%   criterionClass
%   reinforcementManagerClass
%   scaleFactor
%   type
%   targetPorts
%   distractorPorts
%   response
%   containedManualPokes
%   didHumanResponse
%   containedForcedRewards
%   didStochasticResponse

% ==============================================================================================
% start extracting fields
[out.trialNumber compiledLUT]                                =extractFieldAndEnsure(trialRecords,{'trialNumber'},'scalar',compiledLUT);
[out.sessionNumber compiledLUT]                              =extractFieldAndEnsure(trialRecords,{'sessionNumber'},'scalar',compiledLUT);
[out.date compiledLUT]                                       =extractFieldAndEnsure(trialRecords,{'date'},'datenum',compiledLUT);
[out.soundOn compiledLUT]                                    =extractFieldAndEnsure(trialRecords,{'station','soundOn'},'scalar',compiledLUT);
[out.physicalLocation compiledLUT]                           =extractFieldAndEnsure(trialRecords,{'station','physicalLocation'},'equalLengthVects',compiledLUT);
[out.numPorts compiledLUT]                                   =extractFieldAndEnsure(trialRecords,{'station','numPorts'},'scalar',compiledLUT);
[out.step compiledLUT]                                       =extractFieldAndEnsure(trialRecords,{'trainingStepNum'},'scalar',compiledLUT);
[out.trainingStepName compiledLUT]                           =extractFieldAndEnsure(trialRecords,{'trainingStepName'},'scalarLUT',compiledLUT);
[out.protocolName compiledLUT]                               =extractFieldAndEnsure(trialRecords,{'protocolName'},'scalarLUT',compiledLUT);
[out.numStepsInProtocol compiledLUT]                         =extractFieldAndEnsure(trialRecords,{'numStepsInProtocol'},'scalar',compiledLUT);
[out.manualVersion compiledLUT]                              =extractFieldAndEnsure(trialRecords,{'protocolVersion','manualVersion'},'scalar',compiledLUT);
[out.autoVersion compiledLUT]                                =extractFieldAndEnsure(trialRecords,{'protocolVersion','autoVersion'},'scalar',compiledLUT);
[out.protocolDate compiledLUT]                               =extractFieldAndEnsure(trialRecords,{'protocolVersion','date'},'datenum',compiledLUT);
[out.correct compiledLUT]                                    =extractFieldAndEnsure(trialRecords,{'correct'},'scalar',compiledLUT);
[out.trialManagerClass compiledLUT]                          =extractFieldAndEnsure(trialRecords,{'trialManagerClass'},'scalarLUT',compiledLUT);
[out.stimManagerClass compiledLUT]                           =extractFieldAndEnsure(trialRecords,{'stimManagerClass'},'scalarLUT',compiledLUT);
[out.schedulerClass compiledLUT]                             =extractFieldAndEnsure(trialRecords,{'schedulerClass'},'scalarLUT',compiledLUT);
[out.criterionClass compiledLUT]                             =extractFieldAndEnsure(trialRecords,{'criterionClass'},'scalarLUT',compiledLUT);
[out.reinforcementManagerClass compiledLUT]                  =extractFieldAndEnsure(trialRecords,{'reinforcementManagerClass'},'scalarLUT',compiledLUT);
[out.scaleFactor compiledLUT]                                =extractFieldAndEnsure(trialRecords,{'scaleFactor'},'equalLengthVects',compiledLUT);
[out.type compiledLUT]                                       =extractFieldAndEnsure(trialRecords,{'type'},'scalarLUT',compiledLUT);
[out.targetPorts compiledLUT]                                =extractFieldAndEnsure(trialRecords,{'targetPorts'},{'typedVector','index'},compiledLUT);
[out.distractorPorts compiledLUT]                            =extractFieldAndEnsure(trialRecords,{'distractorPorts'},{'typedVector','index'},compiledLUT);
out.response                                                 =ensureScalar(cellfun(@encodeResponse,{trialRecords.response},out.targetPorts,out.distractorPorts,num2cell(out.correct),'UniformOutput',false));
if any(out.response==0)
    error('got zero response')
end
[out.containedManualPokes compiledLUT]                       =extractFieldAndEnsure(trialRecords,{'containedManualPokes'},'scalar',compiledLUT);
[out.didHumanResponse compiledLUT]                           =extractFieldAndEnsure(trialRecords,{'didHumanResponse'},'scalar',compiledLUT);
[out.containedForcedRewards compiledLUT]                     =extractFieldAndEnsure(trialRecords,{'containedForcedRewards'},'scalar',compiledLUT);
[out.didStochasticResponse compiledLUT]                      =extractFieldAndEnsure(trialRecords,{'didStochasticResponse'},'scalar',compiledLUT);
% 1/13/09 - need to peek into stimDetails to get correctionTrial (otherwise analysis defaults correctionTrial=0)
[out.correctionTrial compiledLUT]                            =extractFieldAndEnsure(trialRecords,{'stimDetails','correctionTrial'},'scalar',compiledLUT);

% ==============================================================================================
% old-style extraction - to be commented out 1/8/09
% out.trialNumber                                 =ensureScalar({trialRecords.trialNumber});
% out.sessionNumber                               =ensureScalar({trialRecords.sessionNumber});
% out.date                                        =datenum(reshape([trialRecords.date],6,length(trialRecords))')';

% temp=[trialRecords.station];
if bloat out.stationID                          =ensureScalar({temp.id}); end
% out.soundOn                                     =ensureScalar({temp.soundOn});
if bloat [out.rewardMethod compiledLUT]         =ensureScalarOrAddCellToLUT({temp.rewardMethod},compiledLUT); end
if bloat [out.MAC compiledLUT]                  =ensureScalarOrAddCellToLUT({temp.MACaddress},compiledLUT); end
% out.physicalLocation                            =ensureEqualLengthVects({temp.physicalLocation});
% out.numPorts                                    =ensureScalar({temp.numPorts});

% out.step                                        =ensureScalar({trialRecords.trainingStepNum});
% if isfield(trialRecords(1),'trainingStepName')
%     [out.trainingStepName compiledLUT]          =ensureScalarOrAddCellToLUT({trialRecords.trainingStepName},compiledLUT);
% else
%     out.trainingStepName                        =ones(1,length(trialRecords))*nan;
% end
% [out.protocolName compiledLUT]                  =ensureScalarOrAddCellToLUT({trialRecords.protocolName},compiledLUT);
% out.numStepsInProtocol                          =ensureScalar({trialRecords.numStepsInProtocol});

% temp=[trialRecords.protocolVersion];
% out.manualVersion                               =ensureScalar({temp.manualVersion});
% out.autoVersion                                 =ensureScalar({temp.autoVersion});
% out.protocolDate                                =datenum(reshape([temp.date],6,length(temp))')';
if bloat out.protocolAuthor                     =ensureScalar({temp.author}); end

% out.correct                                     =ensureScalar({trialRecords.correct});
if bloat out.subjectsInBox                      =ensureTypedVector({trialRecords.subjectsInBox},'cell'); end %ensure vector cells of chars?
% [out.trialManagerClass compiledLUT]             =ensureScalarOrAddCellToLUT({trialRecords.trialManagerClass},compiledLUT);
% [out.stimManagerClass compiledLUT]              =ensureScalarOrAddCellToLUT({trialRecords.stimManagerClass},compiledLUT);
% [out.schedulerClass compiledLUT]                =ensureScalarOrAddCellToLUT({trialRecords.schedulerClass},compiledLUT);
% [out.criterionClass compiledLUT]                =ensureScalarOrAddCellToLUT({trialRecords.criterionClass},compiledLUT);
% [out.reinforcementManagerClass compiledLUT]     =ensureScalarOrAddCellToLUT({trialRecords.reinforcementManagerClass},compiledLUT);
% out.scaleFactor                                 =ensureEqualLengthVects({trialRecords.scaleFactor});
% [out.type compiledLUT]                          =ensureScalarOrAddCellToLUT({trialRecords.type},compiledLUT); %ensure type check?
% out.targetPorts                                 =ensureTypedVector({trialRecords.targetPorts},'index');
% out.distractorPorts                             =ensureTypedVector({trialRecords.distractorPorts},'index');

% out.response                                    =ensureScalar(cellfun(@encodeResponse,{trialRecords.response},out.targetPorts,out.distractorPorts,num2cell(out.correct),'UniformOutput',false));
% if any(out.response==0)
%     error('got zero response')
% end

% out.containedManualPokes                        =ensureScalar({trialRecords.containedManualPokes});
% if ismember('didHumanResponse',fieldnames(trialRecords))
%     out.didHumanResponse                        =ensureScalar({trialRecords.didHumanResponse});
% else
%     out.didHumanResponse                        =ensureScalar(num2cell(nan*zeros(1,length(trialRecords))));
% end
% out.containedForcedRewards                      =ensureScalar({trialRecords.containedForcedRewards});
% out.didStochasticResponse                       =ensureScalar({trialRecords.didStochasticResponse});

verifyAllFieldsNCols(out,length(trialRecords));
end

function out=encodeResponse(resp,targs,dstrs,correct)
if islogical(resp)
    if isscalar(find(resp))
        out=find(resp);
    else
        out=-1; %multiple blocked ports
    end
elseif ischar(resp)
    switch resp
        case 'none'
            out=-2;
        case 'manual kill'
            out=-3;
        case 'shift-2 kill'
            out=-4;
        case 'server kill'
            out=-5;
        otherwise
            out=-6;
            resp
            warning('unrecognized response')
    end
else
    resp
    class(resp)
    error('unrecognized response type')
end

if ismember(out,targs) == correct
    %pass
else
    error('bad correct calc')
end

if all(isempty(intersect(dstrs,targs)))
    %pass
else
    error('found intersecting targets and distractors')
end

end


function [out compiledLUT] = ensureScalarOrAddCellToLUT(fieldArray, compiledLUT)
% this function either returns a scalar array, or if it finds that fieldArray is a cell array, performs LUT processing on the fieldArray
% this allows extractBasicFields to support versions of trialRecords that dont use a LUT
try
    out=ensureScalar(fieldArray);
catch
    ensureTypedVector(fieldArray,'char'); % ensure that this is cell array of characters, otherwise no point using a LUT
    [out compiledLUT] = addOrFindInLUT(compiledLUT, fieldArray);
end

end % end function

function [out LUT] = extractFieldAndEnsure(trialRecords,fieldPath,ensureMode,LUT)
% this function extracts the given field from trialRecords using the provided fieldPath and ensureMode
%   ensureMode is one of {'scalar','scalarLUT','equalLengthVects',{'typedVector',type},'datenum'} where type specifies the type of vector

% grab the mode if cell array, and set ensureType=type
if iscell(ensureMode) && length(ensureMode)==2
    ensureType=ensureMode{2};
    ensureMode=ensureMode{1};
end

% if fieldPath isnt a single element cell array, then follow it down to the last element
for i=1:length(fieldPath)-1
    if ismember(fieldPath{i},fields(trialRecords))
        trialRecords=[trialRecords.(fieldPath{i})];
    else
        out=nan*ones(1,length(trialRecords));
        return
    end
end
% now reset fieldPath to be only the last element
fieldPath=fieldPath{end}; % fieldPath is now just a string

try
    switch ensureMode
        case 'scalar'
            out=ensureScalar({trialRecords.(fieldPath)});
        case 'scalarLUT'
            try
                out=ensureScalar({trialRecords.(fieldPath)});
            catch
                ensureTypedVector({trialRecords.(fieldPath)},'char'); % ensure is char otherwise no reason to use LUT
                [out LUT]=addOrFindInLUT(LUT, {trialRecords.(fieldPath)});
            end
        case 'equalLengthVects'
            out=ensureEqualLengthVects({trialRecords.(fieldPath)});
        case 'typedVector'
            out=ensureTypedVector({trialRecords.(fieldPath)},ensureType);
        case 'datenum'
            out=datenum(reshape([trialRecords.(fieldPath)],6,length(trialRecords))')';
        otherwise
            ensureMode
            error('unsupported ensureMode');
    end
catch
    % if this field doesn't exist, fill with nans
    out=nan*ones(1,length(trialRecords));
end

end % end function

