%各パラメータの設定
initialize = true;

%最初の数秒の切り取り
preprocess = true;

%データの分割
%ラベルの変換
%データの保存
clip = true;

%時系列信号のロード
%信号長の違うデータの除外
%ラベルのごとでデータ数を合わせる
%学習用データへの変換
%YTrainの変換 , cell配列 --> categorical配列に変換
%XTrainの変換 , 時系列信号 --> 振幅特性
%データを3/4で分割　
load = false;

%データの学習とロード
train = false;

%学習データの解析
%学習結果の解析
validation = false;

if(initialize)
    Fs = 1000;
    sampleTime = 5;
    sampleLen = Fs * sampleTime;
    channelNum = 8;
    
    isMultiDisplay = true;
    
    trainDataClasses = {"c0","c1","c2"}; %ball, stick, none : c1 c2 c0
    validDataClasses = { ...
        "c1" ,"c2" ,"c3" ,"c4" ,"c5" ,"c6" ,"c7" ,"c8" ; ...
        "c10","c20","c30","c40","c50","c60","c70","c80"}; %c1~8 , c10~80
    
    firstCutsec = 10;
    cutFreqL = 0;
    cutFreqH = 50;
    trainRate = 0.5;
end

if(preprocess)
    preprocessedData = out1445;
    %最初の数秒を切り取り
    %切り取り秒
    preprocessedData.label     = ...
        preprocessedData.label(1+Fs*firstCutsec:end,:);
    preprocessedData.rawEEG    = ...
        preprocessedData.rawEEG(1+Fs*firstCutsec:end,:);
    preprocessedData.timeStamp = ...
        preprocessedData.timeStamp(1+Fs*firstCutsec:end,:);
    %最初切り取られた最初を0秒として調整
    preprocessedData.timeStamp = ...
        preprocessedData.timeStamp - preprocessedData.timeStamp(1,1); 
end

