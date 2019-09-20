function doit()

%% load raw data from CSVs
% output should be:
% cell vector/array length of 8 (one per channel)
% within each cell one cell vector of length number of windows

%fs = 200; <- parameter used in stft
windowLength = 128;
%sets = {'train','test','evaluation'};<- evaluation folder
sets = {'train','test'};
mgr = FeatureManager();
%Features = {'smooth','rms','stft','haar','db8','sym4','sym8','bior1.3','bior2.2','coif3','coif4'};
Features = {'db8','sym4','sym8','bior2.2','coif3'};
for feature = 1:numel(Features)
    %feature manager config
    %    indices = strcmp(Features{feature},{'smooth','rms','stft'});
    %    index = find(indices);
    %     if index == 1
    %         mgr.addFeature(Features{feature}, SmoothFeature());
    %     elseif index == 2
    %         mgr.addFeature(Features{feature}, RMSFeature());
    %     elseif index == 3
    %         mgr.addFeature(Features{feature}, StftFeature(fs));
    %     else
    %Dwt features for level=3:5
    for lvl = 3 : 5
        mgr.addFeature([strrep(Features{feature},'.',''),'_',num2str(lvl)], DwtFeature(lvl,Features{feature}));
    end
    %end
end

for i = 1:numel(sets)
          set = sets{i};
    %     if ~strcmp(set1,'evaluation')
    %     for bin = 1:5
    %         % load raw data from CSVs
    %         [Ext, Flx] = load_data(bin,set1, windowLength); %% 'train' for train data, 'test' for test data, 'evaluation' for evaluation data
    %         % run feature manager
    %         % output will be 8 cells with each one matrix, size nWindows x nFeatures
    %         mgr.run(Ext,true,windowLength,set1,bin);% true if Extension_data, false otherwise
    %         mgr.run(Flx,false,windowLength,set1,bin);
    %         beep on;beep;
    %         %desc = mgr.describeData();
    %     end
    %    else % for evaluation data there is one set only not 5 like in train and test sets
    % load raw data from CSVs
    %[Ext, Flx] = load_data(1,set, windowLength); %% 'train' for train data, 'test' for test data, 'evaluation' for evaluation data
    [Ext, Flx] = load_data(set, windowLength);%without the number of bin as a parameter
    % run feature manager
    % output will be 8 cells with each one matrix, size nWindows x nFeatures
    mgr.run(Ext,true,windowLength,set);%,1)<-number of bin omitted % true if Extension_data, if Flexion_data false
    mgr.run(Flx,false,windowLength,set);%,1)<-number of bin omitted
    beep on;beep;
end
end