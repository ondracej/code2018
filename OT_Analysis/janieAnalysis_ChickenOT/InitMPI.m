function status = InitMPI(userID, overrideAnimalName, additional_parameters) %#ok<INUSD>
% Creates "cfg" and "paths" structures inside the base workspace which are 
% needed by other programs.
%
%
% You always need to pass the "userID" variable. "overrideAnimalName" is used
% to switch between different animals in GUI programs (like FileBrowser).
% "additional_parameters" is routed into your personal "InitVars_{userID}"
% function and gives you more power on how to setup the correct variables.
%
% Usage:
%
%  1) InitMPI(2)
%       -> load default configuration file (InitVars_2) for user 2
%
%  2) InitMPI(2, 'D18')
%       -> load default configuration for user 2, but override the default 
%          animal name.
%           
%  3) InitMPI(2, 'D18', 'H')
%       -> load default configuration for user 2, but override the default 
%          animal name and pass an additional parameter to the config file. 
%          What you do with this parameter inside your config file is up 
%          to you.
%
%
%% 
% userID is a number identifying the user
%
% -1: dummy user - will only add the current work directory (and all
% subdirectories to its path - no config files will be processed).

%% NEW USERS:

% please add your name to the end of the "users" variable
% go to: "/InitConfigs/" and copy the "InitVars_template.m" file
% to, e.g., "InitVars_14.m" (if your userID is 14).

% to get a chronological list of users for the group NSK, do:
% $ ldapsearch -h MPIH.MPIH-FRANKFURT.MPG.DE -b 'OU=NSK,OU=MpihUsers,DC=MPIH,DC=MPIH-Frankfurt,DC=mpg,DC=de' -D "akotowicz@MPIH" -W description whenCreated -S whenCreated
%
% your userID is in {} next to your name. 
% i.e., Ingmar's userID is '6'
users{1} = 'Gilles';
users{2} = 'Christian';
users{3} = 'Sina';
users{4} = 'Viola';
users{5} = 'Lorenz';
users{6} = 'Ingmar';
users{7} = 'Stephan';
users{8} = 'Ueli';
users{9} = 'Andreas';
users{10} = 'Mike';
users{11} = 'Julien';
users{12} = 'Tracy';
users{13} = 'Mark';
users{14} = 'Janie';

