function [signal, dimention] = f_signalConverter(signal,dimention)
%SIGNALCONVERTER Classiferプログラム用の前処理プログラム
%   signal, double cell
%   dimention , データ次元数

%   low pass, high pass, stft
signal = limitBand(signal);
[signal, dimention] = fftSignal(signal, dimention);

end

function [signal] = limitBand(signal)
fs = 1000;
for i = 1:size(signal,1)
    
    signal(i,:) =  lowpass(signal(i,:), 250, fs);
    signal(i,:) = highpass(signal(i,:), 0.3, fs);
end
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

function [cnvSignal, dimention] = fftSignal(signal, dimention) 
fs = 1000;
% vertical length = dim length = size(signal,1)
% horizen length = time length = size(signal,2)
fftData = [];
cnvSignal = [];
for i = 1:size(signal,1)
    fftData = fft(signal(i,:), fs);
    absData = abs(fftData);
    
    cnvSignal = vertcat(cnvSignal, absData);
end
cnvSignal = abs(cnvSignal);

% vertical length = dim length = size(signal,1)
% horizen length = time length = size(signal,2)
dimention = size(cnvSignal, 1);
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

function [P1] = fftEMG(signalX)
L = size(signalX,2);
fftX = fft(signalX);
P2 = abs(fftX/L); %信号の絶対値
P1 = P2(1:cast((L/2)+1,'int8')); %両側スペクトルを片側スペクトルへ
P1(2:end-1) = 2*P1(2:end-1); %振幅を2倍

end

function [P1] = stftEMG(signalX)
L = size(signalX,2);
stftX = stft(signalX);
P1 = abs(stftX/L); %信号の絶対値
%P2 = abs(stftX/L); %信号の絶対値
%P1 = P2( 1:cast((L/2)+1,'int8') , :); %両側スペクトルを片側スペクトルへ
%P1(2:end-1) = 2*P1(2:end-1); %振幅を2倍

end
