clear
%%
%データのロード
signals = {}; %cell配列
labels = {}; %データラベル配列

XTrain = {}; %学習用データ x : インプットcell配列
YTrain = {}; %学習用データ y : 正解catetorical配列
dataPath = 'data\EMG2018\train';
[signals, labels, ] = recDir(dataPath,{}, {}, 1);

%cell配列を学習データ用にcategorical配列に変換
YTrain = categorical(labels); 
%EMGデータをFFTして学習用データに変換
for i = 1 : size(signals,1)
    [XTrain{i,1}] = fftEMG(signals{i,1});
end

%%
%データの表示
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
