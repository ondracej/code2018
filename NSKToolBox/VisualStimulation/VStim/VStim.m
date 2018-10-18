classdef (Abstract) VStim < handle
    properties (SetAccess=public)
        %all these properties are modifiable by user and will appear in visual stim GUI
        %Place all other variables in hidden properties
        interTrialDelay = 0.5; %sec
        trialsPerCategory = 2;
        preSessionDelay = 1;
        postSessionDelay = 0;
        trialStartTrig = 'MC=2,Intan=6';
    end
    properties (SetObservable, AbortSet = true, SetAccess=public)
        visualFieldBackgroundLuminance = 64;
        visualFieldDiameter = 0; %pixels
        inVivoSettings = false;
        stimDuration = 2;
        backgroundMaskSteepness = 0.2;
    end
    properties (Constant)
        backgroudLuminance = 0;
        maxTriggers=4;
        
        visualFieldBackgroundLuminanceTxt = 'The luminance of the circular visual field that is projected to the retina';
        visualFieldDiameterTxt = 'The diameter of the circular visual field that is projected to the retina [pixels], 0 takes maximal value';
        stimDurationTxt='The duration of the visual stimuls [s]';
        interTrialDelayTxt='The delay between trial end and new trial start [s], if vector->goes over all delays';
        trialsPerCategoryTxt='The number of repetitions shown per category of stimuli';
        preSessionDelayTxt='The delay before the begining of a recording session [s]';
        postSessionDelayTxt='The delay after the ending of a recording session [s]';
        backgroundMaskSteepnessTxt='The steepness of the border on the visual field main mask [0 1]';
    end
    properties (SetAccess=protected)
        mainDir %main directory of visual stimulation toolbox
        rect %the coordinates of the screen [pixels]: (left, top, right, bottom)
        fps %monitor frames per second
        ifi %inter flip interval for monitor
        actualStimDuration % the actual stim duration as an integer number of frames
        centerX %the X coordinate of the visual field center
        centerY %the Y coordinate of the visual field center
        actualVFieldDiameter % the actual diameter of the visual field
        nTotTrials = []; %the total number of trials in a stimulatin session
        
        hInteractiveGUI %in case GUI is needed to interact with visual stimulation
    end
    
    properties (Hidden, SetAccess=protected)
        fSep = '\';
        escapeKeyCode = []; %the key code for ESCAPE
        dirSep=filesep; %choose file/dir separator according to platform
        OSPlatform = 1 %checks what is the OS for sending TTLs: Window (1) or Linux (2) or simulation mode (3)
        binaryMultiplicator = [1 2 4 8 16 32 64 128];
        currentBinState = [false false false false false false false false];
        io %parallel port communication object for PC
        
        parallelPortNum %Parallel port default number
        
        PTB_win %Pointer to PTB window
        whiteIdx %black index for screen
        blackIdx %black index for screen
        trigChNames=[[2;3;4;5] [6;7;8;9]]; %the channel order for triggering in parallel port (first channel will be one)
        visualFieldRect % the coordinates of the rectanle of visual field [pixel]
        masktexOn %the mask texture for visual field with on rectangle on bottom left corner
        masktexOff %the mask texture for visual field with on rectangle on bottom left corner
        visualFieldBackgroundTex %the background texture (circle) for visual field
        errorMsg=[]; %The message the object returns in case of an error
        simulationMode = false; %a switch that is used to prepare visual stimulation without applying the stimulation itself
        lastExcecutedTrial = 0; %parameter that keeps the number of the last excecuted trial
        syncSquareSizePix = 60; % the size of the the corder square for syncing stims
        syncMarkerOn = false;
    end
    methods
        %class constractor
        function obj=VStim(PTB_WindowPointer,interactiveGUIhandle)
            addlistener(obj,'visualFieldBackgroundLuminance','PostSet',@obj.initializeBackground); %add a listener to visualFieldBackgroundLuminance, after its changed its size is updated in the changedDataEvent method
            addlistener(obj,'visualFieldDiameter','PostSet',@obj.initializeBackground); %add a listener to visualFieldDiameter, after its changed its size is updated in the changedDataEvent method
            addlistener(obj,'backgroundMaskSteepness','PostSet',@obj.initializeBackground); %add a listener to backgroundMaskSteepness, after its changed its size is updated in the changedDataEvent method
            addlistener(obj,'stimDuration','PostSet',@obj.updateActualStimDuration); %add a listener to stimDuration, after its changed its size is updated in the changedDataEvent method

            if nargin==2
                obj.hInteractiveGUI=interactiveGUIhandle;
            end
            obj.fSep=filesep; %get the file separater according to opperating system
            
            % Enable alpha blending with proper blend-function.
            AssertOpenGL;
            
            %define the key code for escape for KbCheck
            KbName('UnifyKeyNames');
            obj.escapeKeyCode = KbName('ESCAPE');
            if nargin==0
                error('PTB window pointer is required to construct VStim object');
            end
            obj.PTB_win=PTB_WindowPointer;
            Screen('BlendFunction', obj.PTB_win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            
            %get the visual stimulation methods
            tmpDir=which('VStim'); %identify main folder
            [obj.mainDir, name, ext] = fileparts(tmpDir);
            
            %initialized TTL signalling
            NSKToolBoxMainDir=fileparts(which('identifierOfMainDir4NSKToolBox'));
            parPortFile=[NSKToolBoxMainDir filesep 'PCspecificFiles' filesep 'parallelPortAddress.txt'];
            if exist(parPortFile,'file')
                parPortAddress = dlmread(parPortFile);
                obj.initializeTTL(parPortAddress);
            else
                obj.initializeTTL;
            end

            obj.whiteIdx=WhiteIndex(obj.PTB_win);
            obj.blackIdx=BlackIndex(obj.PTB_win);
            if obj.visualFieldBackgroundLuminance<obj.blackIdx || obj.visualFieldBackgroundLuminance>obj.whiteIdx
                disp('Visual field luminance is not within the possible range of values, please change...');
                return;
            end
            
            %get general information
            obj.rect=Screen('Rect', obj.PTB_win);
            
            obj.fps=Screen('FrameRate',obj.PTB_win);      % frames per second
            obj.ifi=Screen('GetFlipInterval', obj.PTB_win); %inter flip interval
                        
            %calculate optimal stim duration (as an integer number of frames)
            obj=updateActualStimDuration(obj);
            
            %set background luminance
            obj.initializeBackground;
            
            obj.sendTTL(1:4,[false false false false])
        end
        
        function estimatedTime=estimateProtocolDuration(obj)
            %estimated time is given is seconds
            obj.simulationMode=true;
            obj=obj.run;
            estimatedTime=obj.nTotTrials*(mean(obj.actualStimDuration)+mean(obj.interTrialDelay))+obj.preSessionDelay+obj.postSessionDelay;
            obj.simulationMode=false;
        end
        
        function applyBackgound(obj) %apply background and change the synchrony marker state (on/off)
            obj.syncMarkerOn=~obj.syncMarkerOn;
            if obj.syncMarkerOn
                Screen('DrawTexture',obj.PTB_win,obj.masktexOn);
            else
                Screen('DrawTexture',obj.PTB_win,obj.masktexOff);
            end
            Screen('DrawingFinished', obj.PTB_win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        end
        
        function initializeBackground(obj,event,metaProp)
            noMask=false;
            if obj.visualFieldDiameter==0
                obj.actualVFieldDiameter=min(obj.rect(3)-obj.rect(1),obj.rect(4)-obj.rect(2));
            elseif obj.visualFieldDiameter==-1
                noMask=true;
                obj.actualVFieldDiameter=min(obj.rect(3)-obj.rect(1),obj.rect(4)-obj.rect(2));
            else
                obj.actualVFieldDiameter=obj.visualFieldDiameter;
            end
            obj.centerX=(obj.rect(3)+obj.rect(1))/2;
            obj.centerY=(obj.rect(4)+obj.rect(2))/2;
            
            obj.visualFieldRect=[obj.centerX-obj.actualVFieldDiameter/2,obj.centerY-obj.actualVFieldDiameter/2,obj.centerX+obj.actualVFieldDiameter/2,obj.centerY+obj.actualVFieldDiameter/2];
            [x,y]=meshgrid((-obj.actualVFieldDiameter/2):(obj.actualVFieldDiameter/2-1),(-obj.actualVFieldDiameter/2):(obj.actualVFieldDiameter/2-1));
            %sig = @(x,y) 1 ./ (1 + exp( (sqrt(x.^2 + y.^2 - (obj.actualVFieldDiameter/2-50).^2 )) ));
            sig = @(x,y) 1-1 ./ ( 1 + exp(sqrt(x.^2 + y.^2) - obj.actualVFieldDiameter/2+1).^obj.backgroundMaskSteepness );
            
            %maskblob=ones(obj.actualVFieldDiameter, obj.actualVFieldDiameter, 2) * obj.backgroudLuminance;
            %maskblob(:,:,2)=sig(x,y)*obj.whiteIdx;
            
            maskblobOff=ones(obj.rect(4)-obj.rect(2),obj.rect(3)-obj.rect(1),2) * obj.whiteIdx;
            maskblobOff(:,:,1)=obj.blackIdx;
            if ~noMask 
                maskblobOff((obj.visualFieldRect(2)+1):obj.visualFieldRect(4),(obj.visualFieldRect(1)+1):obj.visualFieldRect(3),2)=sig(x,y)*obj.whiteIdx;
            else
                maskblobOff(:,:,2)=0;
            end
            
            if obj.inVivoSettings==1
            maskblobOff=ones(obj.rect(4)-obj.rect(2),obj.rect(3)-obj.rect(1),2) * obj.blackIdx;
            maskblobOff(:,:,1)=obj.blackIdx;
            end
            
            maskblobOn=maskblobOff;
            maskblobOn((obj.rect(4)-obj.syncSquareSizePix):end,1:obj.syncSquareSizePix,:)=obj.whiteIdx;
            maskblobOff((obj.rect(4)-obj.syncSquareSizePix):end,1:obj.syncSquareSizePix,2)=obj.whiteIdx;
            
            % Build a single transparency mask texture:
            obj.masktexOn=Screen('MakeTexture', obj.PTB_win, maskblobOn);
            obj.masktexOff=Screen('MakeTexture', obj.PTB_win, maskblobOff);
            
            Screen('FillRect',obj.PTB_win,obj.visualFieldBackgroundLuminance);
            obj.syncMarkerOn = false;
            Screen('DrawTexture',obj.PTB_win,obj.masktexOff);
            
            Screen('Flip',obj.PTB_win);
        end
        
        function [props]=getProperties(obj)
            props.metaClassData=metaclass(obj);
            props.allPropName={props.metaClassData.PropertyList.Name}';
            props.allPropSetAccess={props.metaClassData.PropertyList.SetAccess}';
            props.publicPropName=props.allPropName(find(strcmp(props.allPropSetAccess, 'public')));
            for i=1:numel(props.publicPropName)
                if isprop(obj,[props.publicPropName{i} 'Txt']);
                    props.publicPropDescription{i,1}=obj.([props.publicPropName{i} 'Txt']);
                else
                    props.publicPropDescription{i,1}='description missing (add a property to the VStim object with the same name as the property but with Txt in the end)';
                end
                props.publicPropVal{i,1}=obj.(props.publicPropName{i});
            end
            %collect all prop values
            for i=1:numel(props.allPropName)
                props.allPropVal{i,1}=obj.(props.allPropName{i});
            end
        end
        
        function [VSMethods]=getVSControlMethods(obj)
            VSMethods.methodName=methods(obj);
            VSMethods.methodDescription={};
            pControlMethods=cellfun(@(x) sum(x(1:2)=='CM')==2,VSMethods.methodName);
            VSMethods.methodName=VSMethods.methodName(pControlMethods);
            for i=1:numel(VSMethods.methodName)
                if isprop(obj,[VSMethods.methodName{i} 'Txt']);
                    VSMethods.methodDescription{i,1}=obj.([VSMethods.methodName{i} 'Txt']);
                else
                    VSMethods.publicPropDescription{i,1}='description missing (add a property to the VStim object with the same name as the method but with Txt in the end)';
                end
                
                VSMethods.methodName{i,1}=VSMethods.methodName{i};
            end
        end
        
        function initializeTTL(obj,parallelPortNum)
            if ispc
                if strcmp(getenv('COMPUTERNAME'),'M-01081') % for the case where there is no parallel port
                    obj.OSPlatform=3;
                else
                    obj.OSPlatform=1;
                end
            else
                obj.OSPlatform=2;
            end
            
            if obj.OSPlatform==1 %window
                if isempty(obj.io)
                    %create IO64 interface object
                    obj.io.ioObj = io64();
                    
                    %install the inpoutx64.dll driver, status = 0 if installation successful
                    obj.io.status = io64(obj.io.ioObj);
                    
                    if (obj.io.status ~= 0)
                        error('inp/outp installation failed!!!!')
                    end
                    
                    if nargin==1
                        obj.parallelPortNum=956; %hex2dec('278')=632
                    else
                        obj.parallelPortNum=parallelPortNum;
                    end
                else
                    disp('Parallel port object already exists');
                end
                
            elseif obj.OSPlatform==2 % linux
                
                if nargin==1
                    obj.parallelPortNum=32784;
                else
                    obj.parallelPortNum=parallelPortNum;
                end
                
            end
            sendTTL(obj,1:4,false(1,4));
            sendTTL(obj,1:4,true(1,4));
            WaitSecs(0.5);
            sendTTL(obj,1:4,false(1,4));
        end %function initializeTTL
        
        function sendTTL(obj,TTLNum,TTLValue)
            if obj.OSPlatform==1
                obj.currentBinState(TTLNum)=TTLValue;
                io64(obj.io.ioObj,obj.parallelPortNum,sum(obj.binaryMultiplicator.*obj.currentBinState));
            elseif obj.OSPlatform==2
                pp(uint8(obj.trigChNames(TTLNum,:)),[TTLValue TTLValue],false,uint8(0),uint64(obj.parallelPortNum)); %session start trigger (also triggers the recording start)
            else
                disp(['Simulation mode trigger/value - ' num2str([TTLNum TTLValue])]);
            end
        end
        
        function obj=updateActualStimDuration(obj,event,metaProp)
            %calculate optimal stim duration (as an integer number of frames)
            obj.actualStimDuration=round(obj.stimDuration/obj.ifi)*obj.ifi;
        end
        
        function outStats=getLastStimStatistics(obj,hFigure)
        end
        
        function outPar=run(obj)
        end
        
        function cleanUp(obj)
        end
        
    end
end %EOF