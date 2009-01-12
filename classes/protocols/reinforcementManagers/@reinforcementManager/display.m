function d=display(r)
    d=[sprintf('\n\t\t\tmsPenalty:\t\t\t\t\t\t%3.5g',r.msPenalty) ...
       sprintf('\n\t\t\tscalar:\t\t\t\t\t\t%3.3g',r.scalar) ...
       sprintf('\n\t\t\tfractionOpenTimeSoundIsOn:\t%3.3g',r.fractionOpenTimeSoundIsOn) ...
       sprintf('\n\t\t\tfractionPenaltySoundIsOn:\t%3.3g',r.fractionPenaltySoundIsOn) ...
       sprintf('\n\t\t\trewardStrategy:\t\t\t\t%s',r.rewardStrategy) ...
       sprintf('\n\t\t\tunloggedRewardConvention:\t%s',r.unloggedRewardConvention) ...
       ];