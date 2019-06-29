load('rawEEG.mat');

setCount = 1;
newLabel = "";
preLabel = "";
dataSets = {};
clipA = 1; %data clip start point
clipB = 1; %data clip end point

for index = 1:length(DataValues)
    %renew parameter
    increment(clipB);
    newLabel = rawEEG(clipB,end);
    
    if newLabel ~= preLabel
        %clip raw data
        dataSets{setCount} = rawEEG(clipA:(clipB-1),1:(end-1))
        %renew parameter
        clipA = clipB;
        preLabel = newLabel;
        increment(setCount);
    end
end

function [x] = increment(x)
x = x + 1;
end