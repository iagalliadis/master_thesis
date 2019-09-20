%% plot stationary signal sampled at 1000 Hz
Fs = 1000;
t= 0:1/1000:1;
y1 = 1*sin(2*pi*10*t);
y2 = 1*sin(2*pi*50*t);
y3 = 1*sin(2*pi*100*t);
z1 = y1 +y2;
z2 = y1 +y2 +y3;
y = [y1(1:250),z1(251:500), z2(501:750),y1(751:1000)];
x = [1:1000];

plot(x,y(1:1000));
ylabel('Magnitude');
xlabel('time(msec)');
%% plot the first EMG Ext signal of the cell

lineStyles = {'-', '--', ':', '-.'};
myColors = distinguishable_colors(8);
legend_str = cell(8,1);
figure

for i=1:8
    plot(linspace(0,1,length(Out.Ext{1}(:,1))),Out.Ext{1}(:,i),...
        'linestyle',lineStyles{rem(i-1,numel(lineStyles))+1},...
        'color',myColors(i,:),...
        'linewidth',1.5);
    hold on;
    legend_str{i}=num2str(i);
end
legend(strcat('ch',legend_str),'location','Northwest')
title('EMG signal for thumb extension')

% plot the first EMG Flx signal of the cell
figure

for i=1:8
    plot(linspace(0,1,length(Out.Flx{1}(:,1))),Out.Flx{1}(:,i),...
        'linestyle',lineStyles{rem(i-1,numel(lineStyles))+1},...
        'color',myColors(i,:),...
        'linewidth',1.5);
    hold on;
    legend_str{i}=num2str(i);
end
legend(strcat('ch',legend_str),'location','Northwest')
title('EMG signal for thumb flexion')


%plot the STFT for extension
figure
fs = 200 ;
spectrogram(RawData.Ext{1}(:,7),[],[],[],fs,'yaxis');
set(gca, 'ytick', 0:5:100);
ytickangle(50);
title('STFT for the 7th channel of extension');

%plot the spectrogram for extension and flexion
figure
fs = 200;
spectrogram(RawData.Ext{1}(:,7),hamming(100),99,4096,fs,'yaxis');
set(gca, 'ytick', 0:5:100);
ytickangle(50);

figure
fs = 200;
spectrogram(RawData.Flx{1}(:,7),hamming(100),99,4096,fs,'yaxis');
set(gca, 'ytick', 0:5:100);
ytickangle(50);

%% four spectrograms in one figure
%sampling frequency
fc=400;
%duration of the signal
T=20;
%zero padding factor
my_zero=10;

%generate the signal
t=linspace(0,T,fc*T);
x=zeros(1,length(t));
%thresholds
th1=0.25*T*fc;
th2=0.5*T*fc;
th3=0.75*T*fc;
th4=T*fc;
x(1:th1)=cos(2*pi*10*t(1:th1));
x((th1+1):th2)=cos(2*pi*25*t((th1+1):th2));
x((th2+1):th3)=cos(2*pi*50*t((th2+1):th3));
x((th3+1):th4)=cos(2*pi*100*t((th3+1):th4));

%calculate and show the spectrograms
figure
subplot(2,2,1)
[spectrogram, axisf, axist]=stft(x,10,1,fc,'blackman',my_zero);
spectrogram=spectrogram/max(spectrogram(:));
imagesc(axist,axisf,spectrogram),
title('Spectrogram with T = 25 ms'),
ylabel('frequency [Hz]'),
xlabel('time [s]'), 
colorbar;

subplot(2,2,2)
[spectrogram, axisf, axist]=stft(x,50,1,fc,'blackman',my_zero);
spectrogram=spectrogram/max(spectrogram(:));
imagesc(axist,axisf,spectrogram),
title('Spectrogram with T = 125 ms'),
ylabel('frequency [Hz]'),
xlabel('time [s]'), 
colorbar;

subplot(2,2,3)
[spectrogram, axisf, axist]=stft(x,150,1,fc,'blackman',my_zero);
spectrogram=spectrogram/max(spectrogram(:));
imagesc(axist,axisf,spectrogram),
title('Spectrogram with T = 375 ms'),
ylabel('frequency [Hz]'),
xlabel('time [s]'), 
colorbar;

