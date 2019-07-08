clear
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
%�f�[�^�̕\��
%{
figure
index = [1,2,60,61];
ax = cell(2*4);
for i = (1:4)
    ax{i} = subplot(2,4,i);
    for j = (0:4)
        if j == 0 
            hold on
        end
        plot(ax{i},signals{index(i)+j,1});
    end
    
    xlabel(ax{i},"Time Step");
    title(ax{i},labels{index(i)});
    
    ax{4+i} = subplot(2,4,4+i);
    for j = (0:10)
        if j == 0
            hold on
        end
        plot(ax{4+i},XTrain{index(i)+j,1});
    end
    xlabel(ax{4+i},"Frequency");
    title(ax{4+i},labels{index(i)});
end
%legend('Dorsal','Grip','Relax','Ulnar')
%}
%%
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