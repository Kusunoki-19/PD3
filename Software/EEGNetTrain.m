clear
dataPath = strcat(pwd,"\Data\EMG2018");
%%
%�f�[�^�̃��[�h
dataPath = strcat(pwd,"\Data\EMG2019");
%%
%�f�[�^�̃��[�h
signals = {}; %cell�z��
labels = {}; %�f�[�^���x���z��

XTrain = {}; %�w�K�p�f�[�^ x : �C���v�b�gcell�z��
YTrain = {}; %�w�K�p�f�[�^ y : ����catetorical�z��

%�f�[�^�̃��[�h
[signals, labels] = f_dataReader(dataPath);
%cell�z����w�K�f�[�^�p��categorical�z��ɕϊ�
YTrain = f_cellListStrToCategorical(labels);

%EMG�f�[�^��FFT���Ċw�K�p�f�[�^�ɕϊ�
dataDimention = size(signals{1,1},1);
for i = 1 : size(signals,1)
    [XTrain{i,1}, dataDimention] = f_signalConverter(signals{i,1} , dataDimention);
end
%%
inputSize = dataDimention;
numClasses = 3;

layers = [ ...
    sequenceInputLayer(inputSize)
    fullyConnectedLayer(2^11)
    fullyConnectedLayer(2^6)
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