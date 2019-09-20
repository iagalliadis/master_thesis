function [perfs, ave_perfs]=train_me_ANN(j,bin)

%[FileName1, Path1, FilterIndex] = uigetfile('/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/processed_data/extensions');
%[FileName2, Path2, FilterIndex] = uigetfile('/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/processed_data/flexions');
%processed_Ext = cell2mat((struct2cell(load([Path1 FileName1]))));
ExtensionTrainPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/extensions_step64/train_processed'];

FlexionTrainPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/flexions_step64/train_processed'];

ExtensionTestPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/extensions_step64/test_processed'];

FlexionTestPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/flexions_step64/test_processed'];

%ExtensionEvaluationPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
%'processed_data/extensions/evaluation_processed'];

%FlexionEvaluationPath = ['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
%'processed_data/flexions/evaluation_processed'];

% processed_train_Ext = {};
% processed_train_Flx = {};
% processed_test_Ext = {};
% processed_test_Flx = {};

Features = {'smooth','rms','stft','haar','db8','sym4','sym8','bior13','bior22','coif3','coif4'};

%NET = cell(5,11);
%TR = cell(5,11);

%perfs = zeros(5,11);

profile on;
%for j = 2
%for bin = 1:5
processed_train_Ext = load([ExtensionTrainPath,'/',Features{j},'/','train',num2str(bin),'_processed_Ext']);
processed_train_Flx = load([FlexionTrainPath,'/',Features{j},'/','train',num2str(bin),'_processed_Flx']);
processed_test_Ext = load([ExtensionTestPath,'/',Features{j},'/','test',num2str(bin),'_processed_Ext']);
processed_test_Flx = load([FlexionTestPath,'/',Features{j},'/','test',num2str(bin),'_processed_Flx']);
%processed_evaluation_Ext = load([ExtensionEvaluationPath,'/',Features{j},'/','evaluation','_processed_Ext']);
%processed_evaluation_Flx = load([FlexionEvaluationPath,'/',Features{j},'/','evaluation','_processed_Flx']);

% concatenating the training data
train_data = [processed_train_Ext.finalMatrix(:,1:end-1); processed_train_Flx.finalMatrix(:,1:end-1)];
true_train_labels = [processed_train_Ext.finalMatrix(:,end); processed_train_Flx.finalMatrix(:,end)];
%row_size_train = length(train_data);

%concatenating the evaluation data
%evaluation_data = [processed_evaluation_Ext.finalMatrix(:,1:end-1) ; processed_evaluation_Flx.finalMatrix(:,1:end-1)];
%true_evaluation_labels = [processed_evaluation_Ext.finalMatrix(:,end); processed_evaluation_Flx.finalMatrix(:,end)];
%row_size_evaluation = length(evaluation_data);

%concatenating the test data
test_data = [processed_test_Ext.finalMatrix(:,1:end-1) ; processed_test_Flx.finalMatrix(:,1:end-1)];
true_test_labels = [processed_test_Ext.finalMatrix(:,end); processed_test_Flx.finalMatrix(:,end)];
%row_size_test = length(test_data);

tic
%take total row size from train, test, evaluation
%total_row_size_data = row_size_train + row_size_evaluation + row_size_test;

%fit network
net = fitnet(5);
net.divideParam.trainRatio = 0.80;
net.divideParam.valRatio = 0.20;
net.divideParam.testRatio = 0.0;
%view(net)

%         net.divideFcn = 'divideind';
%         %defining the limits between the different sets
%         [net.divideParam.trainInd,net.divideParam.testInd,net.divideParam.valInd] = divideind(total_row_size_data, 1:row_size_train,...
%             row_size_train + 1:row_size_train + row_size_test,...
%             row_size_train + row_size_test+1:row_size_train  + row_size_test + row_size_evaluation );

%concatenate train,evaluation,test data and their labels
%         total_data = [train_data;test_data;evaluation_data];
%         total_true_labels = [true_train_labels;true_test_labels;true_evaluation_labels];

tic
% train and validate train data
%[net, tr] = train(net,train_data',true_train_labels');
net = train(net,train_data',true_train_labels');
%NET{bin,j} = net;
%TR{bin,j} = tr;

% test newly trained network with test data
%outputs = NET{bin,j}(test_data');
outputs = net(test_data');

% calculate accuracy on the test data
%perfs(bin,j) = 1 - mse(net, true_test_labels, outputs);
perfs = 1 - mse(net, true_test_labels, outputs);
%ave_perfs = mean(perfs,1);
%         % outputs for train, test, evaluation data
%         trOut = outputs(tr.trainInd);
%         tsOut = outputs(tr.testInd);
%         evalOut = outputs(tr.valInd);
%
%         % targets for train, test, evaluation
%         trTarg = total_true_labels(tr.trainInd);
%         tsTarg = total_true_labels(tr.testInd);
%         evalTarg = total_true_labels(tr.valInd);
%
%         [c,cm,ind,per] = confusion(total_true_labels',outputs);

%TPR = cm(1,1)/sum(cm(:,1));
%TNR = cm(2,2)/sum(cm(:,2));
%FNR = cm(1,2)/sum(cm(:,2));
%FPR = cm(2,1)/sum(cm(:,1));

%plotconfusion(total_true_labels',outputs)

%fpath = '/home/iagalliadis/ma_ioannis_agalliadis/thesis/figures/confusion_matrix';
%saveas(gca, fullfile(fpath, [Features{j} '_' num2str(bin)]), 'png');

toc
beep on; beep;
%disp(Features{j})
%end
%end

end
