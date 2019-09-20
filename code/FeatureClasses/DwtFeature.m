classdef DwtFeature < Feature
    %DWT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type;
        lvl;
    end
    
    methods
        function obj=DwtFeature(lvl,type)
            if ~any(strcmp(type,{'haar','db8','sym4','sym8','bior1.3','bior2.2','coif3','coif4'}))
                error(['unsupported DWT type ' type ]);
            end
            obj.type = type;
            obj.lvl = lvl;
        end
        function featureSize = init(obj,dataSize)
            data = rand(dataSize,1);
            res = wavedec(data,obj.lvl,obj.type);
            featureSize = length(res(:));
        end
        function features = run(obj,data)
            res = wavedec(data,obj.lvl,obj.type);
            features = res(:);
        end
        
    end
end

