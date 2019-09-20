function [perfs] = train_ANN_triplet_rms_sym8()

ExtensionTrainPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/extensions_step64/train_processed'];

FlexionTrainPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/flexions_step64/train_processed'];

ExtensionTestPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/extensions_step64/test_processed'];

FlexionTestPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/flexions_step64/test_processed'];

Features = {'smooth','stft','haar','db8','sym4','bior13','bior22','coif3','coif4'};

% loading all the .mat files for rms and sym8 as they gave the best
% accuracies
for bin = 1:5
    train_Ext_rms(:,:,bin) = load([ExtensionTrainPath,'/','rms','/','train',num2str(bin),'_processed_Ext']);
    train_Flx_rms(:,:,bin) = load([FlexionTrainPath,'/','rms','/','train',num2str(bin),'_processed_Flx']);
    train_Ext_sym8(:,:,bin) = load([ExtensionTrainPath,'/','sym8','/','train',num2str(bin),'_processed_Ext']);
    train_Flx_sym8(:,:,bin) = load([FlexionTrainPath,'/','sym8','/','train',num2str(bin),'_processed_Flx']);
    
    test_Ext_rms(:,:,bin) = load([ExtensionTestPath,'/','rms','/','test',num2str(bin),'_processed_Ext']);
    test_Flx_rms(:,:,bin) = load([FlexionTestPath,'/','rms','/','test',num2str(bin),'_processed_Flx']);
    test_Ext_sym8(:,:,bin) = load([ExtensionTestPath,'/','sym8','/','test',num2str(bin),'_processed_Ext']);
    test_Flx_sym8(:,:,bin) = load([FlexionTestPath,'/','sym8','/','test',num2str(bin),'_processed_Flx']);
    
    
end

perfs = zeros(5,9);
for feature = 1:9
    for bin = 1:5
        
        %concatenating rms&sym8 train data from the i-th bin
        train_data_rms_sym8 = [train_Ext_rms(:,:,bin).finalMatrix(:,1:end-1), train_Ext_sym8(:,:,bin).finalMatrix(:,1:end-1);
            train_Flx_rms(:,:,bin).finalMatrix(:,1:end-1), train_Flx_sym8(:,:,bin).finalMatrix(:,1:end-1)];
        
        %concatenating the train labels for the train data
        true_train_labels = [train_Ext_rms(:,:,bin).finalMatrix(:,end);
            train_Flx_rms(:,:,bin).finalMatrix(:,end)];
        
        %concatenating rms&sym8 test data from the i-th bin
        test_data_rms_sym8 = [test_Ext_rms(:,:,bin).finalMatrix(:,1:end-1), test_Ext_sym8(:,:,bin).finalMatrix(:,1:end-1);
            test_Flx_rms(:,:,bin).finalMatrix(:,1:end-1), test_Flx_sym8(:,:,bin).finalMatrix(:,1:end-1)];
        
        %concatenating the test labels for the train data
        true_test_labels = [test_Ext_rms(:,:,bin).finalMatrix(:,end);
            test_Flx_rms(:,:,bin).finalMatrix(:,end)];
        
        
        %loading the .mat train files for ext&flx for the third feature to be
        %concatenated
        processed_train_Ext1 = load([ExtensionTrainPath,'/',Features{feature},'/','train',num2str(bin),'_processed_Ext']);
        processed_train_Flx1 = load([FlexionTrainPath,'/',Features{feature},'/','train',num2str(bin),'_processed_Flx']);
        
        %concatenating the train data for ext&flx of the i-th feature from bin
        processed_train = [processed_train_Ext1.finalMatrix(:,1:end-1);processed_train_Flx1.finalMatrix(:,1:end-1)];
        
        %concatenating the rms_sym8 train data with the i-th feature from bin train
        %data
        train_data = [train_data_rms_sym8, processed_train];
        
        
        
        %loading the .mat test files for ext&flx for the third feature to be
        %concatenated
        processed_test_Ext1 = load([ExtensionTestPath,'/',Features{feature},'/','test',num2str(bin),'_processed_Ext']);
        processed_test_Flx1 = load([FlexionTestPath,'/',Features{feature},'/','test',num2str(bin),'_processed_Flx']);
        
        %concatenating the test data of the i-th feature from bin
        processed_test = [processed_test_Ext1.finalMatrix(:,1:end-1);processed_test_Flx1.finalMatrix(:,1:end-1)];
        
        %concatenating the rms_sym8 test data with the i-th feature from bin test
        %data
        test_data = [test_data_rms_sym8, processed_test];
        
        
        
        net = fitnet(5);
        net.divideParam.trainRatio = 0.80;
        net.divideParam.valRatio = 0.20;
        net.divideParam.testRatio = 0.0;
        
        tic
        % train and validate train data
        net = train(net,train_data',true_train_labels');
        
        % test newly trained network with test data
        outputs = net(test_data');
        toc
        
        % calculate accuracy on the test data
        perfs(bin,feature) = 1 - mse(net, true_test_labels, outputs);
    end
end

ave_perfs = mean(reshape(perfs, 5, []));
save('/home/iagalliadis/ma_ioannis_agalliadis/thesis/figures/HL1_NN5_accuracy/step64/all_feature_comb/concatenated_by_3/rms_sym8/perfs_step64.mat','perfs');
save('/home/iagalliadis/ma_ioannis_agalliadis/thesis/figures/HL1_NN5_accuracy/step64/all_feature_comb/concatenated_by_3/rms_sym8/ave_perfs_step64.mat','ave_perfs');

end