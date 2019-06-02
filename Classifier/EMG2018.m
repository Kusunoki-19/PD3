clear
%%
dataPath = 'data\EMG2018\train';
[XTrain, YTrain, ] = recDir(dataPath,{}, {}, 1);
YTrain = categorical(YTrain); %cell�z��������w�K�f�[�^�p��categorical�z��ɕϊ�

for i = 1 : size(XTrain,1)
    disp(i)
    [XTrain{i,1}] = fftEMG(XTrain{i,1});
end
dataDimention = 1;

figure
plot(XTrain{1},XTrain{75},XTrain{135},XTrain{175})
%x�����x��
xlabel("Time Step")
%�O���t�^�C�g��
title("Training Observation 1")
%�}��
legend("Feature " + string(1),'Location','northeastoutside')

%%
inputSize = dataDimention
numClasses = 4;

layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(800,'OutputMode','last')
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

%%
%�^����ꂽpath�̃f�B���N�g�����ċA�I�ɒT���������Ɋi�[����Ă���t�@�C����ǂݍ���
function [X,Y,index] = recDir(path, X, Y, index)
fprintf('\n----- %s -----\n',path);
d = dir(path);

for i = 1 : length(d)
    if d(i).name == '.'
        continue;
    end
    
    if d(i).isdir == 0
        fprintf('%s\t',d(i).name);
        tempX = importdata(strcat(path,'\',d(i).name)); %�f�[�^�^�̈Ⴄ���̂��������̂ł��̑΍�
        if isstruct(tempX)
            tempX = tempX.val;
        end
        X{index,1} = tempX;
        
        tempY = strsplit(path,'\');
        tempY = tempY(end);
        tempY = tempY{1,1};
        Y{index,1} = tempY;
        index = index + 1;
    else
        pathNext = strcat(path,'\', d(i).name);
        [X,Y,index] = recDir(pathNext, X, Y, index);
    end
end
end
%%
function [P1] = fftEMG(signalX)
L = size(signalX,2);
fftX = fft(signalX);
P2 = abs(fftX/L); %�M���̐�Βl
P1 = P2(1:cast((L/2)+1,'int8')); %�����X�y�N�g����Б��X�y�N�g����
P1(2:end-1) = 2*P1(2:end-1); %�U����2�{

end
%%
