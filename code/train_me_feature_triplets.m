function [perfs] = train_me_feature_triplets(feature, bin)

ExtensionTrainPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/extensions_step64/train_processed'];

FlexionTrainPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/flexions_step64/train_processed'];

ExtensionTestPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/extensions_step64/test_processed'];

FlexionTestPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/flexions_step64/test_processed'];

Features = {'smooth','rms','stft','haar','db8','bior13','bior22','coif3','coif4'};

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