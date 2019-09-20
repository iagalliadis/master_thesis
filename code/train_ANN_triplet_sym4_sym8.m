function [perfs] = train_ANN_triplet_sym4_sym8()

folder_names = {'G1','G2','G3','G4','G5','G6','G7','G8','G9','G10','G11','G12','G13','G14',};

for gesture = 1:numel(folder_names)
    
    folder_name = folder_names{gesture};
    
    ExtensionTrainPath = ['/media/tesladata/mediweco/iagalliadis-data/Final_Database/processed/',folder_name,...
        '/ext_step64/train'];
    
    FlexionTrainPath = ['/media/tesladata/mediweco/iagalliadis-data/Final_Database/processed/',folder_name,...
        '/flx_step64/train'];
    
    ExtensionTestPath = ['/media/tesladata/mediweco/iagalliadis-data/Final_Database/processed/',folder_name,...
        '/ext_step64/test'];
    
    FlexionTestPath = ['/media/tesladata/mediweco/iagalliadis-data/Final_Database/processed/',folder_name,...
        '/flx_step64/test'];
    
    Features = {'db8','bior22','coif3'};
    
    %Features = {'smooth','rms','stft','haar','db8','bior13','bior22','coif3','coif4'};
    
    % loading all the .mat files for sym4 and sym8 as they gave the best
    % accuracies
    
    train_Ext_sym4(:,:) = load([ExtensionTrainPath,'/','sym4','/','train','_processed_Ext']);
    train_Flx_sym4(:,:) = load([FlexionTrainPath,'/','sym4','/','train','_processed_Flx']);
    train_Ext_sym8(:,:) = load([ExtensionTrainPath,'/','sym8','/','train','_processed_Ext']);
    train_Flx_sym8(:,:) = load([FlexionTrainPath,'/','sym8','/','train','_processed_Flx']);
    
    test_Ext_sym4(:,:) = load([ExtensionTestPath,'/','sym4','/','test','_processed_Ext']);
    test_Flx_sym4(:,:) = load([FlexionTestPath,'/','sym4','/','test','_processed_Flx']);
    test_Ext_sym8(:,:) = load([ExtensionTestPath,'/','sym8','/','test','_processed_Ext']);
    test_Flx_sym8(:,:) = load([FlexionTestPath,'/','sym8','/','test','_processed_Flx']);
    
    % for bin = 1:5
    %     train_Ext_sym4(:,:,bin) = load([ExtensionTrainPath,'/','sym4','/','train',num2str(bin),'_processed_Ext']);
    %     train_Flx_sym4(:,:,bin) = load([FlexionTrainPath,'/','sym4','/','train',num2str(bin),'_processed_Flx']);
    %     train_Ext_sym8(:,:,bin) = load([ExtensionTrainPath,'/','sym8','/','train',num2str(bin),'_processed_Ext']);
    %     train_Flx_sym8(:,:,bin) = load([FlexionTrainPath,'/','sym8','/','train',num2str(bin),'_processed_Flx']);
    %
    %     test_Ext_sym4(:,:,bin) = load([ExtensionTestPath,'/','sym4','/','test',num2str(bin),'_processed_Ext']);
    %     test_Flx_sym4(:,:,bin) = load([FlexionTestPath,'/','sym4','/','test',num2str(bin),'_processed_Flx']);
    %     test_Ext_sym8(:,:,bin) = load([ExtensionTestPath,'/','sym8','/','test',num2str(bin),'_processed_Ext']);
    %     test_Flx_sym8(:,:,bin) = load([FlexionTestPath,'/','sym8','/','test',num2str(bin),'_processed_Flx']);
    %
    %
    % end
    
    %perfs = zeros(5,9,5); from 1 to 5 layers
    perfs = zeros(14,3); % for 1 layer only!
    for feature = 1:3
        %for bin = 1:5
        layer = 1; % FOR EIGHT LAYERS!
        %M = [];
        %for layer = 1:5
        %concatenating sym4&sym8 train data from the i-th bin
        % train_data_sym4_sym8 = [train_Ext_sym4(:,:,bin).finalMatrix(:,1:end-1), train_Ext_sym8(:,:,bin).finalMatrix(:,1:end-1);
        %    train_Flx_sym4(:,:,bin).finalMatrix(:,1:end-1), train_Flx_sym8(:,:,bin).finalMatrix(:,1:end-1)];
        
        train_data_sym4_sym8 = [train_Ext_sym4(:,:).finalMatrix(:,1:end-1), train_Ext_sym8(:,:).finalMatrix(:,1:end-1);
            train_Flx_sym4(:,:).finalMatrix(:,1:end-1), train_Flx_sym8(:,:).finalMatrix(:,1:end-1)];
        
        %concatenating the train labels for the train data
        %             true_train_labels = [train_Ext_sym4(:,:,bin).finalMatrix(:,end);
        %                 train_Flx_sym4(:,:,bin).finalMatrix(:,end)];
        true_train_labels = [train_Ext_sym4(:,:).finalMatrix(:,end);
            train_Flx_sym4(:,:).finalMatrix(:,end)];
        
        %concatenating sym4&sym8 test data from the i-th bin
        %             test_data_sym4_sym8 = [test_Ext_sym4(:,:,bin).finalMatrix(:,1:end-1), test_Ext_sym8(:,:,bin).finalMatrix(:,1:end-1);
        %                 test_Flx_sym4(:,:,bin).finalMatrix(:,1:end-1), test_Flx_sym8(:,:,bin).finalMatrix(:,1:end-1)];
        
        test_data_sym4_sym8 = [test_Ext_sym4(:,:).finalMatrix(:,1:end-1), test_Ext_sym8(:,:).finalMatrix(:,1:end-1);
            test_Flx_sym4(:,:).finalMatrix(:,1:end-1), test_Flx_sym8(:,:).finalMatrix(:,1:end-1)];
        
        %concatenating the test labels for the train data
        %             true_test_labels = [test_Ext_sym4(:,:,bin).finalMatrix(:,end);
        %                 test_Flx_sym4(:,:,bin).finalMatrix(:,end)];
        true_test_labels = [test_Ext_sym4(:,:).finalMatrix(:,end);
            test_Flx_sym4(:,:).finalMatrix(:,end)];
        
        
        %loading the .mat train files for ext&flx for the third feature to be
        %concatenated
        %             processed_train_Ext1 = load([ExtensionTrainPath,'/',Features{feature},'/','train',num2str(bin),'_processed_Ext']);
        %             processed_train_Flx1 = load([FlexionTrainPath,'/',Features{feature},'/','train',num2str(bin),'_processed_Flx']);
        
        processed_train_Ext1 = load([ExtensionTrainPath,'/',Features{feature},'/','train','_processed_Ext']);
        processed_train_Flx1 = load([FlexionTrainPath,'/',Features{feature},'/','train','_processed_Flx']);
        
        %concatenating the train data for ext&flx of the i-th feature
        processed_train = [processed_train_Ext1.finalMatrix(:,1:end-1);processed_train_Flx1.finalMatrix(:,1:end-1)];
        
        %concatenating the sym4_sym8 train data with the i-th feature
        train_data = [train_data_sym4_sym8, processed_train];
        
        
        
        %loading the .mat test files for ext&flx for the third feature to be
        %concatenated
        %             processed_test_Ext1 = load([ExtensionTestPath,'/',Features{feature},'/','test',num2str(bin),'_processed_Ext']);
        %             processed_test_Flx1 = load([FlexionTestPath,'/',Features{feature},'/','test',num2str(bin),'_processed_Flx']);
        
        
        processed_test_Ext1 = load([ExtensionTestPath,'/',Features{feature},'/','test','_processed_Ext']);
        processed_test_Flx1 = load([FlexionTestPath,'/',Features{feature},'/','test','_processed_Flx']);
        
        %concatenating the test data of the i-th feature from bin
        processed_test = [processed_test_Ext1.finalMatrix(:,1:end-1);processed_test_Flx1.finalMatrix(:,1:end-1)];
        
        %concatenating the sym4_sym8 test data with the i-th feature from bin test
        %data
        test_data = [test_data_sym4_sym8, processed_test];
        
        %change the number of hidden layers from 1 to 5 and each layer has
        %5 hidden neurons
        M(1,1:layer) = 5; % if running for more than one layer, uncomment line 38
        net = fitnet(M);
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
        %perfs(bin,feature,layer) = 1 - mse(net, true_test_labels,
        %outputs); %from 1 to 5 layers
        
        %            perfs(bin,feature) = 1 - mse(net, true_test_labels, outputs);
        perfs(gesture,feature) = 1 - mse(net, true_test_labels, outputs);
        %end
        %    end
    end
    
    %ave_perfs = mean(reshape(perfs, 5, []));
    %save('/home/iagalliadis/ma_ioannis_agalliadis/thesis/figures/HL1:5_NN5/concatenated_by_3/sym4sym8_13Layers/perfs_step64.mat','perfs');
    %save('/home/iagalliadis/ma_ioannis_agalliadis/thesis/figures/HL1:5_NN5/concatenated_by_3/sym4sym8_13Layers/ave_perfs_step64.mat','ave_perfs');
end
save(['/home/iagalliadis/ma_ioannis_agalliadis/thesis/figures/FINAL_HL8_NN5_accuracy/concatenated_by_3/sym4sym8/',folder_name,'perfs_step64.mat'],'perfs');
end