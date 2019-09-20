function [perfs, ave_perfs]=train_me_feature_pairs(j1,j2, bin)

ExtensionTrainPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/extensions_step64/train_processed'];

FlexionTrainPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/flexions_step64/train_processed'];

ExtensionTestPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/extensions_step64/test_processed'];

FlexionTestPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/flexions_step64/test_processed'];

Features = {'smooth','rms','stft','haar','db8','sym4','sym8','bior13','bior22','coif3','coif4'};

processed_train_Ext1 = load([ExtensionTrainPath,'/',Features{j1},'/','train',num2str(bin),'_processed_Ext']);
processed_train_Ext2 = load([ExtensionTrainPath,'/',Features{j2},'/','train',num2str(bin),'_processed_Ext']);
processed_train_Flx1 = load([FlexionTrainPath,'/',Features{j1},'/','train',num2str(bin),'_processed_Flx']);
processed_train_Flx2 = load([FlexionTrainPath,'/',Features{j2},'/','train',num2str(bin),'_processed_Flx']);

processed_test_Ext1 = load([ExtensionTestPath,'/',Features{j1},'/','test',num2str(bin),'_processed_Ext']);
processed_test_Ext2 = load([ExtensionTestPath,'/',Features{j2},'/','test',num2str(bin),'_processed_Ext']);
processed_test_Flx1 = load([FlexionTestPath,'/',Features{j1},'/','test',num2str(bin),'_processed_Flx']);
processed_test_Flx2 = load([FlexionTestPath,'/',Features{j2},'/','test',num2str(bin),'_processed_Flx']);

% concatenating the training data in pairs
train_data = [processed_train_Ext1.finalMatrix(:,1:end-1),processed_train_Ext2.finalMatrix(:,1:end-1); 
              processed_train_Flx1.finalMatrix(:,1:end-1),processed_train_Flx2.finalMatrix(:,1:end-1)];
         
true_train_labels = [processed_train_Ext1.finalMatrix(:,end);
                     processed_train_Flx1.finalMatrix(:,end)];

%concatenating the test data in pairs
test_data = [processed_test_Ext1.finalMatrix(:,1:end-1) , processed_test_Ext2.finalMatrix(:,1:end-1);
             processed_test_Flx1.finalMatrix(:,1:end-1) , processed_test_Flx2.finalMatrix(:,1:end-1)];

true_test_labels = [processed_test_Ext1.finalMatrix(:,end);
                    processed_test_Flx1.finalMatrix(:,end)];

      
net = fitnet(5);
net.divideParam.trainRatio = 0.80;
net.divideParam.valRatio = 0.20;
net.divideParam.testRatio = 0.0;

tic
% train and validate train data
net = train(net,train_data',true_train_labels');

% test newly trained network with test data
outputs = net(test_data');

% calculate accuracy on the test data
perfs = 1 - mse(net, true_test_labels, outputs);

toc
beep on; beep;
end