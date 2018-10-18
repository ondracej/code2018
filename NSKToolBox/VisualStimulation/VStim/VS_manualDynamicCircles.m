classdef VS_manualDynamicCircles < VStim
    properties
        %all these properties are modifiable by user and will appear in visual stim GUI
        %Place all other variables in hidden properties
        
        %visualFieldBackgroundLuminance = 128;
        %visualFieldDiameter = 1024; %pixels
        %stimDuration = 1; %superclass VStim
        %interTrialDelay = 20; %superclass VStim
        %trialsPerCategory = 10;
        %preSessionDelay = 10;
        rotation = 0;
        imagesDir = [];
        randomizeOrder = true;
        circleDiameter = 100;
        circlePositionsX = 600;
        circlePositionsY = 400;
        nPlanesPerFrame = 1;
    end
    properties (Hidden,Constant)
        CMgetCirclePositionTxt='get the positions of the circle in real space (left click to choose, right click to end)';
        CMloadLuminanceDynamicsTxt='load file with dynamic luminance profile (dynamics[1xN] - mat file)';
        CMMakeTexturesTxt='precalculate textures for stimulation';
        
        rotationTxt='The rotation angle of the images (for alignment to visual streak';
        imagesDirTxt='The directory containing the images to show';
        randomizeOrderTxt = 'To randomize order of image appearance';
        nPlanesPerFrameTxt = 'for Light crafter applications this parameter defines the reduction in bit depth and increase in termporal resolution';
        remarks={'Categories in Flash stimuli are:',''};
    end
    properties (Hidden)
        flip
        stim
        flipEnd
        miss
        
        luminocityDynamics
        order=[];
        hScatter=[];
        hAxes=[];
        hMainHBox=[];
        stimulationTextures
        nFrames
    end
    methods
        %new
        function obj=run(obj)
            
            %run test Flip (usually this first flip is slow and so it is not included in the anlysis
            Screen('FillOval',obj.PTB_win,obj.visualFieldBackgroundLuminance,obj.visualFieldRect);
            Screen('DrawTexture',obj.PTB_win,obj.masktex);
            Screen('Flip',obj.PTB_win);
            
            obj.nTotTrials=obj.trialsPerCategory;
            
            %Pre allocate memory for variables
            tFrame=(0:obj.ifi:((obj.nFrames-1)*obj.ifi))';
            maxFrames=numel(tFrame);
            obj.flip=nan(obj.nTotTrials,maxFrames);
            obj.stim=nan(obj.nTotTrials,maxFrames);
            obj.flipEnd=nan(obj.nTotTrials,maxFrames);
            obj.miss=nan(obj.nTotTrials,maxFrames);
            
            if obj.simulationMode
                disp('Simulation mode finished running');
                return;
            end
            save tmpVSFile obj; %temporarily save object in case of a crash
            disp('Session starting');
            
            %run test Flip (usually this first flip is slow and so it is not included in the anlysis
            Screen('Flip',obj.PTB_win);
            
            %main loop - start the session
            pp(uint8(obj.trigChNames(1)),true,false,uint8(0),uint64(32784)); %session start trigger (also triggers the recording start)
            WaitSecs(obj.preSessionDelay); %pre session wait time
            for i=1:obj.nTotTrials
                pp(uint8(obj.trigChNames(2)),true,false,uint8(0),uint64(32784)); %session start trigger (also triggers the recording start)
                
                tFrameTmp=tFrame+GetSecs+obj.ifi;
                for j=1:obj.nFrames
                    % Update display
                    Screen('DrawTexture',obj.PTB_win,obj.stimulationTextures(j));
                    Screen('DrawingFinished', obj.PTB_win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
                    
                    pp(uint8(obj.trigChNames(3)),true,false,uint8(0),uint64(32784)); %session start trigger (also triggers the recording start)
                    [obj.flip(i,j),obj.stim(i,j),obj.flipEnd(i,j),obj.miss(i,j)]=Screen('Flip',obj.PTB_win,tFrameTmp(j));
                    pp(uint8(obj.trigChNames(3)),false,false,uint8(0),uint64(32784)); %session start trigger (also triggers the recording start)
                end
                
                Screen('FillOval',obj.PTB_win,obj.visualFieldBackgroundLuminance,obj.visualFieldRect);    
                %Screen('FillRect',obj.PTB_win,obj.visualFieldBackgroundLuminance);
                Screen('DrawTexture',obj.PTB_win,obj.masktex);
                Screen('DrawingFinished', obj.PTB_win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
                [endSessionTime]=Screen('Flip',obj.PTB_win);
                pp(uint8(obj.trigChNames(2)),false,false,uint8(0),uint64(32784)); %session start trigger (also triggers the recording start)
                % Start wait: Code here is run during the waiting for the new session
                
                % End wait
                disp(['Trial ' num2str(i) '/' num2str(obj.nTotTrials)]);
                
                %check if stimulation session was stopped by the user
                [keyIsDown, ~, keyCode] = KbCheck;
                if keyCode(obj.escapeKeyCode)
                    obj.lastExcecutedTrial=i;
                    return;
                end
                
                WaitSecs(obj.interTrialDelay-(GetSecs-endSessionTime));
            end
            WaitSecs(obj.postSessionDelay);
            pp(uint8(obj.trigChNames(1)),false,false,uint8(0),uint64(32784)); %session end trigger
            disp('Session ended');
        end
        
        function outStats=getLastStimStatistics(obj,hFigure)
            outStats.props=obj.getProperties;
            if nargin==2
                if obj.interTrialDelay~=0
                    intervals=-1e-1:2e-4:1e-1;
                    intCenter=(intervals(1:end-1)+intervals(2:end))/2;
                    stimDurationShifts=(obj.off_Flip-obj.on_Flip)-obj.actualStimDuration;
                    n1=histc(stimDurationShifts,intervals);
                    
                    flipDurationShiftsOn=obj.on_FlipEnd-obj.on_Flip;
                    flipDurationShiftsOff=obj.off_FlipEnd-obj.off_Flip;
                    n2=histc([flipDurationShiftsOn' flipDurationShiftsOff'],intervals,1);
                    
                    flipToStimOn=(obj.on_Stim-obj.on_Flip);
                    flipToStimOff=(obj.off_Stim-obj.off_Flip);
                    n3=histc([flipToStimOn' flipToStimOff'],intervals,1);
                    
                    n4=histc([obj.on_Miss' obj.on_Miss'],intervals,1);
                else %for the case that images are just switch so there is no interval between consecutive images
                    intervals=-1e-1:2e-4:1e-1;
                    intCenter=(intervals(1:end-1)+intervals(2:end))/2;
                    stimDurationShifts=(obj.on_Flip(2:end)-obj.on_Flip(1:end-1))-obj.actualStimDuration;
                    n1=histc(stimDurationShifts,intervals);
                    
                    flipDurationShiftsOn=obj.on_FlipEnd-obj.on_Flip;
                    flipDurationShiftsOff=flipDurationShiftsOn;
                    n2=histc([flipDurationShiftsOn' flipDurationShiftsOff'],intervals,1);
                    
                    flipToStimOn=(obj.on_Stim-obj.on_Flip);
                    flipToStimOff=flipToStimOn;
                    n3=histc([flipToStimOn' flipToStimOff'],intervals,1);
                    
                    n4=histc([obj.on_Miss' obj.on_Miss'],intervals,1);
                end
                figure(hFigure);
                subplot(2,2,1);
                bar(1e3*intCenter,n1(1:end-1),'Edgecolor','none');
                xlim(1e3*intervals([find(n1>0,1,'first')-3 find(n1>0,1,'last')+4]));
                ylabel('\Delta(Stim duration)');
                xlabel('Time [ms]');
                line([0 0],ylim,'color','k','LineStyle','--');
                
                subplot(2,2,2);
                bar(1e3*intCenter,n2(1:end-1,:),'Edgecolor','none');
                xlim([-0.5 1e3*intervals(find(sum(n2,2)>0,1,'last')+4)]);
                ylabel('Flip duration');
                xlabel('Time [ms]');
                legend('On','Off');
                line([0 0],ylim,'color','k','LineStyle','--');
                
                subplot(2,2,3);
                bar(1e3*intCenter,n3(1:end-1,:),'Edgecolor','none');
                xlim(1e3*intervals([find(sum(n3,2)>0,1,'first')-3 find(sum(n3,2)>0,1,'last')+4]));
                ylabel('Flip 2 Stim');
                xlabel('Time [ms]');
                legend('On','Off');
                line([0 0],ylim,'color','k','LineStyle','--');
                
                subplot(2,2,4);
                bar(1e3*intCenter,n4(1:end-1,:),'Edgecolor','none');
                xlim(1e3*intervals([find(sum(n4,2)>0,1,'first')-3 find(sum(n4,2)>0,1,'last')+4]));
                ylabel('Miss stats');
                xlabel('Time [ms]');
                legend('On','Off');
                line([0 0],ylim,'color','k','LineStyle','--');
            end
        end
        %class constractor
        function obj=VS_manualDynamicCircles(w,h)
            %get the visual stimulation methods
            obj = obj@VStim(w); %calling superclass constructor
            obj.visualFieldBackgroundLuminance=0;
        end
        %control methods
        function obj=CMgetCirclePosition(obj,srcHandle,eventData,hPanel)
            obj.hMainHBox=uiextras.HBox('Parent',hPanel, 'Padding', 10, 'Spacing', 10);
            hVBox=uiextras.VBox('Parent',obj.hMainHBox, 'Padding', 10, 'Spacing', 10);
            
            hClearAllPush=uicontrol('Parent', hVBox, 'Style','push','String','Clear all','HorizontalAlignment','Left','Callback',@obj.clearAllPushCallback);
            hFinishPush=uicontrol('Parent', hVBox, 'Style','push','String','Finish','HorizontalAlignment','Left','Callback',@obj.finishPushCallback);
            hAddPositions=uicontrol('Parent', hVBox, 'Style','push','String','Add positions','HorizontalAlignment','Left','Callback',@obj.addPositionsCallback);
            
            obj.hAxes=axes('Parent',obj.hMainHBox);
            set(obj.hMainHBox,'Sizes',[-1 -7]);
            
            axis(obj.hAxes,'equal');
            xlim(obj.hAxes,[obj.rect(1) obj.rect(3)]);
            ylim(obj.hAxes,[obj.rect(2) obj.rect(4)]);
            set(obj.hAxes,'color','k');
            hold(obj.hAxes,'on');
            
            %viscircles(centers,radii)
            obj.hScatter=scatter(obj.hAxes,obj.circlePositionsX,obj.circlePositionsY,pi*(obj.circleDiameter/2).^2,[1 1 1],'filled');
        end
        function obj=CMMakeTextures(obj,srcHandle,eventData,hPanel)
            disp('preparing textures');
            if ~isempty(obj.stimulationTextures)
                Screen('Close',obj.stimulationTextures);
            end
            
            % Create textures for all images
            nCircles=numel(obj.circlePositionsY);
            if numel(obj.circleDiameter)==1 & nCircles>1
                obj.circleDiameter=obj.circleDiameter*ones(1,nCircles);         
                disp('Taking the same diameter of all circles');
            end
            if size(obj.luminocityDynamics,1)==1 & nCircles>1
                obj.luminocityDynamics=ones(nCircles,1)*obj.luminocityDynamics;
                disp('Taking the same dynamics of all circles');
            end
            
            I=cell(1,nCircles);
            [xMesh,yMesh]=meshgrid(1:obj.rect(4),1:obj.rect(4));
            for i=1:nCircles
                Itmp=zeros(obj.rect(4),obj.rect(4));
                p=find(((xMesh-obj.circlePositionsX(i)).^2+(yMesh-obj.circlePositionsY(i)).^2) <= round((obj.circleDiameter(i)/2)).^2);
                Itmp(p)=true;
                I{i}=Itmp;
            end
            
            nTimeStamps=size(obj.luminocityDynamics,2);
            obj.nFrames=ceil(nTimeStamps/obj.nPlanesPerFrame);
            obj.stimDuration=obj.nFrames*obj.ifi;
            for i=1:obj.nFrames
                Itmp=zeros(obj.rect(4),obj.rect(4),obj.nPlanesPerFrame);
                for j=1:nCircles
                    tmpDynamics(1,1,1:obj.nPlanesPerFrame)=obj.luminocityDynamics(j,((i-1)*obj.nPlanesPerFrame+1):min(obj.nPlanesPerFrame*i,nTimeStamps));
                    Itmp=Itmp+bsxfun(@times,I{j},tmpDynamics);
                end
                if obj.nPlanesPerFrame>1
                    Itmp(Itmp>1)=1;
                    [rgbFrame]=LC_bin2rgb(Itmp);
                    %subplot(1,3,1);imagesc(squeeze(rgbFrame(:,:,1)),[0 255]);subplot(1,3,2);imagesc(squeeze(rgbFrame(:,:,2)),[0 255]);subplot(1,3,3);imagesc(squeeze(rgbFrame(:,:,3)),[0 255]);
                    obj.stimulationTextures(i)=Screen('MakeTexture', obj.PTB_win, rgbFrame, obj.rotation);
                    %plot(squeeze(tmpDynamics));pause;
                elseif obj.nPlanesPerFrame==1
                    obj.stimulationTextures(i)=Screen('MakeTexture', obj.PTB_win, Itmp, obj.rotation);
                end
            end
            disp('Done preparing textures');    
            beep;
        end
        function obj=addPositionsCallback(obj,srcHandle,eventData)
            title(obj.hAxes,'Position centers (enter to finish, backspace to remove)');
            [obj.circlePositionsX,obj.circlePositionsY] = getpts(obj.hAxes);
            if ishandle(obj.hScatter)
                delete(obj.hScatter);
            end
            obj.hScatter=scatter(obj.hAxes,obj.circlePositionsX,obj.circlePositionsY,pi*(obj.circleDiameter/2).^2,[1 1 1],'filled');
        end
        function obj=clearAllPushCallback(obj,srcHandle,eventData)
            obj.circlePositionsX=[];
            obj.circlePositionsY=[];
            if ishandle(obj.hScatter)
                delete(obj.hScatter);
            end
        end
        function obj=finishPushCallback(obj,srcHandle,eventData)
            delete(obj.hMainHBox);
        end
        function obj=CMloadLuminanceDynamics(obj,srcHandle,eventData,hPanel)
            [FileName,PathName]=uigetfile('*.mat');
            loadedData=load([PathName FileName]);
            fieldNames=fields(loadedData);
            obj.luminocityDynamics=loadedData.(fieldNames{1});
            obj.stimDuration=ceil(size(obj.luminocityDynamics,2)/obj.nPlanesPerFrame)*obj.ifi;
        end
    end
end %EOF