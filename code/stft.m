function [spectrogram, axisf, axist] = stft(s,win_size,my_step,fc,win,zeropad)
%
%[spectrogram, axisf, axist] = stft(s,win_size,my_step,fc,win,zeropad)
%
% calculate the spectrogram of the signal s
%
%Input s=signal to process;
% win_size= size of the window to calculate the FFT;
% my_step=shift of the window;
% fc=sampling frequency;
% win=type of window (‘boxcar’,‘hamming’, ‘blackman’);
% zeropad=zeropadding factor;
%
%Output: spectrogram = time-frequency matrix
% axisf= vector of frequencies;
% axist= vector of time;
%
% This MATLAB function resides in:
% http://commons.wikimedia.org/wiki/User:Alejo2083/Stft_script
% Produces the following images:
% http://commons.wikimedia.org/wiki/File:STFT_colored_spectrogram_25ms.png
% http://commons.wikimedia.org/wiki/File:STFT_colored_spectrogram_125ms.png
% http://commons.wikimedia.org/wiki/File:STFT_colored_spectrogram_375ms.png
% http://commons.wikimedia.org/wiki/File:STFT_colored_spectrogram_1000ms.png


if nargin<6
    zeropad=1;
end
if nargin<5
    win='boxcar';
end

N=length(s);

%number of iterations
i_tot=floor((N-win_size)/my_step);

%initialization of the output matrix
spectrogram=zeros(floor(win_size*zeropad/2),i_tot);

%create the right window
if isequal(win,'boxcar')
    my_window=ones(win_size,1);
elseif isequal(win,'hamming')
    my_window=hamming(win_size);
elseif isequal(win,'blackman')
    my_window=blackman(win_size);
end

my_window=my_window';

for ii=1:i_tot
    %starting index
    a=1+(ii-1)*my_step;
    %ending index
    b=win_size+(ii-1)*my_step;
    %part of the signal to be processed
    temp=s(a:b);
    %scale with the chosen window
    temp=temp.*my_window;
    %initialize the zero-padded version
    zeropadded=zeros(1,win_size*zeropad);
    %create the zero-padded vector
    zeropadded(1:win_size)=temp;
    %FFT
    zeropadded=abs(fft(zeropadded));
    %get frequencies only once
    zeropadded=zeropadded(1:floor(win_size*zeropad/2));
    %store in the final matrix
    spectrogram(:,ii)=zeropadded';
end

%create axis to be used to plot the output
axisf=linspace(0,fc/2,floor(win_size*zeropad/2));
axist=linspace(win_size/fc,N/fc,ii);