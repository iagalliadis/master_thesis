classdef StftFeature < Feature
    %STFTFEATURE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        fs;
    end
    methods
        function obj = StftFeature(fs)
            obj.fs = fs;
        end
        function featureSize = init(obj,dataSize)
            data = rand(dataSize,1);
            features = real(spectrogram(data,[],[],[],obj.fs));
            featureSize = length(features(:));
        end
        function features = run(obj,data)
            res = real(spectrogram(data,[],[],[],obj.fs));
            features = res(:);
        end
        
    end
end
