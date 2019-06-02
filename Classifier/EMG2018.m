clear
%%
dataPath = 'data\EMG2018\train';
[XTrain, YTrain, ] = recDir(dataPath,{}, {}, 1);
YTrain = categorical(YTrain); %cell配列も物を学習データ用にcategorical配列に変換

for i = 1 : size(XTrain,1)
    disp(i)
    [XTrain{i,1}] = fftEMG(XTrain{i,1});
end
dataDimention = 1;

figure
plot(XTrain{1},XTrain{75},XTrain{135},XTrain{175})
%x軸ラベル
xlabel("Time Step")
%グラフタイトル
title("Training Observation 1")
%凡例
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
%与えられたpathのディレクトリを再帰的に探索→そこに格納されているファイルを読み込み
function [X,Y,index] = recDir(path, X, Y, index)
fprintf('\n----- %s -----\n',path);
d = dir(path);

for i = 1 : length(d)
    if d(i).name == '.'
        continue;
    end
    
    if d(i).isdir == 0
        fprintf('%s\t',d(i).name);
        tempX = importdata(strcat(path,'\',d(i).name)); %データ型の違うものがあったのでその対策
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
P2 = abs(fftX/L); %信号の絶対値
P1 = P2(1:cast((L/2)+1,'int8')); %両側スペクトルを片側スペクトルへ
P1(2:end-1) = 2*P1(2:end-1); %振幅を2倍

end
%%
