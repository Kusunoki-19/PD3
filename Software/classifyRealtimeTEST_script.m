
clear
%sessionデータにいくらのデータが集まった状態でデータを返すか
%という記述があるので、そのデータを用いてデータ長を決定する
global GLOBAL_Fs;
global GLOBAL_Ts;
GLOBAL_Fs = 2000;
GLOBAL_Ts = 1/GLOBAL_Fs;

%fetch NI Device
session = daq.createSession('ni');
addAnalogInputChannel(session,'Dev1','ai0','Voltage');

%set parameters
session.IsContinuous = true;
session.Rate = GLOBAL_Fs;

global global_inputSignal;
global global_outputSignal;
global_inputSignal  = zeros(session.NotifyWhenDataAvailableExceeds,1);
global_outputSignal = zeros(session.NotifyWhenDataAvailableExceeds,1);

%plot area setting
global ax;
ax = cell(2);
ax{1} = subplot(1,2,1);
xlabel(ax{1},'time');
ylabel(ax{1},'Voltage');
ax{1}.XLim = [0 10];

ax{2} = subplot(1,2,2);
xlabel(ax{1},'time');
ylabel(ax{1},'Frecency');


%"output" stream
%queueOutputData(session,[global_inputSignal]);
%lh = addlistener(s,'DataAvailable'...
%    ,@(src,event) src.queueOutputData(global_inputSignal));

%session start and end
listenHandler = addlistener(session,'DataAvailable',@callbackDataAvailable);
startBackground(session);
delete (listenHandler);
stop(session);

function label = refSignalLabel()
label = classify(TESTNet, spectrogram);
end

function callbackDataAbailable2()
cnvSignal = inputSignal.deQ(2000);
spectrogram = f_signalzconverter(cnvSignal);
label = refSignalLabel(spectrogram);
labels = labels
global_outpuSignal.enQ(labels);
end

function callbackDataAvailable(src,event)
     %  CALLBACKDATAAVAILABLE called when session data available
     % src , contains session infomation , struct
     % src.NotifyWhenDataAvailableExceeds , data length , double
     
     % event , contains session data , struct
     % event.data , data(input signal of NI Device) , 
     %     double list (src.NotifyWhenDataAvailable)x(channel Len)
     
     %plot(ax{1},event.TimeStamps,event.Data);
     plot(event.TimeStamps,event.Data);
     
     %{
     persistent dataLen;
     if isempty(dataLen)
         dataLen = length(event.data,1);
     end
     
     global_inputSignal.enQ(event.Data);  
     
     plot(event.TimeStamps,event.Data);
     if waitingLen > convertLen
        parfeval(callbackDataAvailable2)
     end
     
     labels = global_outputSignal.deQ(dataLen)
     %}
     
end