subplot(2,2,4)
[spectrogram, axisf, axist]=stft(x,400,1,fc,'blackman',my_zero);
spectrogram=spectrogram/max(spectrogram(:));
imagesc(axist,axisf,spectrogram),
title('Spectrogram with T = 1000 ms'),
ylabel('frequency [Hz]'),
xlabel('time [s]'), 
colorbar;

%% Fourier transform for extension
y = fft(RawData.Ext{1}(:,8));
f = (0:length(y)-1)*50/length(y);
plot(f,abs(y));

%Fourier transform for flexion
y = fft(RawData.Flx{1}(:,8));
f = (0:length(y)-1)*50/length(y);
plot(f,abs(y));


%% Plot EMG and smoothed EMG extension
figure
subplot(2,1,1)
plot(linspace(0,1,length(Out.Ext{1}(:,1))),Out.Ext{1}(:,8))
title('Raw EMG extension')

subplot(2,1,2)
plot(linspace(0,1,length(Out.Ext{1}(:,1))),FtrVct.Smoothed_ext{1}(:,8))
title('Smoothed EMG extension')

% Plot EMG and smoothed EMG flexion
figure
subplot(2,1,1)
plot(linspace(0,1,length(Out.Flx{1}(:,1))),Out.Flx{1}(:,8))
title('Raw EMG flexion')

subplot(2,1,2)
plot(linspace(0,1,length(Out.Flx{1}(:,1))),FtrVct.Smoothed_flx{1}(:,8))
title('Smoothed EMG flexion')

%% Activation functions and their derivatives
x = -4:0.1:4;
y1 = sigmf(x,[1 0]);
y2 = tanh(x);
y3 = x;
y4 = poslin(x);
figure
subplot(2,1,1)
hold on
plot(x,y1,'r','LineWidth',2);
plot(x,y2,'b','LineWidth',2);
plot(x,y3,'g','LineWidth',2);
plot(x,y4,'c','LineWidth',2);
ylim([-1.2 1.2])
str = {'$$y = g_{sigmoid}(x) $$', '$$ y = g_{tanh}(x) $$', '$$ y = g_{linear}(x) $$', '$$ y = g_{ReLU}(x) $$'};
title('\fontsize{18}Activation Functions')
legend(str, 'Interpreter','latex', 'Location','NW','fontsize', 22)
grid on


x = -4:0.1:4;
y2 = sigmf(x,[1,0]).*(1 - sigmf(x,[1,0]));
y3 = 1 - tanh(x).^2;
subplot(2,1,2)
hold on
plot(x,ones(size(x)) * 1,'r','LineWidth',2);
plot(x,y2,'b','LineWidth',2);
plot(x,y3,'g','LineWidth',2);
y4 = x ;
y4(x<0) = zeros;
y4(x>=0) = ones;
plot(x,y4,'c*','LineWidth',2)
ylim([-1.2 1.2])
str = {'$$y = \dot{g}_{sigmoid}(x) $$', '$$ y = \dot{g}_{tanh}(x) $$', '$$ y = \dot{g}_{linear}(x) $$', '$$ y = \dot{g}_{ReLU}(x) $$'};
title('\fontsize{18}Activation Functions Derivatives')
legend(str, 'Interpreter','latex', 'Location','SE','fontsize', 22)
grid on

%% plot dwt wavelets
f = 100; 
f_c = 1; 
T = 1 / f;
t = 0 : T : 5;
A = t;

subplot(2,2,1);
s1 = sin(2*pi*(f_c + A).*t);
plot(t, s1);

subplot(2,2,2);
s2 = wavedec(y,1,'sym4');
plot(s2);

subplot(2,2,3);
s3 = wavedec(y,1,'db4');
plot(s3);

subplot(2,2,4);
s4 = wavedec(y,1,'db20');
plot(s4)
%%
x= -4:0.2:4;
y1 = x.^2;
plot(x,y1)
grid on
xlabel('Weight 1')
ylabel('Cost')

