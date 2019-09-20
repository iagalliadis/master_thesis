classdef RMSFeature < Feature
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function featureSize = init(~,~)
            featureSize = 1;
        end
        function features    = run(~,data)
            features = rms(data);
        end
    end
    
end

