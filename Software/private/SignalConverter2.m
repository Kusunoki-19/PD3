function [signal, signalDim, signalLen] = SignalConverter(signal,fs,cutFreqL,cutFreqH)
%SIGNALCONVERTER Classifer�v���O�����p�̑O�����v���O����
%   signal, double cell
%   Fs , �T���v�����O���g��

signalLen = size(signal,2); %�M����
signalDim = size(signal,1); %�M��������
signalTime = signalLen / fs; %�v������[s] 

%signal = limitBand(signal);

%[win] = rectangularWindow(signalLen);
[win] = hammingWindow(signalLen);

[signal, signalDim, signalLen] = fftAbs(signal, win);
%[signal, dimention] = stftSignal(signal, dimention);

[signal, signalLen] = cutFreq(signal,fs,cutFreqL,cutFreqH);
end

function[cutSignal, signalLen] = cutFreq(signal,fs,cutFreqL,cutFreqH)
signalLen = size(signal,2); %�M����
signalDim = size(signal,1); %�M��������
signalTime = signalLen / fs; %�v������[s] 

usableDataIndex = ...
    cast(signalLen*(cutFreqL/fs),'uint32') + 1: ...
    cast(signalLen*(cutFreqH/fs),'uint32') + 1;
cutSignal = [];
for i = 1:signalDim
    %�e�`�����l�����Ń��[�v
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
%RECTANGULARWINDOW ���`��
%   N , ������
rw = ones(1,N);
rw(1,1) = 0;
rw(1,end) = 0;
end

function [hw] = hammingWindow(N) 
%HAMMINGWINDOW �n�~���O��
%   N , ������
alp = 25/46;
n = (1:N);
hw = alp-(1-alp)*cos((2*pi*n)/N);
end




