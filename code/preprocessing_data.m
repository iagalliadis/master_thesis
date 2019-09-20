function FtrVct = preprocessing_data(data) % data = Out.Ext or Out.Flex or anything else in the same structure
%% main stuff
tic

%% this is how it should look like in the end:
% mgr = FeatureManager();
% mgr.addFeature('stft',SpectrogramFeature());
% mgr.addFeature('rms',RMSFeature());
% mgr.addFeature('something-3',SomethingFeature(3));
% ...
% for sample in Samples % this is just pseudo code
%     features{sample} = mgr.run(oneSampleVector});
% end
% return should be one struct with features.stft = output of
% SpectoramFeature().run(), features.rms = output of RMSFeature().run()
%

dim = numel(data);

%% STFT for EMG extension
fs = 200;
Stft     = zeros(dim,8,(size(data{1},1)+1)*8);
parfor j=1:dim
    for i=1:8
        tmp = spectrogram(data{j}(:,i),[],[],[],fs);
        Stft(j,i,:) = tmp(:);
    end
end
FtrVct.Stft = Stft;%% Root mean square
Rms      = zeros(dim,8);
for j=1:dim
    for i=1:8
        Rms(j,i) = rms(data{j}(:,i));
    end
end
FtrVct.Rms      = Rms;
%% Moving average
Smoothed = zeros(dim,8,size(data{1},1));
for j=1:dim
    for i=1:8
        Smoothed(j,i,:) = smooth(data{j}(:,i));
    end
end
FtrVct.Smoothed = Smoothed;
%% Perform (wavedec) using various wavelets.
Haar     = zeros(dim,8,3);
Sym4     = zeros(dim,8,3);
Sym8     = zeros(dim,8,3);
Db8      = zeros(dim,8,3);
Bior13   = zeros(dim,8,3);
Bior22   = zeros(dim,8,3);
Coif3    = zeros(dim,8,3);
Coif4    = zeros(dim,8,3);

for j= 1:dim
    for i=1:8
        for lvl = 3:5
            Haar{j, i, lvl - 2} = wavedec(data{j}(:,i), lvl, 'haar');
            Db8{j, i, lvl - 2} = wavedec(data{j}(:,i),lvl,'db8');
            Sym4{j, i, lvl - 2} = wavedec(data{j}(:,i),lvl,'sym4');
            Sym8{j, i, lvl - 2} = wavedec(data{j}(:,i),lvl,'sym8');
            Bior13{j, i, lvl - 2} = wavedec(data{j}(:,i),lvl,'bior1.3');
            Bior22{j, i, lvl - 2} = wavedec(data{j}(:,i),lvl,'bior2.2');
            Coif3{j, i, lvl - 2} = wavedec(data{j}(:,i),lvl,'coif3');
            Coif4{j, i, lvl - 2} = wavedec(data{j}(:,i),lvl,'coif4');
        end
    end
end
FtrVct.Haar     = Haar;
FtrVct.Sym4     = Sym4;
FtrVct.Sym8     = Sym8;
FtrVct.Db8      = Db8;
FtrVct.Bior13   = Bior13;
FtrVct.Bior22   = Bior22;
FtrVct.Coif3    = Coif3;
FtrVct.Coif4    = Coif4;


Amor     = zeros(dim,8);
Bump     = zeros(dim,8);
Morse    = zeros(dim,8);

parfor j= 1:dim
    for i=1:8
        Amor{j,i} = real(cwt(data{j}(:,i),'amor',fs)');
        Bump{j,i} = real(cwt(data{j}(:,i),'bump',fs)');
        Morse{j,i} = real(cwt(data{j}(:,i),'morse',fs)');
    end
end
FtrVct.Amor     = Amor;
FtrVct.Bump     = Bump;
FtrVct.Morse    = Morse;

end