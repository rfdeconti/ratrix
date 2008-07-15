function st=soundType(varargin)
% soundType  class constructor. 
% ABSTRACT CLASS - DO NOT INSTANTIATE
% The purpose of the soundType class is to make user-defined phases and associated sounds very easy (in the phased stim model).
% The trialManager's soundManager still keeps all of the sound clips. calcStim then creates soundTypes as necessary
% and associates each stimSpec (phase) with its soundTypes as a field in stimSpec.
% During stimOGL, a simple call to the soundType's play function then automatically determines if the sound is played at a given time.
% This makes stimOGL insensitive to whatever sounds and phases it is given as input, and therefore no user should have to mess with it.
% To define new phases, a user simply needs to create a new trialManager and its corresponding stimManager calcStim.
% New soundTypes can also be added as subclasses of soundType and easily used by any user w/o modification to stimOGL.

% Really, this should be an interface
% All we need is a single function that returns true if we should play this sound given stimOGL port, timeElapsed, etc

if nargin == 0
    st.name = ''; %name of the sound clip as a string
    st.duration = 1; % duration of sound to play in milliseconds (ms)
else
    st.name = varargin{1};
    st.duration = varargin{2};
end
    
st = class(st, 'soundType', structable());

st = setSuper(st, st.structable);
