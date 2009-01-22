function stimcon = connectToDataListener(datanet,hostname)
% this function tries to connect to the data listener
MAX_SIZE=1024*1024;

if strmatch(datanet.type, 'data')
    error('must be called on datanet of type ''stim''');
end

constants = getConstants(datanet);

% connect to data computer
stimcon=pnet('tcpconnect',hostname,8888); % stim=client, connect to 8888 (data)

% tell data computer to start listener and send ack
gotAck = false;
pnet(stimcon,'setwritetimeout',10);
pnet(stimcon,'setreadtimeout',10);
pnet(stimcon,'write', constants.startConnectionCommands.S_START_DATA_LISTENER_CMD);

% wait until we get ack from data listener
while ~gotAck
    received_msg = pnet(stimcon,'read',MAX_SIZE,'double');
    if ~isempty(received_msg) && received_msg == constants.startConnectionCommands.D_LISTENER_STARTED
        gotAck = true;
    end
end

end % end function