function [signal, signalDim, signalLen] = SignalConverter(signal,fs,cutFreqL,cutFreqH)
%SIGNALCONVERTER Classiferプログラム用の前処理プログラム
%   signal, double cell
%   Fs , サンプリング周波数

signalLen = size(signal,2); %信号長
signalDim = size(signal,1); %信号次元数
signalTime = signalLen / fs; %計測時間[s] 

%signal = limitBand(signal);

%[win] = rectangularWindow(signalLen);
[win] = hammingWindow(signalLen);

[signal, signalDim, signalLen] = fftAbs(signal, win);
%[signal, dimention] = stftSignal(signal, dimention);

[signal, signalLen] = cutFreq(signal,fs,cutFreqL,cutFreqH);
end

function[cutSignal, signalLen] = cutFreq(signal,fs,cutFreqL,cutFreqH)
signalLen = size(signal,2); %信号長
signalDim = size(signal,1); %信号次元数
signalTime = signalLen / fs; %計測時間[s] 

usableDataIndex = ...
    cast(signalLen*(cutFreqL/fs),'uint32') + 1: ...
    cast(signalLen*(cutFreqH/fs),'uint32') + 1;
cutSignal = [];
for i = 1:signalDim
    %各チャンネル分でループ
    cutSignal(i,:) = signal(i,usableDataIndex);
end
signalLen = size(cutSignal,2);
end

function [cnvSignal, signalDim, signalLen] = fftAbs(signal, windowf) 
fs = 1000;
% vertical length = dim length = size(signal,1)
% horizen length = time length = size(signal,2)
fftData = [];
cnvSignal = [];
for i = 1:size(signal,1)
    signalw = signal(i,:) .* windowf; %process signal with window
    fftData2 = fft(signalw);
    absData = abs(fftData2);
    cnvSignal = vertcat(cnvSignal, absData);
end

% vertical length = dim length s= size(signal,1)
% horizen length = time length = size(signal,2)
signalDim = size(cnvSignal, 1);
signalLen = size(cnvSignal, 2);
end

function [rw] = rectangularWindow(N) 
%RECTANGULARWINDOW 方形窓
%   N , 窓長さ
rw = ones(1,N);
rw(1,1) = 0;
rw(1,end) = 0;
end

function [hw] = hammingWindow(N) 
%HAMMINGWINDOW ハミング窓
%   N , 窓長さ
alp = 25/46;
n = (1:N);
hw = alp-(1-alp)*cos((2*pi*n)/N);
end




