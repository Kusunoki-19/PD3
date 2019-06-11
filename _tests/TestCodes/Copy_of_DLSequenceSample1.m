clear
dataPath = 'data\EMG2018\train';
[XTrain, YTrain, ] = recDir(dataPath,{}, {}, 1);
YTrain = categorical(YTrain);
dataDimention = 1;
figure
plot(XTrain{1}')
%x軸ラベル
xlabel("Time Step")
%グラフタイトル
title("Training Observation 1")
%凡例
legend("Feature " + string(1),'Location','northeastoutside')

inputSize = dataDimention
numClasses = 4;

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(80,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer]
maxEpochs = 100;
miniBatchSize = 100;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','never', ...
    'Verbose',0, ...
    'Plots','training-progress');
net = trainNetwork(XTrain,YTrain,layers,options);

function [X,Y,index] = recDir(path, X, Y, index)
fprintf('\n----- %s -----\n',path);
d = dir(path);

for i = 1 : length(d)
    if d(i).name == '.'
        continue;
    end
    
    if d(i).isdir == 0
        fprintf('%s\t',d(i).name);
        tempX = importdata(strcat(path,'\',d(i).name));
        if isstruct(tempX)
            tempX = tempX.val;
        end
        X{index,1} = tempX;
        tempY = strsplit(path,'\');
        tempY = tempY(end);
        tempY = tempY{1,1};
        %{
        if tempY == "Dorsal"
            tempY = 1;
        elseif tempY == "Grip"
            tempY = 2;
        elseif tempY == "Relax"
            tempY = 3;
        elseif tempY == "Ulnar"
            tempY = 4;
        end
        %}
        Y{index,1} = tempY;
        index = index + 1;
    else
        %fprintf('%s\t',d(i).name);
        pathNext = strcat(path,'\', d(i).name);
        [X,Y,index] = recDir(pathNext, X, Y, index);
    end
end
end

