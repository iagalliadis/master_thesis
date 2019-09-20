classdef Feature < handle
    methods (Abstract)
        featureSize = init(obj,dataSize)
        features    = run(obj,data)
    end
    
end

