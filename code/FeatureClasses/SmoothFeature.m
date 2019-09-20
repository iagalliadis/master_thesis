classdef SmoothFeature < Feature
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    methods
        function featureSize = init(~,dataSize)
            featureSize = dataSize;
        end
        function features = run(~,data)
            features = smooth(data);
        end
    end

    
end

