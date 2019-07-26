%fetch NI Device
s = daq.createSession('ni');
addAnalogInputChannel(s,'Dev1','ai0','Voltage');
%set parameters
s.IsContinuous = true;
s.Rate=2000;

%sessionデータにいくらのデータが集まった状態でデータを返すかという記述があるので
%そのデータを用いてデータ長を決定する
signal = zeros(s.NotifyWhenDataAvailableExceeds,1);

queueOutputData(signal); %link to output stream data variable
%plot area setting
ax = cell(2);
ax{1} = subplot(1,2,1);
xlabel(ax{1},'time');
ylabel(ax{1},'Voltage');
ax{1}.XLim = [0 10];

ax{2} = subplot(1,2,2);
xlabel(ax{1},'time');
ylabel(ax{1},'Frecency');
%lh = addlistener(s,'DataAvailable',@callbackDataAvailable);
lh = addlistener(s,'DataAvailable',@(src,event) src.queueOutputData(signal));


%session start and end
startBackground(s);
delete (lh);
stop(s);
function callbackDataAvailable(src,event)
     %  CALLBACKDATAAVAILABLE called when session data available
     
     % src , contains session infomation , struct
     % src.NotifyWhenDataAvailableExceeds , data length , double
     
     % event , contains session data , struct
     % event.data , data(input signal of NI Device) , 
     %     double list (src.NotifyWhenDataAvailable)x(channel Len)
     
     %plot(ax{1},event.TimeStamps,event.Data);
     
     plot(event.TimeStamps,event.Data);
     
end