function[XTrain, YTrain, XDim] = DataLoader(dataPath)
%F_DATALOADER データの読み込み
%   dataPath , string , データの絶対パス
%%
%{ 
dataLoaderの外に移転
%データのロード
signals = {}; %cell配列
labels = {}; %データラベル配列

XTrain = {}; %学習用データ x : インプットcell配列
YTrain = {}; %学習用データ y : 正解catetorical配列

%expectedSignalLen = 1000;

%データのロード
[signals, labels] = f_loadDataSets(dataPath);

%cell配列を学習データ用にcategorical配列に変換
temp = string(labels);%いったん文字列配列に変換
YTrain = categorical(temp);%文字列配列をcategoricalへ

%EMGデータをFFTして学習用データに変換
dataDimention = size(signals{1,1},1);
for i = 1 : size(signals,1)
    signalLen = size(signals{i,1},2);
    if signalLen ~= expectedSignalLen;
        continue;
    end
    [XTrain{i,1}, XDim] = f_signalConverter(signals{i,1} , dataDimention);
end
%}
%XTrain = signals;
%XDim = dataDimention;
end