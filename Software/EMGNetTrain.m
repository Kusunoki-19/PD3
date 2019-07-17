clear
dataPath = strcat(pwd,"\Data\EMG2019");
%%
%データのロード
signals = {}; %cell配列
labels = {}; %データラベル配列

XTrain = {}; %学習用データ x : インプットcell配列
YTrain = {}; %学習用データ y : 正解catetorical配列

%データのロード
[signals, labels] = f_dataReader(dataPath);
%cell配列を学習データ用にcategorical配列に変換
YTrain = f_cellListStrToCategorical(labels);

%EMGデータをFFTして学習用データに変換
dataDimention = size(signals{1,1},1);
for i = 1 : size(signals,1)
    [XTrain{i,1}, dataDimention] = f_signalConverter(signals{i,1} , dataDimention);
end

inputSize = dataDimention;
numClasses = 2;

layers = [ ...
    sequenceInputLayer(inputSize)
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
EMGClassifierNet = trainNetwork(XTrain,YTrain,layers,options);

save(strcat(pwd,'\Data\Networks\EMGClassifierNet.mat'),'EMGClassifierNet');