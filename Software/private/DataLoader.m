function[XTrain, YTrain, XDim] = DataLoader(dataPath)
%F_DATALOADER �f�[�^�̓ǂݍ���
%   dataPath , string , �f�[�^�̐�΃p�X
%%
%{ 
dataLoader�̊O�Ɉړ]
%�f�[�^�̃��[�h
signals = {}; %cell�z��
labels = {}; %�f�[�^���x���z��

XTrain = {}; %�w�K�p�f�[�^ x : �C���v�b�gcell�z��
YTrain = {}; %�w�K�p�f�[�^ y : ����catetorical�z��

%expectedSignalLen = 1000;

%�f�[�^�̃��[�h
[signals, labels] = f_loadDataSets(dataPath);

%cell�z����w�K�f�[�^�p��categorical�z��ɕϊ�
temp = string(labels);%�������񕶎���z��ɕϊ�
YTrain = categorical(temp);%������z���categorical��

%EMG�f�[�^��FFT���Ċw�K�p�f�[�^�ɕϊ�
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