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

[signal, signalDim, signalLen] = fftSignal(signal, win);
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

function [cnvSignal, signalDim, signalLen] = fftSignal(signal, windowf) 
fs = 1000;
% vertical length = dim length = size(signal,1)
% horizen length = time length = size(signal,2)
fftData = [];
cnvSignal = [];
for i = 1:size(signal,1)
    signalw = signal(i,:) .* windowf; %process signal with window
    fftData2 = fft(signalw);
    
    %fftData1 = fftData2(1:size(signal,2)/2);
    %amp1 = abs(fftData1) * 2;
    %amplog = 20*log10(amp1);
    amplog = 20*log10(abs(fftData2)) * 2;
    
    cnvSignal = vertcat(cnvSignal, amplog);
end

% vertical length = dim length = size(signal,1)
% horizen length = time length = size(signal,2)
signalDim = size(cnvSignal, 1);
signalLen = size(cnvSignal, 2);
end

function [P1] = fftEMG(signalX)
L = size(signalX,2);
fftX = fft(signalX);
P2 = abs(fftX/L); %�M���̐�Βl
P1 = P2(1:cast((L/2)+1,'int8')); %�����X�y�N�g����Б��X�y�N�g����
P1(2:end-1) = 2*P1(2:end-1); %�U����2�{

end

function [cnvSignal, dimention] = stftSignal(signal, dimention) 
fs = 1000;
% vertical length = dim length = size(signal,1)
% horizen length = time length = size(signal,2)
stftData = [];
cnvSignal = [];
for i = 1:size(signal,1)
    stftData = stft(signal(i,:), fs,'FFTLength',1000);
    
    stftDim = size(stftData,1);
    halfDim = cast((stftDim/2)+1,'int8');
    absData = abs(stftData(1:halfDim+1,:));
    
    cnvSignal = vertcat(cnvSignal, absData);
end
cnvSignal = abs(cnvSignal);

% vertical length = dim length = size(signal,1)
% horizen length = time length = size(signal,2)
dimention = size(cnvSignal, 1);
end

function [spectrogram, dimention] = stftOriginal(signal, dimention) 
fs = 1000;
sigLen = size(signalX,2);

M = 400; % window length
R = 200; % window hops over samples on original signals
L = 200; % overlap samples

a = 1; % window start
b = M; % windwo end

%{ 
---spectrogram explain---

t1-d1 t2-d1 t3-d1 ... tT-d1 
t1-d2 t2-d2 t3-d2 ... tT-d2 
t1-d3 t2-d3 t3-d3 ... tT-d3 
...   ...   ...   ... ...
t1-dD t2-dD t3-dD ... tT-dD 

tN-dM : (fft converted data)
vertical : freqency
hroizen  : time

hozcat (t1-d1, t2-d1)
vertcat(t1-d1, t1-d1)

t1 --> t2
The difference between t1 to t2 means ones shift of window.
Therefore the time between t1 to t2 is (R * sampling time) [s].

d1 --> d2 
d1 means dimention 1.
In this situation , dimention means chennel.
%}
spectrogram = [];
spec_hoz = [];

for curDim = 1:dimention 
    for i = 0:((sigLen - M) / R)
        b = M + (R * i);
        a = b - M + 1;
        cnvSignal = stftWindow(signal(a:b,curDim));
        fftRaw = fft(cnvSignal);
        fftAbs = abs(fftRaw);
        fftAbs = transpose(fftAbs);
        hozcat(spec_hoz, fftAbs);
    end
    vercat(spectrogram, spec_hoz);
end
dimention = size(spectrogram, 1);
end

function [P1] = stftEMG(signalX)
L = size(signalX,2);
stftX = stft(signalX);
P1 = abs(stftX/L); %�M���̐�Βl
%P2 = abs(stftX/L); %�M���̐�Βl
%P1 = P2( 1:cast((L/2)+1,'int8') , :); %�����X�y�N�g����Б��X�y�N�g����
%P1(2:end-1) = 2*P1(2:end-1); %�U����2�{
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

function signal = stftWindow(signal)
windowLen = length(signal);

for i = 1:windowLen
    w = ((i - 1) / (windowLen - 1))*2;
    if w > 1
        w = 2 - w;
    end
    signal(i) = w * signal(i);
end
end

function [signal] = limitBandFilter(signal)
fs = 1000;
for i = 1:size(signal,1)
    
    signal(i,:) =  lowpass(signal(i,:), 250, fs);
    signal(i,:) = highpass(signal(i,:), 0.3, fs);
end
end



