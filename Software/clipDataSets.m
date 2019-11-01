dataLen = length(data(:,1));

data = data(20000:dataLen,:);
dataLen = length(data(:,1));

%(number of data sets) = (data sec) / (10 sec)
dataSec = dataLen / 10;
dataSetsNum = dataSec / 10;

for i = 0:dataSetsNum - 1

    p1 =      (i * 10) * Fs + 1; 
    p2 = p1 + (i * 10) * Fs + 1;
    
    %p1 = 1, p2 = 2001

    set = data(p1:p2,:);
end