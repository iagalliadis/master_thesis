classdef FeatureManager < handle
    
    properties
        features;
        featureSize;
        isRun;
    end
    
    methods
        function obj = FeatureManager()
            obj.isRun = false;
        end
        
        function addFeature(obj,featureName,featureClass)
            if isfield(obj.features,featureName)
                warning(['feature name ' featureName ' was already registered, overwriting']);
            end
            obj.features.(featureName) = featureClass;
            obj.isRun = false;
        end
        
        function output = run(obj, data, isExtension, windowLength, set)%, bin) bin is used when the data are separated into 5 folds
            output = obj.innerProcess(data,windowLength);
            output = obj.concatenateData(output,isExtension,set); %,bin);
        end
        
        function output = innerProcess(obj, data, windowLength)
            obj.isRun = true;
            featureNames = fieldnames(obj.features);
            % init step
            [featureRowsN, featureColsN] = size(data);
            for i = 1:numel(featureNames)
                featureName = featureNames{i};
                obj.featureSize.(featureName) = obj.features.(featureName).init(windowLength);
            end
            % calc step
            output = struct();
            for i = 1:numel(featureNames)
                featureName = featureNames{i};
                offset = 0;
                for jj = 1:(featureRowsN/windowLength)
                    for ii = 1:featureColsN
                        output.(featureName){jj}(:,ii) = obj.features.(featureName).run(data(1 + offset : offset + windowLength,ii));
                    end
                    offset = offset + windowLength ;
                end
                
                %             i=1;
                %             while i < numel(featureNames)
                %                 offset = 0;
                %                 if ~strcmp(featureNames{i},{'smooth','rms','stft'})
                %                     for j = i:i+2
                %                         featureName = featureNames{j};
                %                         newFeatureName = featureName(1:end-2);
                %                         offset = 0;
                %                         for jj = 1:featureRowsN/windowLength
                %                             for ii = 1:featureColsN
                %                                 output.(newFeatureName){:}(:,ii) = obj.features.(featureName).run(data(1 + offset : offset + windowLength,ii));
                %                             end
                %                             offset = offset + windowLength ;
                %                         end
                %                     end
                %                     i = i+3;
                %                 else
                %                     for jj = 1:(featureRowsN/windowLength)
                %                         for ii = 1:featureColsN
                %                             output.(featureName){jj}(:,ii) = obj.features.(featureName).run(data(1 + offset : offset + windowLength,ii));
                %                         end
                %                         offset = offset + windowLength ;
                %                     end
                %                     i = i+1;
                %                 end
                %             end
                
            end
        end
        
        function finalMatrix = concatenateData(obj, output, isExtension, set) %bin) I used bin when I had separated into 5 folders the data
            featureNames = fieldnames(obj.features);
            totalFeaturesColsN = 0;
            
            if isExtension
                labels = ones(length(output.(featureNames{1})),1);
                string1 = 'ext';
                string2 = 'Ext';
            else
                labels = zeros(length(output.(featureNames{1})),1);
                string1 = 'flx';
                string2 = 'Flx';
            end
            
            for i=1:numel(featureNames)
                featureName = featureNames{i};
                featureColsN = numel(output.(featureName){1});
                totalFeaturesColsN = totalFeaturesColsN + featureColsN;
            end
            
            %offset = 0;
            i = 1;
            while i < numel(featureNames)
                if ~strcmp(featureNames{i},{'smooth','rms','stft'})
                    featureName = featureNames{i};
                    matrix = zeros(length(output.(featureName)),obj.featureSize.(featureName)*8);
                    offset = 0;
                    %jj1 = 0;
                    for j = i:i+2
                        featureName = featureNames{j};
                        newFeatureName = featureName(1:end-2);
                        %[feat_rows,feat_cols]=size(output.(featureName){1});% dimensions of cell's matrix of the feature
                        for jj = 1:length(output.(featureName))
                            matrix(jj, 1+offset:offset + obj.featureSize.(featureName)*8) = output.(featureName){jj}(:)';
                        end
                        % jj1 = jj1 + jj;
                        offset = offset + obj.featureSize.(featureName)*8;
                    end
                    finalMatrix = [matrix , labels];%concatenate labels in last column
                    %save(['C:\Temp\MATLAB\masterthesis-data\thumb_flex_extend\processed_data\' string1 '_step64\' set '_processed\' newFeatureName '\' set num2str(bin) '_processed_' string2 '.mat'],'finalMatrix','-v7.3');
                    save(['C:\Temp\MATLAB\masterthesis-data\Final_Database\processed\G14\' string1 '_step64\' set '\' newFeatureName '\' set '_processed_' string2 '.mat'],'finalMatrix','-v7.3');
                    i = i+3;
                    %                 else
                    %                 featureName = featureNames{i};
                    %                 [feat_rows,feat_cols]=size(output.(featureName){1});% dimensions of cell's matrix of the feature
                    %                 matrix = zeros(length(output.(featureName)),feat_rows*feat_cols);
                    %                 %   for i = 1:numel(featureNames)
                    %                 for jj = 1:length(output.(featureName))
                    %                     matrix(jj,1:feat_rows*feat_cols) = output.(featureName){jj}(:)';
                    %                 end
                    %                 % end
                    %                 %offset = offset + obj.featureSize.(featureName)*8;
                    %                 finalMatrix = [matrix , labels];%concatenate labels in last column
                    %                 %save(['C:\Temp\MATLAB\masterthesis-data\thumb_flex_extend\processed_data\' string1 '_step64\' set '_processed\' featureName '\' set num2str(bin) '_processed_' string2 '.mat'],'finalMatrix','-v7.3');
                    %                 i = i+1;
                    %             end
                end
                
            end
        end
    end
end