classdef InitVarsConfigClass
% default config class for InitMPI - makes sure that all necessary settings
% are present.

    %% PUBLIC properties
    properties
        matlabcode_path = [];
        data_path = [];
        analyzed_data_path = [];
        animalName = [];
        AcquisitionSystem = [];
    end
    
    %% PUBLIC READ-ONLY properties
    properties (SetAccess = private, GetAccess = public)
        hostname = [];
    end
    
    %% PUBLIC METHODS
    methods
        function obj = InitVarsConfigClass()
            % get hostname
            obj.hostname = gethostname();
        end
        
        function UnpackProperties(obj)
            % list of properties that are needed inside the InitVars_*
            % files.
            props = properties(obj);
            num_props = numel(props);
               
            for i = 1 : num_props
                prop_this_loop = props{i};
                assignin('caller', prop_this_loop, obj.(prop_this_loop));
            end
            
        end
       
        function obj = PackProperties(obj)
            
            % the regexp in the caller function doesn't work - I don't really get why.
            % l = evalin('caller', 'whos -regexp matlabcode_path|data_path|all_variables|obj');
            listOfModifieableProperties = ReturnListOfModifiableProperties(obj);
            
            % go through the list of properties and write them back to the
            % object.
            for i = 1 : numel(listOfModifieableProperties)
                this_loop_prop = listOfModifieableProperties{i};
                obj.(this_loop_prop) = evalin('caller', this_loop_prop);
            end
            
        end
        
        
    end
    
    %% PRIVATE METHODS
    methods (Access = private)
        
        function list = ReturnListOfModifiableProperties(obj)
            % list of all properties of this class
            props = properties(obj);
            % list of all read-only properties 
            listOfReadOnlyProperties = obj.ReturnListOfReadOnlyProperties();
            % create the regexp from the previous list
            regexpression = obj.CreateRegExpStringFromCellOfStrings(listOfReadOnlyProperties);
            % remove the read-only properties from the list of all
            % properties
            prop_indices_to_remove = cellfun(@(x) ~isempty(x), regexp(props, regexpression));
            props(prop_indices_to_remove) = [];
            % return valid list.
            list = props;
        end
        
    end

    %% STATIC methods
    methods (Static = true)
        
        function list = ReturnListOfReadOnlyProperties()
           list{1, 1} = 'hostname';
           % add new properties like this
           %list{2, 1} = 'blabla';
        end
        
        function regexpression = CreateRegExpStringFromCellOfStrings(cell_strings)
        % create regular expression string from list of strings.
        
            regexpression = '';
            
            for j = 1 : numel(cell_strings);
                this_loop_string = cell_strings{j};
                if j == 1
                    % open reg expression
                    regexpression = ['(' this_loop_string];
                else
                    % add current string, concatenate with 'OR'
                    regexpression = [regexpression '|' this_loop_string]; %#ok<AGROW>
                end
            end

            % close the reg expression.
            regexpression = [regexpression ')'];
            
        end
        
    end

end
%% EOF