figure
x= -4:0.2:4;
y = -4:0.2:4;
[X,Y] = meshgrid(x,y);
Z = X.^2 + Y.^2;
grid on
surf(Z)
xlabel('Weight1');
ylabel('Weight2');
zlabel('Cost');
colormap(jet) 

%% average perfs of sym4sym8 with each other feature from 1-13 Layers
T = table(categorical({'Layer 1';'Layer 2';'Layer 3';'Layer 4';'Layer 5';'Layer 6';'Layer 7';'Layer 8';'Layer 9';'Layer 10';'Layer 11';'Layer 12';'Layer 13';}),...
    [68.1;69.7;67.0;72.0;71.3;74.2;73.2;72.9;74.2;73.0;74.1;73.3;74.6],...
    [61.0;66.0;63.7;65.0;67.8;71.1;68.6;71.0;63.2;71.6;71.8;70.1;70.0],...
    [63.5;70.5;72.4;71.4;74.0;73.0;74.0;72.3;74.8;73.8;73.8;74.1;74.5],...
    [67.0;68.4;70.0;71.5;72.5;73.8;73.5;72.2;72.8;74.2;74.0;73.1;73.7],...
    [61.0;69.2;68.4;72.1;71.0;74.2;71.7;73.5;74.0;72.3;74.6;74.3;74.3],...
    [68.0;67.1;71.2;71.1;71.5;72.6;73.0;73.6;73.5;73.0;73.7;74.1;74.9],...
    [66.0;69.5;69.7;70.5;72.5;74.1;74.3;73.5;72.1;74.1;74.2;74.4;74.9],...
    [64.4;68.4;69.1;69.4;70.5;72.3;73.8;74.3;74.4;74.8;73.7;74.0;74.8],...
    [66.0;67.0;70.7;73.0;67.0;71.5;73.2;72.0;71.5;73.4;72.5;74.8;74.6],...
    'VariableNames',{'Layers','smooth','rms','stft','haar','db8','bior13','bior22','coif3','coif4'});
%T.Properties.VariableNames = {'Layers','smooth','rms','stft','haar','db8','bior13','bior22','coif3','coif4'};

figure
%ribbon((1:height(T)).',T{:,2:end},1)
%plot((1:height(T)).',T{:,2:end},'LineWidth',2)
T1 = table2array(T(:,2:10));
%T2 = T.Properties.VariableNames(1,2:end);
%T3 = table2array(T(:,1));
%tbl = table(T1);
%XDisplayData = {'smooth','rms','stft','haar','db8','bior13','bior22','coif3','coif4'};
h = heatmap(T1,'XData',['smooth','rms','stft','haar','db8','bior13','bior22','coif3','coif4']);
h.XData = ['smooth','rms','stft','haar','db8','bior13','bior22','coif3','coif4'];

figure;
my_matrix = rand(3);
h = heatmap(my_matrix, 'Colormap', parula(3), 'ColorbarVisible', 'on', 'XLabel', 'Time', 'YLabel', 'September');
%ax = gca;
h.XData = ["Hello" "World" "Thursday"]


load patients
tbl = table(LastName,Age,Gender,SelfAssessedHealthStatus,...
    Smoker,Weight,Location);
h = heatmap(tbl,'Smoker','SelfAssessedHealthStatus');
h.YDisplayData = {'Excellent','Good','Fair','Poor'};

%x = ['smooth','rms','stft','haar','db8','bior13','bior22','coif3','coif4'];
%set(gca,'xticklabel',x.')
% Add title and axis labels
%title('sym4sym8 tested against each feature')
addXLabel(h,XDisplayData)
xlabel('Features') %Features
ylabel('Layers') %Layers
zlabel('Performances') %Layers
%set(h, {'CData'}, get(h,'ZData'), 'FaceColor','interp','MeshStyle','column')
axis square
%legend('smooth','rms','stft','haar','db8','bior1.3','bior2.2','coif3','coif4','Location','southwest')
set(gcf, 'Color', 'w');
saveas(gcf, 'sym4sym8.png');
export_fig sym4sym8.png