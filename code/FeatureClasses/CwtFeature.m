classdef CwtFeature < Feature
    %CWTFEATURE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function featureSize = init(~,dataSize)
            featureSize = dataSize;
        end
        function features = run(~,data)
            fs = 200;
            for i = 1:8
            features.amor = real(cwt(data(:,i),'amor',fs));
            features.bump = real(cwt(data(:,i),'bump',fs));
            features.morse = real(cwt(data(:,i),'morse',fs));
            end
        end
    end
    
end