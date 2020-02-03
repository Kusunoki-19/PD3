logi = struct;
%処理分岐
logi.initialize = true;
logi.preprocess = true;
logi.clip       = true;
logi.load       = false;
logi.train      = false;
logi.validation = false;

if(logi.initialize)
    [f, p] = LoadValiables;
    p.xfreqencies = CalcFFTFreqencies(p);
end

if(logi.preprocess)
    preData = out;
    %最初の数秒を切り取り
    %切り取り秒
    preData.label     =     preData.label(1+ p.Fs* p.firstCutsec:end,:);
    preData.rawEEG    =    preData.rawEEG(1+ p.Fs* p.firstCutsec:end,:);
    preData.timeStamp = preData.timeStamp(1+ p.Fs* p.firstCutsec:end,:);
    %最初切り取られた最初を0秒として調整
    preData.timeStamp = preData.timeStamp - preData.timeStamp(1,1); 
    handlingData = preData;
    
    %一時的なデータの削除
    clearvars preData;
end

if(logi.clip)
    
    %新規フォルダの作成
    for i = 1:size(p.validClasses,1)
        for j = 1:size(p.validClasses,2)
            mkdir(strcat(p.savePath,"\",p.validClasses{i,j}));
        end
    end
    
    
    %データの分割
    [dataSets, labels] = ClipDataSets(handlingData);
    
    if p.experiNum == 2
        %MultiDisplayのときのc10~c80(アナウンスコマンド時)とc0(非表示コマンド時)のデータを連結 
        tempDataSets = dataSets; %置換用データ
        tempLabels   = labels;   %置換用データ
        newDataSets = {}; %置換用データ
        newLabels   = {}; %置換用データ
        setCount = 1;
        nextContinue = false;
        for i = 1:size(tempLabels,1)
            if(nextContinue)
                nextContinue = false;
                continue;
            end
            if tempLabels{i,1} == 0
                %labels(i)が0のとき、次のデータと連結して新しい配列に代入
                newDataSets{setCount,1} = horzcat(newDataSets{i,1}, newDataSets{i+1,1});
                newLabels{setCount,1}  = tempLabels{i+1,1};
                nextContinue = true;
            else
                newDataSets{setCount,1} = newDataSets{i,1};
                newLabels{setCount,1}  = tempLabels{i,1};
            end
            setCount = setCount + 1;
            
        end
        %連結後の配列を元の配列に再代入
        dataSets = newDataSets;
        labels   = newLabels;
        
        %一時的なデータの削除
        clearvars tempDataSets tempLabels newDataSets newLabels setCount nextContinue;
    end
    
    %ラベルの変換
    %数字だけだと構造体のkeyとして認識されないなど不具合も多いので、'1' --> 'c1'のように変換する
    for i = 1:length(labels)
        labels{i,1} = num2str(labels{i,1});
        labels{i,1} = strcat('c', labels{i,1});
    end
    %データの保存
    %ディレクトリツリーの探索・取得
    [~ , dirTree ] = GetDirTree(p.savePath, struct);
    for i = 1:length(labels)
        dataSet = dataSets{i,1};
        temp = labels(i)
        temp = temp{1,1}
        [~ , dirTree ] = GetDirTree(p.savePath, struct);
        Saver(dataSet, temp,  p.savePath, dirTree);
    end
    
    
    %一時的なデータの削除
    clearvars handleData temp;
end

if(logi.load)
    %trainDataPath = strcat(...
    %    "D:\kusunoki\PD3\Software\Data\EEG\", ...
    %    datestr(now,"yyyy\\mm\\dd\\HHMM"));
    
    XData = {};
    XTemp = {};
    YData = {};
    YTemp = {};
    
    %時系列信号のロード
    [XData, YData] = LoadDataSets( p.trainDataPath);
    
    %信号長の違うデータの除外
    usableDataIndex = [];
    for i = f.d1List(XData)
        if f.d2Len(XData{i,1}) ==  p.sampleLen %信号長を比較
            usableDataIndex(end+1) = i;
        else
            fprintf('unusable data set [i = %d] (unexpected signal length)\n',i);
        end
    end
    
    for i = f.dList(usableDataIndex)
        XTemp{i,1} = XData{usableDataIndex(i),1};
        YTemp{i,1} = YData{usableDataIndex(i),1};
    end
    
    XData = XTemp; 
    XTemp = {}; 
    YData = YTemp; 
    YTemp = {};
    
    
    %学習用データへの変換
    %XTrainの変換 , 時系列信号 --> 振幅特性
    for i = f.d1List(XData)
        %f_signalConverter --> デシベル変換後の値
        %[XTemp{i,1}, XDim,XLen] = ...
        %    f_signalConverter(XData{i,1},Fs, param.cutFreqL, param.cutFreqH);
        %f_signalConverter2 --> デシベル変換前の値
        [XTemp{i,1}, p.XDim,p.XLen] = ...
            SignalConverter2(XData{i,1}, p.Fs, p.cutFreqL, p.cutFreqH);
    end
    
    XData = XTemp; 
    XTemp = {}; 
    
    %16Classのときの検証用データ
    if logi.validation && ( p.experiNum == 2)
        figure;
        YAvg = Class16CalcAvg(XData, YData, f, p);
        Class16PlotAvg(YAvg, f, p);
    end
    
    
    %検証用分割のラベルを学習用分割のラベルに変換
    if  p.experiNum == 2
        YTemp = YData;    
        for i = f.d1List(YData)
            if f.isStrMatchInCell(YTemp{i,1}, ...
                    {'c10','c20','c30','c40','c50','c60','c70','c80'})
                 %ラベルがc10～80のときc0に変換
                 YTemp{i,1} = 'c0';

            elseif f.isStrMatchInCell(YTemp{i,1},{'c1','c2','c4','c5'})
                 %ラベルがc1,2,4,5のときc1(ボール)に変換
                 YTemp{i,1} = 'c1';

            elseif f.isStrMatchInCell(YTemp{i,1}, {'c3','c6','c7','c8'})
                 %ラベルがc3,6,7,8のときc2(スティック)に変換
                 YTemp{i,1} = 'c2';

            else
                 YTemp{i,1} = 'cx'; %どれにも当てはまらなかった謎ラベル
            end
        end
    
        YData = YTemp; 
        YTemp = {};
    end
    
    %3Classのときの検証用データ
    if logi.validation && (( p.experiNum == 1) || ( p.experiNum == 2))
        figure;
        YAvg = Class3CalcAvg(XData, YData, f, p);
        Class3PlotAvg(YAvg, f, p);
    end    
    
    %ラベルのごとでデータ数を合わせる
    %各ラベルのインデックス抽出
    categoryIndexes = struct; %indexを格納する構造体作成
    for i = p.trainClasses(1,:)
        categoryIndex = [];
        for j = f.d1List(YData)
            if i{1,1} == YData{j,1}
                categoryIndex(end+1) = j;
            end
        end
        categoryIndexes = setfield(categoryIndexes, i{1,1}, categoryIndex);
    end
    
    minLen = 0;
    for fieldName = f.fieldList(categoryIndexes)
        indexLen = length(getfield(categoryIndexes, fieldName));
        if minLen == 0
            minLen = indexLen;
        elseif indexLen < minLen
            minLen = indexLen;
        end
    end
    for fieldName = f.fieldList(categoryIndexes)
        categoryIndex = getfield(categoryIndexes,fieldName);
        XTemp(end+1:end+minLen, 1) = XData(categoryIndex(1:minLen), 1); 
        YTemp(end+1:end+minLen, 1) = YData(categoryIndex(1:minLen), 1);        
    end
    
    XData = XTemp; 
    XTemp = {}; 
    YData = YTemp; 
    YTemp = {};
    
    %信号のシャッフル
    randIndex = randperm(size(YData,1));
    for i = 1:length(randIndex)
        XTemp{i,1} = XData{randIndex(i),1};
        YTemp{i,1} = YData{randIndex(i),1};
    end
    
    XData = XTemp; 
    XTemp = {}; 
    YData = YTemp; 
    YTemp = {};
    
    %YTrainの変換 , cell配列 --> categorical配列に変換
    temp = string(YData);%いったん文字列配列に変換
    YTemp = categorical(temp);%文字列配列をcategoricalへ
    
    YData = YTemp; 
    YTemp = {};
    
    
    %データをtrainRateの割合で分割
    sep = cast(f.d1Len(XData)*p.trainRate,'uint32'); 
    XTrain = {};
    YTrain = {};
    XValid = {};
    YValid = {};
    
    XTrain = XData(1:sep); %学習用データ x : 正解周波数配列
    YTrain = YData(1:sep); %学習用データ y : 正解catetorical配列
    XValid = XData(sep+1 : end); %検証用データ x
    YValid = YData(sep+1 : end); %検証用データ y
    
    
    %一時的なデータの削除
    clearvars XTemp YTemp usableDataIndex minLen randIndex indexLen;
end

if(logi.train)
    layers = [ ...
        sequenceInputLayer(p.XDim)
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
    %学習結果の解析()confuion matrix
    if logi.validation
        figure;
        calcConfusionMatrix;
    end
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