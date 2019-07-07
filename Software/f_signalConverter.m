function [signal, dimention] = f_signalConverter(signal,dimention)
%SIGNALCONVERTER Classifer�v���O�����p�̑O�����v���O����
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
signal = stft(signal, fs);
signal = abs(signal);
dimention = size(signal, 1);
end

function [P1] = fftEMG(signalX)
L = size(signalX,2);
fftX = fft(signalX);
P2 = abs(fftX/L); %�M���̐�Βl
P1 = P2(1:cast((L/2)+1,'int8')); %�����X�y�N�g����Б��X�y�N�g����
P1(2:end-1) = 2*P1(2:end-1); %�U����2�{

end

function [P1] = stftEMG(signalX)
L = size(signalX,2);
stftX = stft(signalX);
P1 = abs(stftX/L); %�M���̐�Βl
%P2 = abs(stftX/L); %�M���̐�Βl
%P1 = P2( 1:cast((L/2)+1,'int8') , :); %�����X�y�N�g����Б��X�y�N�g����
%P1(2:end-1) = 2*P1(2:end-1); %�U����2�{

end