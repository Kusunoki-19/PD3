function[XTrain, YTrain, XDim] = f_dataLoader(dataPath)
dataPath = strcat(pwd,dataPath);
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
    [XTrain{i,1}, XDim] = f_signalConverter(signals{i,1} , dataDimention);
end
end