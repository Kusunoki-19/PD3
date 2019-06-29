function [dataSets,labels] = clipDataSets(rawData)
%CLIPDATASETS clip data sets 
%   clip from raw EEG/EMG data recorded by simulink
label.old = -1;
label.new = -1;
setCount = 1;
anchor = 1;

colLabel = 2;
colTime = 1;

dataSets = {};
labels = {};

label.new = rawData(1,colLabel);
label.old = rawData(1,colLabel);

for row = 1:length(rawData(:,1))
    label.new = rawData(row,colLabel);
    
    %If label has been changed, clip data set, and renew parameter.
    if label.new ~= label.old
        dataSets{setCount,1} = rawData(anchor:(row-1),(colLabel+1):end);
        labels{setCount,1} = label.old;
        anchor = row;
        label.old = label.new;
        setCount = setCount + 1;
    end
end

%Clip last label data set,
%because last data set has no chance label change.
dataSets{setCount,1} = rawData(anchor:(row),(colLabel+1):end);
labels{setCount,1} = label.old;

end 