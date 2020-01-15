%各パラメータの設定
initialize = true;

%最初の数秒の切り取り
preprocess = false;

%データの分割
%ラベルの変換
%データの保存
clip = false;

%時系列信号のロード
%信号長の違うデータの除外
%ラベルのごとでデータ数を合わせる
%学習用データへの変換
%YTrainの変換 , cell配列 --> categorical配列に変換
%XTrainの変換 , 時系列信号 --> 振幅特性
%データを3/4で分割　
load = true;

%データの学習とロード
train = false;

%学習データの解析
%学習結果の解析
validation = false;

%1次元配列のインデックスリスト取り出し用の無名関数の関数ハンドル
dList = @(list) 1:length(list);
%多次元配列の1,2次元のインデックスリスト取り出し用の無名関数の関数ハンドル
d1List = @(Matrix) 1:size(Matrix,1);
d2List = @(Matrix) 1:size(Matrix,2);
%多次元配列の1,2次元の長さ取り出し用の無名関数の関数ハンドル
d1Len = @(Matrix) size(Matrix,1);
d2Len = @(Matrix) size(Matrix,2);
%比較用無名関数の関数ハンドル
isStrMatchInCell = @(str, cellStr) any(strcmp(str,cellStr),'all');

if(initialize)
    Fs = 1000;
    sampleTime = 5;
    sampleLen = Fs * sampleTime;
    channelNum = 8;
    
    isMultiDisplay = true;
    
    trainClasses = {"c0","c1","c2"}; %ball, stick, none : c1 c2 c0
    validClasses = { ...
        "c1" ,"c2" ,"c3" ,"c4" ,"c5" ,"c6" ,"c7" ,"c8" , ...
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
    for i = 1:size(validClasses,1)
        for j = 1:size(validClasses,2)
            mkdir(strcat(savePath,"\",validClasses{i,j}));
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
            newLabels{setCount,1}  = labels{i+1,1};
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
    
    
    %ラベルの変換
    %数字だけだと構造体のkeyとして認識されないなど不具合も多いので、'1' --> 'c1'のように変換する
    for i = 1:length(labels)
        labels{i,1} = num2str(labels{i,1});
        labels{i,1} = strcat('c', labels{i,1});
    end
    %データの保存
    %ディレクトリツリーの探索・取得
    [~ , dirTree ] = f_getDirTree(savePath, struct);
    for i = 1:length(labels)
        dataSet = dataSets{i,1};
        temp = labels(i)
        temp = temp{1,1}
        [~ , dirTree ] = f_getDirTree(savePath, struct);
        Saver(dataSet, temp,  savePath, dirTree);
    end
end

if(load)
    trainDataPath = "D:\kusunoki\PD3\Software\Data\EEG\2020\01\14\1213";
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
    %信号のシャッフル
    for i = 1:length(randIndex)
        XSeque1{i,1} = XSeque0{randIndex(i),1};
        YLabel1{i,1} = YLabel0{randIndex(i),1};
    end
    
    
    
    %信号長の違うデータの除外
    usableDataIndex = [];
    for i = d1List(XSeque1)
        if d2Len(XSeque1{i,1}) == sampleLen %信号長を比較
            usableDataIndex(end+1) = i;
        else
            fprintf('unusable data set [i = %d] (unexpected signal length)\n',i);
        end
    end
    
    XSeque2 = {}; %cell配列
    YLabel2 = {}; %データラベル配列
    
    for i = dList(usableDataIndex)
        XSeque2{i,1} = XSeque1{usableDataIndex(i),1};
        YLabel2{i,1} = YLabel1{usableDataIndex(i),1};
    end
    
    %検証用分割のデータを学習用分割のデータ型に変換
    tempLabels = YLabel2;    
    
    for i = d1List(YLabel2)
        if isStrMatchInCell(tempLabels{i,1}, ...
                {'c10','c20','c30','c40','c50','c60','c70','c80'})
             %ラベルがc10〜80のときc0に変換
             tempLabels{i,1} = 'c0';
             
        elseif isStrMatchInCell(tempLabels{i,1},{'c1','c2','c4','c5'})
             %ラベルがc1,2,4,5のときc1(ボール)に変換
             tempLabels{i,1} = 'c1';
             
        elseif isStrMatchInCell(tempLabels{i,1}, {'c3','c6','c7','c8'})
             %ラベルがc3,6,7,8のときc2(スティック)に変換
             tempLabels{i,1} = 'c2';
             
        else
             tempLabels{i,1} = 'cx'; %どれにも当てはまらなかった謎ラベル
        end
    end
    YLabel2 = tempLabels;
    
    %ラベルのごとでデータ数を合わせる
    %各ラベルのインデックス抽出
    categoryIndexes = struct; %indexを格納する構造体作成
    categoryIndex = [];
    for i = validClasses(1,:)
        for j = d1List(YLabel2)
            if YLabel2{j,1} == i
                categoryIndex(end+1) = j;
            end
        end
        categoryIndexes = setfield(categoryIndexes, i{1,1}, categoryIndex);
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
        n = rem(n+1,3);%n = 0〜3のどれか 
        
    end
    
    %%学習用データへの変換
    XFreqe = {}; %周波数変換後のデータ
    YCateg = {}; %categorical変換後のデータ
    
    
    %YTrainの変換 , cell配列 --> categorical配列に変換
    temp = string(YLabel3);%いったん文字列配列に変換
    YCateg = categorical(temp);%文字列配列をcategoricalへ

    %XTrainの変換 , 時系列信号 --> 振幅特性
    for i = d1List(XSeque3)
        [XFreqe{i,1}, XDim,XLen] = ...
            f_signalConverter(XSeque3{i,1},Fs,cutFreqL,cutFreqH);
    end
    
    XTrain = {};
    XValid = {};
    sep = cast(d1Len(XFreqe,1)*trainRate,'uint32'); %データを3/4で分割
    
    YTrain = YCateg(1:sep); %学習用データ y : 正解catetorical配列
    YValid = YCateg(sep+1 : end); %検証用データ y
    for i = d1List(XFreqe)
        if i <= trainRate * sep
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