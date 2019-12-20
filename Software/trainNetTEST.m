dataPath = "D:\kusunoki\PD3\Software\Data\EEG\20191204";
%%
%データのロード
[XTrain, YTrain, XDim] = f_dataLoader(dataPath);
%%
inputSize = XDim;
numClasses = 3;

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(1000,'OutputMode','last')
    fullyConnectedLayer(1000)
    fullyConnectedLayer(1000)
    fullyConnectedLayer(500)
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer]
maxEpochs = 25;
miniBatchSize = 20;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','auto', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','once', ...
    'Verbose',0, ...
    'Plots','training-progress');
TESTClassifierNet = trainNetwork(XTrain,YTrain,layers,options);

save(strcat(pwd,'\Data\Networks\TESTClassifierNet.mat'),'TESTClassifierNet');