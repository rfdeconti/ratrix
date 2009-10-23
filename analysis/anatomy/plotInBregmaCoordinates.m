    function plotInBregmaCoordinates(eventdata,which,labelString,addObjects,levelToTopOfBrain)
        % eventdata- as generated by physiologySever event logger
        % which - a logical into which events
        % labelString- taken by plot to indicate which symbol is used
        % addObjects- a logical indicating which objects to add 
        %    [addSkullPlates,addCraniotomy,addLGN,addV1]
        % levelToTopOfBrain - a feature that only some user may want [default =false]
        %
        %this code is general to the stereo tax coordinate frame OF THE SURGERY ROOM
        %(if Anterior is pos or neg, if medial is pos or neg)
        %it assumes that ALL corrdinates are posterior and to the left of bregma
        %do NOT use fiduciary anchor points that are to the right of the midline, or anterior to bregma!
        %
        % on the other hand it assumes that during recording (as is the case on rig1 eye tracker rig)
        %    -posterior is positive
        %    -left is positive (more lateral for standard record-from-left-LGN experiments)
        %addObjects
        %
        % example calls
        % plotInBregmaCoordinates(eventdata,which=logicals,'r*',[addSkullPlates,addCraniotomy,addLGN,addV1],levelToTopOfBrain=true)
        % plotInBregmaCoordinates(eventdata,which,'r*',[1 1 1 0])
        
        if ~exist('addObjects','var') || isempty(addObjects)
            addSkullPlates=false;
            addCraniotomy=false;
            addLGN=false;
            addV1=false;
            addObjects=[addSkullPlates,addCraniotomy,addLGN,addV1];
        else
            addSkullPlates=addObjects(1);
            addCraniotomy=addObjects(2);
            addLGN=addObjects(3);
            addV1=addObjects(4);
            hold on;
        end
        
        if ~exist('levelToTopOfBrain','var') || isempty(levelToTopOfBrain)
            levelToTopOfBrain=false;
       end
        
        %extract values
        if any(which)
            
            p=getPositionInBregmaCoordinates(eventdata,which);

            

            if levelToTopOfBrain
                % this has the dangerous effect of ignoring brain curvature
                % or doing some strange normalization with respect to
                % cortical surface bulging...
                % but can be used to clean up data with "messy z"
                % if every penetration reliably has a "top of brain event"
                  
                 % set the top at -0.7mm (paxinos and watson, ctx surface relative to bregma, roughly above LGN)
                 newTOB=-0.7;
                    
                %find TOB z value reading for each penetration (called 'TOBraw')
                allPenIDs=find(~cellfun('isempty',{eventdata.penetrationNum}));
                TOB=ismember({eventdata.eventType},{'top of brain'});
                pen=[eventdata.penetrationNum];
                pens=unique(pen);
                TOBraw=nan(1,length(pens));
                for i=1:length(pens)
                    %find the TOB for this penetration
                    thisPen=[eventdata.penetrationNum]==pens(i);
                    if length(thisPen)~=length(allPenIDs)
                        error('expected to be the same... violates logic if not')
                    end
                    thisTOB=ismember({eventdata(allPenIDs(thisPen)).eventType},{'top of brain'});
                    thisTOF=ismember({eventdata(allPenIDs(thisPen)).eventType},{'top of fluid'}); % not used currently!
                    if any(thisTOB)  % if there is a top of brain this penetration, then
                        TOBIndLocal=max(find(thisTOB)); %use the last observation if many this penetration
                        eventIDsThisPen=find(thisPen);
                        TOBIndGlobal=allPenIDs(eventIDsThisPen(TOBIndLocal));
                        TOBraw(i)=eventdata(TOBIndGlobal).position(1,3); % save it for the next calculation
                    end
                end
                
                %find TOB for each event that will be plotted
                positionsToChange=find(which & ~cellfun('isempty',{eventdata.penetrationNum}));
                TOBforEachEvent=TOBraw([eventdata(positionsToChange).penetrationNum]);   
                 
                
                for i=1:length(positionsToChange)
                    if isnan(TOBforEachEvent(i))
                        p(i,3)=1+rand/2;
                        %data with out "top of brain event, will be placed
                        %above the brain
                    else
                        p(i,3)= eventdata(positionsToChange(i)).position(1,3)-TOBforEachEvent(i)+newTOB;
                    end
                end
                
                if 0
                    %adjust the depth of the events, so they are aligned to the appropriate top of brain
                    for i=1:length(positionsToChange)
                        % subtract of the depth from top of brain
                        try
                            p(i,3)= 8;
                            %eventdata(positionsToChange(i)).position(1,3)-TOBforEachEvent(i)+newTOB;
                        catch
                            keyboard
                        end
                    end
                    x=[TOBforEachEvent; p(:,3)'; positionsToChange];
                    eventdata(positionsToChange(isnan(TOBforEachEvent))).eventType
                end
                
                
                     
            end
            
            
            plot3(p(:,1),p(:,2),p(:,3),labelString,'markerSize',10);  % bending tip
        end
        
        if  addSkullPlates
            plot3([0 0], [-5 2],[0 0],'k'); %top
            plot3([0 -8], [0 0],[0 0],'k'); %midline
            plot3([-8 -8.5], [0 -.5],[0 0],'k'); %left lambda
            plot3([-8 -8.5], [0 0.5],[0 0],'k'); %right lambda
            plot3([-8.5 -8.5], [-2 -.5],[0 0],'k'); %left rear
            plot3([-8.5 -8.5], [ 2 0.5],[0 0],'k'); %right rear
        end
        
        if  addCraniotomy
            %expected LGN cantiotomy
            centerAP=-4.0;
            centerML=-3.8;
            
            halfWidth=0.75;
            halfHeight=1.5;
            plot3(centerAP+[ 1 1 ]*halfHeight, centerML+[-1  1]*halfWidth,[0 0],'k'); %top
            plot3(centerAP+[-1 -1]*halfHeight, centerML+[-1  1]*halfWidth,[0 0],'k'); %bottom
            plot3(centerAP+[-1  1]*halfHeight, centerML+[-1 -1]*halfWidth,[0 0],'k'); %left
            plot3(centerAP+[-1  1]*halfHeight, centerML+[ 1  1]*halfWidth,[0 0],'k'); %right
            
        end
        
        if    addLGN
          x=getLgnCoordinates();   
          k = convhulln(x); % get convex hull
          color=ones(1,size(k,1)); % some homogenous color;  happens to be green in default map
          t=trisurf(k,x(:,1),x(:,2),x(:,3),color','FaceAlpha',0.2,'EdgeAlpha',0.2);
        end
        
        if addV1
             x=getV1Coordinates();   
          k = convhulln(x); % get convex hull
          color=zeros(1,size(k,1)); % some homogenous color;  happens to be green in default map
          t=trisurf(k,x(:,1),x(:,2),x(:,3),color','FaceAlpha',0.2,'EdgeAlpha',0.2);
        end
    end
