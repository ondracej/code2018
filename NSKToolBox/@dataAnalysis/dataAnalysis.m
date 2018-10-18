classdef dataAnalysis
    properties
        
    end
    properties (Hidden)
        
    end
    methods
        
    end
    methods (Hidden)
        %class constructor
        function obj = dataAnalysis()
            addlistener(obj,'M','PostSet',@obj.changedDataEvent); %add a listener to M, after its changed its size is updated in the changedDataEvent method
            %get the plot names
            allMethods=methods(class(obj));
            obj.plotMethods=allMethods(strncmp('plot',allMethods,4));
            obj.plotNames=cellfun(@(x) x(5:end),obj.plotMethods,'UniformOutput',0); %remove the "plot" from the string
            obj.plotCreateMethods=cellfun(@(x) ['create' x(5:end)], obj.plotMethods,'UniformOutput',0);
        end
        
    end
end %EOF