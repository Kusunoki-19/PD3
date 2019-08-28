Ts = 1; % [second
userData = struct;
userData.data = '';
userData.running = 1;

timerObj = timer;
timerObj.Period = Ts;
timerObj.UserData = userData;
timerObj.ExecutionMode = 'fixedRate';
timerObj.StartFcn = @timerSetup;
timerObj.TimerFcn = @timerInterrupts;
timerObj.StopFcn  = @timerFinish;
timerObj.ErrorFcn = @timerError;
timerObj.TasksToExecute = 10;

start(timerObj);

while(true) 
    pause(0.5)
    disp(timerObj.UserData);
    if timerObj.UserData.running == 0
        break;
    end
end
delete(timerObj);


function timerSetup(timerObj, event)
disp('-----setup-----');
end

function timerInterrupts(timerObj, event)
disp('-----interrupts-----');
timerObj.UserData.data = datestr(event.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF');
end

function timerFinish(timerObj, event)
disp('-----finish-----');
timerObj.UserData.running = 0;
end

function timerError(timerObj, event)
disp('error');
end
