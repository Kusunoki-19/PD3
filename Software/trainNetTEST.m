dataPath = strcat(pwd,"\Data\TEST");
%%
%データのロード
[XTrain, YTrain, XDim] = f_dataLoader(dataPath);
%%
inputSize = XDim;
numClasses = 2;

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(inputSize,'OutputMode','last')
    fullyConnectedLayer(inputSize)
    fullyConnectedLayer(inputSize)
    fullyConnectedLayer(inputSize)
    fullyConnectedLayer(inputSize)
    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer]
maxEpochs = 25;
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
TESTClassifierNet = trainNetwork(XTrain,YTrain,layers,options);

save(strcat(pwd,'\Data\Networks\TESTClassifierNet.mat'),'TESTClassifierNet');