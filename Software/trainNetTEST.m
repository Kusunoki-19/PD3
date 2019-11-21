clear
dataPath = strcat(pwd,"\Data\TEST");
%%
%データのロード
[XTrain, YTrain, XDim] = f_dataLoader(dataPath);
%%
inputSize = XDim;
numClasses = 2;

layers = [ ...
    sequenceInputLayer(inputSize)
    fullyConnectedLayer(inputSize*16)
    fullyConnectedLayer(inputSize*16)
    bilstmLayer(inputSize*16,'OutputMode','last')
    fullyConnectedLayer(inputSize*8)
    bilstmLayer(inputSize*8,'OutputMode','last')
    fullyConnectedLayer(inputSize*4)
    bilstmLayer(inputSize*4,'OutputMode','last')
    fullyConnectedLayer(inputSize*2)
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