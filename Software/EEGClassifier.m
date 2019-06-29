clear
dataPath = strcat(pwd,"\Data");
%%
%�f�[�^�̃��[�h
signals = {}; %cell�z��
labels = {}; %�f�[�^���x���z��

XTrain = {}; %�w�K�p�f�[�^ x : �C���v�b�gcell�z��
YTrain = {}; %�w�K�p�f�[�^ y : ����catetorical�z��

[signals, labels] = dataReader(strcat(dataPath,"\EMG2018\train"));
%cell�z����w�K�f�[�^�p��categorical�z��ɕϊ�
for i = 1:length(labels)
    %str <-- cell list str
    temp = labels{i,1}(1,1); 
    %cell str <-- str
    temp = cellstr(temp);
    %cell str <-- cell str ���i�̃f�[�^�`���ŕۑ����Ȃ��� cell list str�ɂȂ��Ă��܂�
    labels{i,1}  = temp{1,1};
end

YTrain = categorical(labels); 
%EMG�f�[�^��FFT���Ċw�K�p�f�[�^�ɕϊ�
for i = 1 : size(signals,1)
    [XTrain{i,1}] = fftEMG(signals{i,1});
end

%%
%�f�[�^�̕\��
figure
index = [1,75,135,175];
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

%%
dataDimention = 1;
inputSize = dataDimention;
numClasses = 4;

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

save(strcat(dataPath,'Networks\EEGClassifierNet.mat'),'EEGClassifierNet');

%%
function [P1] = fftEMG(signalX)
L = size(signalX,2);
fftX = fft(signalX);
P2 = abs(fftX/L); %�M���̐�Βl
P1 = P2(1:cast((L/2)+1,'int8')); %�����X�y�N�g����Б��X�y�N�g����
P1(2:end-1) = 2*P1(2:end-1); %�U����2�{

end
%%