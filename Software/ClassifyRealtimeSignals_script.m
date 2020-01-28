clear

callbackInterval = 1;
executeTime = 11;

userData = struct;
userData.duration = callbackInterval; %callback duration(ni device) [second]

stream = timer; % timer class construct
stream.Period = callbackInterval; % calltack interval(timer)[second]
stream.UserData = userData;
stream.ExecutionMode = 'fixedRate';
stream.StartFcn = @timerSetup;
stream.TimerFcn = @timerInterrupts;
stream.StopFcn  = @timerFinish;
stream.ErrorFcn = @timerError;
stream.TasksToExecute = round(executeTime / callbackInterval);

start(stream);


%%
function label = refSignalLabel(spect)
%label = classify(TESTNet, spectrogram);
label = 0;
end

%%
function spect =  callbackDataAbailable2(cnvtData)
disp('callbackDataAbailable2')
spect = f_signalConverter(cnvtData,1);
%{
label = refSignalLabel(spectrogram);
labels = labels
global_outpuSignal.enQ(labels);
%}
end

%%
function timerSetup(self, event)
fprintf('-----setup     -----\n');


%fetch NI Device
session = daq.createSession('ni');
addAnalogInputChannel(session,'Dev1','ai0','Voltage');
%session setting
session.DurationInSeconds = self.Period;
session.Rate = 2000;


%Ring Baffer setting
inoutDataLen = session.Rate * session.DurationInSeconds;

cnvtLen = inoutDataLen * 1;

margin.catchup = inoutDataLen;
margin.convert = 0;

outQ.head = 1;
outQ.tail = 1 + margin.convert + inoutDataLen;

inQ.head = outQ.tail ;
inQ.tail = inQ.head + cnvtLen + margin.convert;

qLen = ...
    inoutDataLen +...
    margin.catchup +...
    cnvtLen +...
    margin.convert;

%plot area setting
ax = cell(2);
ax1 = subplot(2,1,1);
xlabel(ax1,'time');
ylabel(ax1,'Voltage');
ax2 = subplot(2,1,2);
xlabel(ax2,'time');
ylabel(ax2,'Lalbel');

%set parameter into the timer object
%session
self.UserData.session = session;
%plot
self.UserData.p1 = plot(ax1, [0]); %pre plot
self.UserData.p2 = plot(ax2, [0]); %pre plot
axis([ax1 ax2],'manual');
axis([ax1 ax2],[0 inf -3 3] * 0.05);
self.UserData.ax1 = ax1;
self.UserData.ax2 = ax2;
%ring baffer
self.UserData.signalIn  = RingQ(qLen, inQ.head , inQ.tail );
self.UserData.signalOut = RingQ(qLen, outQ.head, outQ.tail);
%convert
self.UserData.cvntLen = cnvtLen;
self.UserData.dataCount = 0;
%Networks
self.UserData.net.EMG = ...
    load(strcat(pwd,'Data\Networks\EMGClassifierNet.mat'));
self.UserData.net.EEG = ...
    load(strcat(pwd,'Data\Networks\EEGClassifierNet.mat'));

fprintf('session duration     \t: %d[s]\n',session.DurationInSeconds);
fprintf('session rate         \t: %d[Hs]\n',session.Rate);
fprintf('timer Period         \t: %d[s]\n',self.Period);
fprintf('timer tasks to excute\t: %d\n',self.TasksToExecute);
fprintf('queue length         \t: %d\n',qLen);
fprintf('indata queue head    \t: %d\n',inQ.head);
fprintf('indata queue tail    \t: %d\n',inQ.tail);
fprintf('outdata queue head   \t: %d\n',outQ.head);
fprintf('outdata queue tail   \t: %d\n',outQ.tail);

end

%%
function timerInterrupts(self, event)
fprintf('-----interrupts-----%s\n', ...
    datestr(event.Data.time,'HH:MM:SS.FFF'));
%data acquisition
%[signal, time stamps, trigger time]
[signal,~,~] = startForeground(self.UserData.session);

%enQ
%stream.UserData.signalIn.enQ(signal);  

%plot
self.UserData.signalIn.enQ(signal);
self.UserData.dataCount = self.UserData.dataCount + length(signal);

self.UserData.p1.YData = self.UserData.signalIn.readAllQ();
self.UserData.p2.YData = self.UserData.signalOut.readAllQ();

disp([...
    self.UserData.signalIn.head ... %head
    self.UserData.signalIn.tail ... %tail
    self.UserData.signalIn.getWaitingQLen()... %waitingQlength
    self.UserData.dataCount... %dataCount
    ])

if self.UserData.dataCount >= self.UserData.cvntLen
    cvntData = self.UserData.signalIn.deQ(self.UserData.cvntLen);
    spect = callbackDataAbailable2(cvntData);
    label = refSignalLabel(spect);
    self.UserData.dataCount = 0;
end


%labels = stream.UserData.signalOut.deQ(dataLen)
end

%%
function timerFinish(self, event)
fprintf('-----finish    -----\n');
delete(self);
end

%%
function timerError(self, event)
fprintf('-----error     -----\n');
delete(self);
end
%%