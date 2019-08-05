function [signal, dimention] = f_signalConverter(signal,dimention)
%SIGNALCONVERTER Classiferプログラム用の前処理プログラム
%   signal, double cell
%   dimention , データ次元数

%   low pass, high pass, stft
signal = limitBand(signal);
[signal, dimention] = stftSignal(signal, dimention);

end

function [signal] = limitBand(signal)
fs = 2000;
%signal = lowpass(signal,fs/2, fs);
signal = highpass(signal, 10, fs);
end

function [signal, dimention] = stftSignal(signal, dimention) 
fs = 2000;
% vertical length = dim length = size(signal,1)
% horizen length = time length = size(signal,2)
signal = stft(signal, fs);
signal = abs(signal);

% vertical length = dim length = size(signal,1)
% horizen length = time length = size(signal,2)
dimention = size(signal, 1);
end

function [signal, dimention] = stftWithFft(signal, dimention) 
fs = 2000;
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

for curDim = 1:dimention 
    
    for i = 0:((sigLen - M) / R)
        b = M + (R * i);
        a = b - M + 1;

        fftRaw = fft(signal(a:b,curDim));
        fftAbs = abs(fftRaw);
        fftAbs = transpose(fftAbs);
        hozcat(spectrogram, fftAbs);
        
    end
end
signal = stft(signal, fs);
signal = abs(signal);
dimention = size(signal, 1);
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