if(clip)
    %savePath = "D:\kusunoki\PD3\Software\Data\EEG\2019\12\12\1655";
    
    %現在の日にちでフォルダを作成
    savePath = ...
        strcat(...
        "D:\kusunoki\PD3\Software\Data\EEG\", ...
        datestr(now,"yyyy\\mm\\dd\\HHMM") ...
        );
    %新規フォルダの作成
    for i = 1:size(validDataClasses,1)
        for j = 1:size(validDataClasses,2)
            mkdir(strcat(savePath,"\",validDataClasses{i,j}));
        end
    end
    
    clipData = preprocessedData;
    %データの分割
    [dataSets, labels] = f_clipDataSets(clipData);
    
    
    %MultiDisplayのときのc10~c80(アナウンスコマンド時)とc0(非表示コマンド時)のデータを連結 
    dataSets = dataSets; %置換用データ
    labels   = labels;   %置換用データ
    newDataSets = {}; %置換用データ
    newLabels   = {}; %置換用データ
    setCount = 1;
    nextContinue = false;
    for i = 1:size(labels,1)
        if(nextContinue)
            nextContinue = false;
            continue;
        end
        if labels{i,1} == 0
            %labels(i)が0のとき、次のデータと連結して新しい配列に代入
            newDataSets{setCount,1} = horzcat(dataSets{i,1}, dataSets{i+1,1});
            newLabels{setCount,1}  = 0;
            nextContinue = true;
        else
            newDataSets{setCount,1} = dataSets{i,1};
            newLabels{setCount,1}  = labels{i,1};
        end
        setCount = setCount + 1;
    end
    %連結後の配列を元の配列に再代入
    dataSets = newDataSets;
    labels   = newLabels;
    
    %ディレクトリツリーの探索・取得
    [~ , dirTree ] = f_getDirTree(savePath, struct);
    
    %ラベルの変換
    %数字だけだと構造体のkeyとして認識されないなど不具合も多いので、'1' --> 'c1'のように変換する
    for i = 1:length(labels)
        labels{i,1} = num2str(labels{i,1});
        labels{i,1} = strcat('c', labels{i,1});
    end
    %データの保存
    for i = 1:length(labels)
        dataSet = dataSets{i,1};
        temp = labels(i)
        temp = temp{1,1}
        [~ , dirTree ] = f_getDirTree(savePath, struct);
        Saver(dataSet, temp,  savePath, dirTree);
    end
end

if(load)
    trainDataPath = "D:\kusunoki\PD3\Software\Data\EEG\2019\12\13";
    %trainDataPath = strcat(...
    %    "D:\kusunoki\PD3\Software\Data\EEG\", ...
    %    datestr(now,"yyyy\\mm\\dd\\HHMM"));
    
    %%時系列信号のロード
    XSeque0 = {};
    YLabel0 = {};
    [XSeque0, YLabel0] = f_loadDataSets(trainDataPath);
    randIndex = randperm(size(YLabel0,1));
    
    XSeque1 = {}; %cell配列
    YLabel1 = {}; %データラベル配列
    for i = 1:length(randIndex)
        XSeque1{i,1} = XSeque0{randIndex(i),1};
        YLabel1{i,1} = YLabel0{randIndex(i),1};
    end
    
    %信号長の違うデータの除外
    usableDataIndex = [];
    for i = 1:size(XSeque1,1)
        thisSignalLen = size(XSeque1{i,1},2);%信号長
        if thisSignalLen == sampleLen
            usableDataIndex(end+1) = i;
        else
            fprintf('unusable data set [i = %d] (unexpected signal length)\n',i);
        end
    end
    
    XSeque2 = {}; %cell配列
    YLabel2 = {}; %データラベル配列
    
    for i = 1:length(usableDataIndex)
        XSeque2{i,1} = XSeque1{usableDataIndex(i),1};
        YLabel2{i,1} = YLabel1{usableDataIndex(i),1};
    end
    
    %ラベルのごとでデータ数を合わせる
    c0Index = [];
    c1Index = [];
    c2Index = [];
    for i = 1:size(YLabel2,1)
        %c1ラベルのインデックスを抽出
        if YLabel2{i,1} == categorical("c0")
            c0Index(end+1) = i;
        %c1ラベルのインデックスを抽出
        elseif YLabel2{i,1} == categorical("c1")
            c1Index(end+1) = i;
        %c1ラベルのインデックスを抽出
        elseif YLabel2{i,1} == categorical("c2")
            c2Index(end+1) = i;
        end
    end
    XSeque3 = {};
    YLabel3 = {};
    n = 0; %現在のラベル
    k = 1; %現在のインデックス
    dataNum = min([length(c0Index) ,length(c1Index),length(c2Index)]);
    for i = 1:dataNum*3
        if n == 0
            XSeque3{i,1} = XSeque2{c0Index(k),1};
            YLabel3{i,1} = YLabel2{c0Index(k),1};
        elseif n == 1
            XSeque3{i,1} = XSeque2{c1Index(k),1};
            YLabel3{i,1} = YLabel2{c1Index(k),1};
        elseif n == 2
            XSeque3{i,1} = XSeque2{c2Index(k),1};
            YLabel3{i,1} = YLabel2{c2Index(k),1};
            k = k + 1;
        end
        n = rem(n+1,3);%n = 0～3のどれか 
        
    end
    
    %%学習用データへの変換
    XFreqe = {}; %周波数変換後のデータ
    YCateg = {}; %categorical変換後のデータ
    
    
    %YTrainの変換 , cell配列 --> categorical配列に変換
    temp = string(YLabel3);%いったん文字列配列に変換
    YCateg = categorical(temp);%文字列配列をcategoricalへ

    %XTrainの変換 , 時系列信号 --> 振幅特性
    for i = 1:size(XSeque3,1)
        [XFreqe{i,1}, XDim,XLen] = ...
            f_signalConverter(XSeque3{i,1},Fs,cutFreqL,cutFreqH);
    end
    
    XTrain = {};
    XValid = {};
    sep = cast(size(XFreqe,1)*trainRate,'uint32'); %データを3/4で分割
    len = cast(size(XFreqe,1),'uint32');
    
    YTrain = YCateg(1:sep); %学習用データ y : 正解catetorical配列
    YValid = YCateg(sep+1 : end); %検証用データ y
    for i = 1:len
        if i <= sep
            XTrain{end+1, 1} = XFreqe{i, 1}; %学習用データ x : インプットcell配列
        else
            XValid{end+1, 1} = XFreqe{i, 1}; %検証用データ x
        end
    end
    
end

if(train)
    layers = [ ...
        sequenceInputLayer(XDim)
        bilstmLayer(512,'OutputMode','last')
        
        fullyConnectedLayer(512)
        fullyConnectedLayer(256)
        
        
        fullyConnectedLayer(3)
        softmaxLayer
        classificationLayer]
    maxEpochs = 50;
    miniBatchSize = 100;

    options = trainingOptions('adam', ...
        'ExecutionEnvironment','gpu', ...
        'GradientThreshold',1, ...
        'MaxEpochs',maxEpochs, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest', ...
        'Shuffle','once', ...
        'Verbose',0, ...
        'Plots','training-progress');
    TESTClassifierNet = trainNetwork(XTrain,YTrain,layers,options);
    
    save(strcat(pwd,'\Data\Networks\TESTClassifierNet.mat'),'TESTClassifierNet');
end

if(validation)
    %学習データの解析
    plotTrainAndValid;
    %学習結果の解析()confuion matrix
    calcConfusionMatrix;
end




function [] = Saver(val, saveLabel, saveDir, dirTree)
fieldNames = fieldnames(dirTree);

%ディレクトリの中のフォルダ名でループ
for i = 1:length(fieldNames)
    fieldName = fieldNames{i,1};
    
    if strcmp(fieldName , saveLabel)
        %save location directory --> saves .mat data
        filesNum = length(dirTree.(fieldName).files);
        dataPath = strcat(saveDir,'\', fieldName);
        fileName = strcat(saveLabel , '_', int2str(filesNum), '.mat');
        
        save(strcat(dataPath,'\', fileName), 'val');
        return
    elseif strcmp(fieldName, 'files')
        %there are files
    else
        %not save location directory --> search child directory
        Saver(val, saveLabel, strcat(saveDir,'\', fieldName), dirTree.(fieldName));
    end
    
end
end