%% DO NOT CHANGE ANYTHING BELOW THIS LINE!



    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % you should not need to change anything below this line. %%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    %% by default we assume that everything runs ok so we expect an exit
    % status == 0
   
    
    %% check input arguments
    
    if nargin < 3
        additional_parameters = []; %#ok<NASGU>
    end
    
    
    if nargin < 2
        overrideAnimalName = [];
    end


    if nargin < 1
        disp('Please provide your userID: "InitMPI(userID)"');
        disp('If you are using this program for the first time, make sure to create a userID (ask someone in the lab how to do this).');
        status = 1;
        return;
    end
    
    %% find the default matlab work directory and add it to the path.
    
	[status, top_level] = find_work_directory();
    if status == 1
        return;
    end
    
    %% add java paths
    % not a good idea, because the number of matlab workers might change during the session.
    %     pool_slaves = pool_size();
    %     dd = filesep;
    %     javapath1 = [top_level dd 'FlatClust' dd 'evalkey1' dd 'HelpExtractor'];
    %     try
    %         if pool_slaves > 0
    %             pctRunOnAll(['javaaddpath({''' javapath1 '''})']);
    %             
    %         else
    %             javaaddpath({javapath1});
    %         end
    %     catch me
    %         custom_db_stack(me.message, me.stack, 'InitMPI()', '"matlabpool" not found or "javaaddpath" error. Please talk to sepp or kotowicz', me.identifier);
    %     end
    
    %% add subdirectories to path and quit if requested.
    if userID == -1
        add_top_level_path_recursive(top_level, '', '', '', '', '');
        return;
    end
    
    
    %% evaluate the user specific configuration file
    % e.g. InitVars_1.m
    % e.g. InitVars_template.m
    
    InitVarsName = ['InitVars_' num2str(userID)];
    
    if ~(exist(InitVarsName, 'file') == 2)
        disp(['Sorry, could not find a valid InitVars file for your userID: ' num2str(userID)]);
        status = 1;
        return;
    end


    %% configure settings
    
    % instantiate default settings
    newconfig = InitVarsConfigClass(); %#ok<NASGU>
    
    % load user settings
    newconfig = eval([InitVarsName '(newconfig, overrideAnimalName, additional_parameters)']);

    % write settings back to local variables
    homedir = newconfig.matlabcode_path;
    data_path = newconfig.data_path;
    Adata_path = newconfig.analyzed_data_path;
    animalName = newconfig.animalName;
    setup_used = newconfig.AcquisitionSystem;
    this_hostname = newconfig.hostname;
    
    %% set up the directory delimiter accordingly to the OS used
    dd = filesep();

    %% make sure our paths have the right ending, otherwise some toolboxes will
    % fail to run.
    homedir = check_path_for_correct_ending(homedir, dd);
    data_path = check_path_for_correct_ending(data_path, dd);
    Adata_path = check_path_for_correct_ending(Adata_path, dd);    
    
    %% basic checks for given directories.

    % wrong parameters set
    if exist('homedir', 'var') == 0 || exist('data_path', 'var') == 0 || exist('Adata_path', 'var') == 0
        add_top_level_path_recursive(top_level, data_path, Adata_path, animalName, setup_used, InitVarsName);
        disp('Something is wrong with your path variables. Please check your settings.');
        status = wrong_paths(homedir, data_path, Adata_path, animalName, setup_used, InitVarsName);
        return;
    end

    % wrong userid choosen
    if exist(homedir, 'dir') == 0
        add_top_level_path_recursive(top_level, data_path, Adata_path, animalName, setup_used, InitVarsName);
        disp('I can not find the "homedir" you provided. Did you choose the wrong userID?');
        status = wrong_paths(homedir, data_path, Adata_path, animalName, setup_used, InitVarsName);
        return;
    end

    if exist(data_path, 'dir') == 0
        add_top_level_path_recursive(top_level, data_path, Adata_path, animalName, setup_used, InitVarsName);
        disp('Seems you have set the wrong "data_path". Please fix your "InitVars_x" file.');
        status = wrong_paths(homedir, data_path, Adata_path, animalName, setup_used, InitVarsName);
        return;
    end
    
    %% Add the matlab code directory to the MATLAB path variable
    
    status = add_top_level_path_recursive(homedir, data_path, Adata_path, animalName, setup_used, InitVarsName);
    if status == 1
        return;
    end


%% populate paths based on base paths

    %% replace the animalName if requested by user. We use this feature in
    % case we need to reinitialize our variables while switching between
    % animals in spikesort or analyze. 

    % don't do anything, if no overrideAnimalName is given -> animalName stays
    % as configured in user's InitVars_{x} file.
    % in case one is given, only change the current animalName to
    % overrideAnimalName, if the strings do not match. This is the normal
    % case, since overrideAnimalName is only passed to InitVars_{x}, but as
    % long as a user does not remap the names internally, we will have two
    % different names here.
    if ~isempty(overrideAnimalName) && ~strcmp(animalName, overrideAnimalName)
        animalName = overrideAnimalName;
    end
    
    %%
    paths = create_path_structure(data_path, Adata_path, dd, animalName, homedir);
    
%% quit if the directory for this animal doesn't exist - or ask user whether
%  he / she want to create this directory.

    if exist(paths.bird_path, 'dir') == 0
        % make sure user did not call InitMPI from an external
        % program, switching to a new data directory.
        if ~(evalin('base', 'exist(''paths'')') && evalin('base', 'isfield(paths, ''data_path'')'))
            disp(' ');
            disp('You probably chose the wrong animal in the "InitMPI" file.');
            disp(' ');
            disp('The following directory does not exist:');
            disp(paths.bird_path);

            reply = input('Do you want to create this directory? Yes = 1 / No = 0: ');
            if reply == 1
                mkdir(paths.bird_path);
                disp('Created directory.');
            end

            disp(' ');
            disp('Quitting. Please re-run InitMPI.');
            status = 1;
            return;
        end
        
        new_data_path = evalin('base', 'paths.data_path');
        paths = create_path_structure(new_data_path, '', dd, animalName, homedir);
        if exist(paths.bird_path, 'dir') == 0
            disp('The given data directory contains no data for the given animal.');
            % there's a reason why we have this here. if you need to comment
            % this out, then please specify WHY. or Better: make an extra case.
            wrong_paths(homedir, data_path, Adata_path, animalName, setup_used, InitVarsName);
            status = 1;
            return;
        end
        
        disp('Be careful! your ''paths.Adata_path'' is empty!');
        status = -1;

    end

%% create missing subdirectories for this animal - if they don't exist.

    %     if exist([paths.bird_path 'Figures'], 'dir') == 0
    %         try
    %             mkdir([paths.bird_path 'Figures'])
    %         catch me
    %             fprintf('check write permissions no Figures folder created\n');
    %             disp(me.message);
    %         end
    %     end
    % 
    %     if exist([paths.analyze_path 'Spikes'], 'dir') == 0
    %         try
    %             mkdir([paths.analyze_path 'Spikes']),
    %         catch me
    %             fprintf('check write permissions no Spikes folder created\n');
    %             disp(me.message);
    %         end
    %     end

%% populate the paths to the current environment

    addpath(paths.bird_path);

%% load the setup configuration
    setup_file = ['CurrentSetupInit' setup_used];
    possible_file = dir([paths.bird_path 'CurrentSetupInit*.m']);


    % user probably switched between animals using one of our programs, so
    % let's use this file.
    if size(possible_file, 1) == 1
        eval(possible_file.name(1:end-2));
        disp(['Loaded ' possible_file.name]);

    elseif exist([paths.bird_path setup_file '.m'], 'file') == 2

        eval(setup_file);
        disp(['Loaded ' setup_file]);

    elseif exist([paths.bird_path 'CurrentSetupInit.m'], 'file') == 2

        CurrentSetupInit;
        disp('Loaded CurrentSetupInit.m');

    else

        disp(['CurrentSetupInit' setup_used ' not found in ' paths.bird_path '.']);
        disp('Copying a CurrentSetupInit from a template file. You may have to change the settings in the new file!');
        copyfile([paths.homedir dd 'Templates' dd 'CurrentSetupInit' setup_used '_template.m'], [paths.bird_path setup_file '.m']);
        run([paths.bird_path setup_file '.m']);
        disp(['Loaded CurrentSetupInit' setup_used]);

    end
    
    
%% load additional config files
    [FlatClustConfig, PluginConfig] = load_addons(paths);
    
%% If old version of Currentbird init is loaded, load the template

    if ~exist('cfg', 'var')
        setup_file = ['CurrentSetupInit' setup_used '_template'];
        eval(setup_file);
        fprintf('Warning! Your CurrentSetupInit is missing the "cfg" structure. Default CurrentSetupInit used!\n');
    end


%% parameters

    screenUnits = get(0, 'Units');
    set(0, 'Units', 'pixels');
    set(0, 'Units', screenUnits);

%%

    %% dump variables into workspace
    % don't export any of these variables with GLOBAL!!

    assignin('base', 'paths', paths);
    assignin('base', 'dd', dd);
    assignin('base', 'animalName', animalName);
    assignin('base', 'userID', userID);

    % need this until every one has switched to the "cfg" namespace
    % this code needs to be synced with fl_chg_animal_run_current_init.m
    if exist('cfg', 'var')
        % make sure to update 'fl_chg_animal_run_current_init' in case
        % you add any fields here.
        cfg = checkin_addons(cfg, FlatClustConfig, PluginConfig);
        cfg.userID = userID;
        cfg.hostname = this_hostname;
        cfg.animalName = animalName;
        assignin('base', 'cfg', cfg);
    end

%% we are done.

    if isempty(overrideAnimalName)
        fprintf(' \n');
        fprintf('*************************************************** \n');
        fprintf(['************** Welcome back ' users{userID} ' **************** \n']);
        fprintf('*************************************************** \n');
        fprintf(' \n');
        fprintf('successfully initialized variables in "InitMPI.m" \n');
    else
        fprintf('successfully reinitialized variables in "InitMPI.m" \n');
    end
    fprintf(['current animal: '  animalName  '  \n']);

%% EOF

end


function status = wrong_paths(homedir, data_path, Adata_path, animalName, setup_used, InitVarsName)

    status = 1;
    disp(' ');
    disp('You''ve set the following parameters:');
    disp(' ');
    disp(['homedir: ' homedir]);
    disp(['data_path: ' data_path]);
    disp(['Adata_path: ' Adata_path]);
    disp(['animalName: ' animalName]);
    disp(['setup_used: ' setup_used]);
    disp(' ');
    disp([InitVarsName ' was used.']);
    disp(' ');
    
end

function status = add_top_level_path_recursive(homedir, data_path, Adata_path, animalName, setup_used, InitVarsName)

    status = 0;

    % first, add the top-level directory itself.
    addpath(homedir);

    % now, add all subdirectories, ignoring the .svn directories.
    final_list = generate_work_path(homedir);

    if isempty(final_list)
        disp('Could not determine your MATLAB path.');
        status = wrong_paths(homedir, data_path, Adata_path, animalName, setup_used, InitVarsName);
        return;
    end

    addpath(final_list{:});
    
end

%% EOF
