clear
dataPath = strcat(pwd,"\Data\EEG2018");
%%
%データのロード
[XTrain, YTrain, XDim] = f_dataLoader(dataPath);
%%
inputSize = dataDimention;
numClasses = 3;

layers = [ ...
    sequenceInputLayer(inputSize)
    fullyConnectedLayer(2^12)
    fullyConnectedLayer(2^12)
    bilstmLayer(2^6,'OutputMode','last')
    fullyConnectedLayer(2^7)
    fullyConnectedLayer(4)
    
    softmaxLayer
    classificationLayer]
maxEpochs = 100;
miniBatchSize = 20;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','once', ...
    'Verbose',0, ...
    'Plots','training-progress');
EEGClassifierNet = trainNetwork(XTrain,YTrain,layers,options);

save(strcat(dataPath,'\Networks\EEGClassifierNet.mat'),'EEGClassifierNet');