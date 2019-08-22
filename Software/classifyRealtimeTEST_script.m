clear

%plot area setting
ax = cell(2);
ax{1} = subplot(1,2,1);
xlabel(ax{1},'time');
ylabel(ax{1},'Voltage');
ax{1}.XLim = [0 10];

ax{2} = subplot(1,2,2);
xlabel(ax{1},'time');
ylabel(ax{1},'Frecency');


Ts = 2; % [second]
userData = struct;


stream = timer;
stream.Period = Ts; % sampling time
stream.UserData = userData;
stream.ExecutionMode = 'fixedRate';
stream.StartFcn = @timerSetup;
stream.TimerFcn = @timerInterrupts;
stream.StopFcn  = @timerFinish;
stream.ErrorFcn = @timerError;
stream.TasksToExecute = 5;

start(stream);


%%
function label = refSignalLabel()
%{
label = classify(TESTNet, spectrogram);
%}
end

%%
function callbackDataAbailable2()
%{
cnvSignal = inputSignal.deQ(2000);
spectrogram = f_signalzconverter(cnvSignal);
label = refSignalLabel(spectrogram);
labels = labels
global_outpuSignal.enQ(labels);
%}
end

%%
function timerSetup(self, event)
fprintf('-----setup     -----%s\n',datestr(event.Data.time,'HH:MM:SS.FFF'));
%fetch NI Device
self.UserData.session = daq.createSession('ni');
addAnalogInputChannel(self.UserData.session,'Dev1','ai0','Voltage');
self.UserData.session.Rate = 2000;
qLen = 2000 * 20;
self.UserData.signalIn  = RingQ(qLen, qLen * (2/4), qLen * (4/4));
self.UserData.signalOut = RingQ(qLen, qLen * (1/4), qLen * (3/4));

self.UserData.data = '';
self.UserData.running = 1;
end

%%
function timerInterrupts(self, event)
fprintf('-----interrupts-----%s\n',datestr(event.Data.time,'HH:MM:SS.FFF'));
%data acquisition
[signal,timeStamps,~] = startForeground(self.UserData.session);

%enQ
%stream.UserData.signalIn.enQ(signal);  

%plot
%plot(stream.UserData.signalIn.readQ(1,20000));
plot(timeStamps,signal);

%{
if waitingLen > convertLen
    callbackDataAvailable2(stream)
end

labels = stream.UserData.signalOut.deQ(dataLen)
%}
end

%%
function timerFinish(self, event)
fprintf('-----finish    -----%s\n',datestr(event.Data.time,'HH:MM:SS.FFF'));
self.UserData.running = 0;
delete(self);
end

%%
function timerError(self, event)
disp('-----error-----');
delete(self);
end
%%