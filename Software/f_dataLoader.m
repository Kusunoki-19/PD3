function[XTrain, YTrain, XDim] = f_dataLoader(dataPath)
dataPath = strcat(pwd,dataPath);
%%
%データのロード
signals = {}; %cell配列
labels = {}; %データラベル配列

XTrain = {}; %学習用データ x : インプットcell配列
YTrain = {}; %学習用データ y : 正解catetorical配列

%データのロード
[signals, labels] = f_dataReader(dataPath);

%cell配列を学習データ用にcategorical配列に変換
YTrain = f_cellListStrToCategorical(labels);

%EMGデータをFFTして学習用データに変換
dataDimention = size(signals{1,1},1);
for i = 1 : size(signals,1)
    [XTrain{i,1}, XDim] = f_signalConverter(signals{i,1} , dataDimention);
end
end