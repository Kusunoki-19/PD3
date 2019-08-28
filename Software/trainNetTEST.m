clear
dataPath = strcat(pwd,"\Data\TEST");
%%
%データのロード
[XTrain, YTrain, XDim] = f_dataLoader(dataPath);
%%
inputSize = XDim;
numClasses = 2;

layers = [ ...
    imageInputLayer([128 109])
    fullyConnectedLayer(2^11)
    fullyConnectedLayer(2^6)
    bilstmLayer(2^6,'OutputMode','last')
    fullyConnectedLayer(2^7)
    fullyConnectedLayer(2)
    
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
TESTClassifierNet = trainNetwork(XTrain,YTrain,layers,options);

save(strcat(pwd,'\Data\Networks\TESTClassifierNet.mat'),'TESTClassifierNet');