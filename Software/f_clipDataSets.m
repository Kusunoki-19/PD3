function [dataSets,labels] = f_clipDataSets(outData)
%CLIPDATASETS clip data sets 
%   clip from raw EEG/EMG data recorded by simulink

eeg = outData.rawEEG;
label = outData.label;

preLabel = -1;
newLabel = -1;
setCount = 1;
anchor = 1;

%colLabel = 2;%

dataSets = {};
labels = {};

%newLabel = outData(1,colLabel);%
%preLabel = outData(1,colLabel);%
newLabel = label(1);
preLabel = label(1);

for row = 1:length(label(:,1))
    %newLabel = outData(row,colLabel);%
    newLabel = label(row);
    
    %If label has been changed, clip data set, and renew parameter.
    if newLabel ~= preLabel
        dataSets{setCount,1} = eeg(anchor:(row-1),:);%clip
        dataSets{setCount,1} = transpose(dataSets{setCount,1});%transpose
        labels{setCount,1} = preLabel;
        anchor = row;
        preLabel = newLabel;
        setCount = setCount + 1;
    end
end

%Clip last label data set,
%because last data set has no chance label change.
dataSets{setCount,1} = eeg(anchor:(row),:);%clip %
dataSets{setCount,1} = transpose(dataSets{setCount,1});%transpose
labels{setCount,1} = preLabel;

end 