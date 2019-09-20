function scores = train_me()

%num_rows = 27000;
%[FileName1, Path1, FilterIndex] = uigetfile('/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/processed_data/extensions');
%[FileName2, Path2, FilterIndex] = uigetfile('/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/processed_data/flexions');
%processed_Ext = cell2mat((struct2cell(load([Path1 FileName1]))));
evaluation_set_Ext = cell2mat(struct2cell...
    (load(['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/extensions/evaluation_processed/rms/evaluation_processed_Ext'])));
evaluation_set_Flx = cell2mat(struct2cell...
    (load(['/media/tesladata/mediweco/iagalliadis-data/thumb_flex_extend/'...
    'processed_data/flexions/evaluation_processed/rms/evaluation_processed_Flx'])));
processed_Ext = {};
processed_Flx = {};
for i = 1
    processed_Ext{i} = cell2mat((struct2cell(load(['/media/tesladata/mediweco/'...
        'iagalliadis-data/thumb_flex_extend/processed_data/extensions/'...
        'train_processed/rms/train',num2str(i),'_processed_Ext']))));
    %processed_Flx = cell2mat((struct2cell(load([Path2  FileName2]))));
    processed_Flx{i}= cell2mat((struct2cell(load(['/media/tesladata/mediweco/'...
        'iagalliadis-data/thumb_flex_extend/processed_data/flexions/'...
        'train_processed/rms/train',num2str(i),'_processed_Flx']))));
    %processed = [processed_Ext(1:num_rows,:);processed_Flx(1:num_rows,:)];
    %%taking the first 1000 lines of processed rms feature
    X1 = [processed_Ext{i}(:,1:end-1); processed_Flx{i}(:,1:end-1)];
    Y1 = [processed_Ext{i}(:,end); processed_Flx{i}(:,end)];
    tic
    RMS_Linear{i} = fitcsvm(X1, Y1,'KernelFunction','linear','Standardize',...
        true,'ClassNames',{'1','0'});
    toc
end

tic
evaluation = [evaluation_set_Ext(:,1:end-1) ; evaluation_set_Flx(:,1:end-1)];
[~, scores, ~] = predict(RMS_Linear{1}, evaluation);
toc
beep on; beep;

end