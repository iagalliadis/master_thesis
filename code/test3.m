%% Import data for extensions and flexions of the thumb

for i=1:230
   Ext{i} = csvread(strcat('C:\Temp\MATLAB\repos\code\thumb_flex_extend\cutted\extensions\extension_',num2str(i),'.csv'));
end

for i=1:207
   Flx{i} = csvread(strcat('C:\Temp\MATLAB\repos\code\thumb_flex_extend\cutted\flexions\flexion_',num2str(i),'.csv'));
end

%% plot the first EMG Ext signal of the cell 

lineStyles = {'-', '--', ':', '-.'};
myColors = distinguishable_colors(8);
legend_str = cell(8,1);
figure

for i=2:9
plot(linspace(0,1,length(Ext{1}(:,1))),Ext{1}(:,i),...
    'linestyle',lineStyles{rem(i-1,numel(lineStyles))+1},...
    'color',myColors(i-1,:),...
    'linewidth',1.5);
hold on;
legend_str{i-1}=num2str(i-1);
end
legend(strcat('ch',legend_str),'location','Northwest')
title('EMG signal for thumb extension')

% plot the first EMG Flx signal of the cell 
figure

for i=2:9
plot(linspace(0,1,length(Flx{1}(:,1))),Flx{1}(:,i),...
    'linestyle',lineStyles{rem(i-1,numel(lineStyles))+1},...
    'color',myColors(i-1,:),...
    'linewidth',1.5);
hold on;
legend_str{i-1}=num2str(i-1);
end
legend(strcat('ch',legend_str),'location','Northwest')
title('EMG signal for thumb flexion')

%% STFT for EMG extension signal
stft_ext = cell(230,8);

for j=1:230
    for i=1:8
        stft_ext{j,i} = num2cell(spectrogram(Ext{j}(:,i+1)));
    end
end

%plot the STFT for extension
figure
xbounds = xlim();
spectrogram(Ext{1}(:,8));
set(gca, 'xtick', 0:0.01:1);
xtickangle(50);
title('STFT for the 7th channel of extension');


% STFT for EMG flexion signal
stft_flx = cell(207,8);

for j=1:207
    for i=1:8
        stft_flx{j,i} = num2cell(spectrogram(Flx{j}(:,i+1)));
    end
end

%plot the STFT for flexion
figure
spectrogram(Flx{1}(:,8));
set(gca, 'xtick', 0:0.01:1);
xtickangle(50);
title('STFT for the 7th channel of flexion');

%% Low-pass band filter for extension
% fc=0.04; %cutoff frequency
% fs=200; %sample frequency from Myo
% fn = fs/2; %Nyquist frequency is half of the sample frequency
% [b,a]= butter(6,(fc/fn),'low');% six order low pass filter
% 
% for j=1:230
%     for i=1:8
%         low_pass_data_ext{j}(:,i) = filter(b,a,Ext{j}(:,i+1));
%     end
% end
% 
% 
% for j=1:207
%     for i=1:8
%         low_pass_data_flx{j}(:,i) = filter(b,a,Flx{j}(:,i+1));
%     end
% end
% 
%% Highpass band filter for extension
% fc=0.04; %cutoff frequency
% fs=200; %sample frequency from Myo
% fn = fs/2; %Nyquist frequency is half of the sample frequency
% [z,p] = butter(6,(fc/fn),'high'); %six order high pass filter
% 
% for j=1:230
%     for i=1:8
%         high_pass_data_ext{j}(:,i) = filter(z,p,Ext{j}(:,i+1));
%     end
% end
% 
% % Highpass band filter
% 
% for j=1:207
%     for i=1:8
%         high_pass_data_flx{j}(:,i) = filter(z,p,Flx{j}(:,i+1));
%     end
% end

%% Root mean square
rms_ext = zeros(230,8);
for j=1:230
    for i=1:8
        rms_ext(j,i) = rms(Ext{j}(:,i+1));
    end
end

rms_flx = zeros(230,8);
for j=1:207
    for i=1:8
        rms_flx(j,i) = rms(Flx{j}(:,i+1));
    end
end

%% Moving average

smoothed_ext = cell(230,8);
for j=1:230
    for i=1:8
        smoothed_ext{j}(:,i) = smooth(Ext{j}(:,i+1));
    end
end

% Plot EMG and smoothed EMG extension
figure
subplot(2,1,1)
plot(Ext{1}(:,1),Ext{1}(:,8))
title('Raw EMG extension')

subplot(2,1,2)
plot(Ext{1}(:,1),smoothed_ext{1}(:,8))
title('Smoothed EMG extension')

smoothed_flx = cell(207,8);

for j=1:207
    for i=1:8
        smoothed_flx{j}(:,i) = smooth(Flx{j}(:,i+1));
    end
end

% Plot EMG and smoothed EMG flexion
figure
subplot(2,1,1)
plot(Flx{1}(:,1),Flx{1}(:,8))
title('Raw EMG flexion')

subplot(2,1,2)
plot(Flx{1}(:,1),smoothed_flx{1}(:,8))
title('Smoothed EMG flexion')

%% Perform (wavedec) using various wavelets.

Haar_ext = cell(230, 8, 3); Bior13_ext = cell(230, 8, 3);
Db8_ext = cell(230, 8, 3); Bior22_ext = cell(230, 8, 3);
Sym4_ext = cell(230, 8, 3); Coif3_ext = cell(230, 8, 3);
Sym8_ext = cell(230, 8, 3); Coif4_ext = cell(230, 8, 3);
tic
for j= 1:230
    for i=1:8
        for lvl = 3:5
            Haar_ext{j, i, lvl - 2} = wavedec(Ext{j}(:,i+1), lvl, 'haar');
            Db8_ext{j, i, lvl - 2} = wavedec(Ext{j}(:,i+1),lvl,'db8');
            Sym4_ext{j, i, lvl - 2} = wavedec(Ext{j}(:,i+1),lvl,'sym4');
            Sym8_ext{j, i, lvl - 2} = wavedec(Ext{j}(:,i+1),lvl,'sym8');
            Bior13_ext{j, i, lvl - 2} = wavedec(Ext{j}(:,i+1),lvl,'bior1.3');
            Bior22_ext{j, i, lvl - 2} = wavedec(Ext{j}(:,i+1),lvl,'bior2.2');
            Coif3_ext{j, i, lvl - 2} = wavedec(Ext{j}(:,i+1),lvl,'coif3');
            Coif4_ext{j, i, lvl - 2} = wavedec(Ext{j}(:,i+1),lvl,'coif4');
        end
    end
end

Haar_flx = cell(230, 8, 3); Bior13_flx = cell(230, 8, 3);
Db8_flx = cell(230, 8, 3); Bior22_flx = cell(230, 8, 3);
Sym4_flx = cell(230, 8, 3); Coif3_flx = cell(230, 8, 3);
Sym8_flx = cell(230, 8, 3); Coif4_flx = cell(230, 8, 3);

for j= 1:207
    for i=1:8
        for lvl = 3:5
            Haar_flx{j, i, lvl - 2} = wavedec(Flx{j}(:,i+1), lvl, 'haar');
            Db8_flx{j, i, lvl - 2} = wavedec(Flx{j}(:,i+1),lvl,'db8');
            Sym4_flx{j, i, lvl - 2} = wavedec(Flx{j}(:,i+1),lvl,'sym4');
            Sym8_flx{j, i, lvl - 2} = wavedec(Flx{j}(:,i+1),lvl,'sym8');
            Bior13_flx{j, i, lvl - 2} = wavedec(Flx{j}(:,i+1),lvl,'bior1.3');
            Bior22_flx{j, i, lvl - 2} = wavedec(Flx{j}(:,i+1),lvl,'bior2.2');
            Coif3_flx{j, i, lvl - 2} = wavedec(Flx{j}(:,i+1),lvl,'coif3');
            Coif4_flx{j, i, lvl - 2} = wavedec(Flx{j}(:,i+1),lvl,'coif4');
        end
    end
end
toc
%% Perform CWT using various wavelets
Fs = 200;
t = linspace(-1,1,512);
s = 1-abs(t);

for j= 1:230
    for i=1:8
%         amor_decomp_ext{j,i} = real(cwt(Ext{j}(:,i+1),'amor',Fs)');
%         bump_decomp_ext{j,i} = real(cwt(Ext{j}(:,i+1),'bump',Fs)');
%         morse_decomp_ext{j,i} = real(cwt(Ext{j}(:,i+1),'morse',Fs)');
        haar_cwt_decomp_ext{j,i} = cwt(s,Ext{j}(:,i+1),'haar',200)';
    end
end
c = cwt(s,Ext{1}(:,9),'haar','3Dplot',200);

for j= 1:207
    for i=1:8
%         amor_decomp_flx{j,i} = real(cwt(Flx{j}(:,i+1),'amor',Fs)');
%         bump_decomp_flx{j,i} = real(cwt(Flx{j}(:,i+1),'bump',Fs)');
%         morse_decomp_flx{j,i} = real(cwt(Flx{j}(:,i+1),'morse',Fs)');
        amor_decomp_ext{j,i} = real(s,cwt(Flx{j}(:,i+1),'sym4',Fs)');
    end
end

