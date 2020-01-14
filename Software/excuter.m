%�e�p�����[�^�̐ݒ�
initialize = true;

%�ŏ��̐��b�̐؂���
preprocess = true;

%�f�[�^�̕���
%���x���̕ϊ�
%�f�[�^�̕ۑ�
clip = true;

%���n��M���̃��[�h
%�M�����̈Ⴄ�f�[�^�̏��O
%���x���̂��ƂŃf�[�^�������킹��
%�w�K�p�f�[�^�ւ̕ϊ�
%YTrain�̕ϊ� , cell�z�� --> categorical�z��ɕϊ�
%XTrain�̕ϊ� , ���n��M�� --> �U������
%�f�[�^��3/4�ŕ����@
load = false;

%�f�[�^�̊w�K�ƃ��[�h
train = false;

%�w�K�f�[�^�̉��
%�w�K���ʂ̉��
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
    %�ŏ��̐��b��؂���
    %�؂���b
    preprocessedData.label     = ...
        preprocessedData.label(1+Fs*firstCutsec:end,:);
    preprocessedData.rawEEG    = ...
        preprocessedData.rawEEG(1+Fs*firstCutsec:end,:);
    preprocessedData.timeStamp = ...
        preprocessedData.timeStamp(1+Fs*firstCutsec:end,:);
    %�ŏ��؂���ꂽ�ŏ���0�b�Ƃ��Ē���
    preprocessedData.timeStamp = ...
        preprocessedData.timeStamp - preprocessedData.timeStamp(1,1); 
end

if(clip)
    %savePath = "D:\kusunoki\PD3\Software\Data\EEG\2019\12\12\1655";
    
    %���݂̓��ɂ��Ńt�H���_���쐬
    savePath = ...
        strcat(...
        "D:\kusunoki\PD3\Software\Data\EEG\", ...
        datestr(now,"yyyy\\mm\\dd\\HHMM") ...
        );
    %�V�K�t�H���_�̍쐬
    for i = 1:size(validDataClasses,1)
        for j = 1:size(validDataClasses,2)
            mkdir(strcat(savePath,"\",validDataClasses{i,j}));
        end
    end
    
    clipData = preprocessedData;
    %�f�[�^�̕���
    [dataSets, labels] = f_clipDataSets(clipData);
    
    
    %MultiDisplay�̂Ƃ���c10~c80(�A�i�E���X�R�}���h��)��c0(��\���R�}���h��)�̃f�[�^��A�� 
    dataSets = dataSets; %�u���p�f�[�^
    labels   = labels;   %�u���p�f�[�^
    newDataSets = {}; %�u���p�f�[�^
    newLabels   = {}; %�u���p�f�[�^
    setCount = 1;
    nextContinue = false;
    for i = 1:size(labels,1)
        if(nextContinue)
            nextContinue = false;
            continue;
        end
        if labels{i,1} == 0
            %labels(i)��0�̂Ƃ��A���̃f�[�^�ƘA�����ĐV�����z��ɑ��
            newDataSets{setCount,1} = horzcat(dataSets{i,1}, dataSets{i+1,1});
            newLabels{setCount,1}  = 0;
            nextContinue = true;
        else
            newDataSets{setCount,1} = dataSets{i,1};
            newLabels{setCount,1}  = labels{i,1};
        end
        setCount = setCount + 1;
    end
    %�A����̔z������̔z��ɍđ��
    dataSets = newDataSets;
    labels   = newLabels;
    
    %�f�B���N�g���c���[�̒T���E�擾
    [~ , dirTree ] = f_getDirTree(savePath, struct);
    
    %���x���̕ϊ�
    %�����������ƍ\���̂�key�Ƃ��ĔF������Ȃ��ȂǕs��������̂ŁA'1' --> 'c1'�̂悤�ɕϊ�����
    for i = 1:length(labels)
        labels{i,1} = num2str(labels{i,1});
        labels{i,1} = strcat('c', labels{i,1});
    end
    %�f�[�^�̕ۑ�
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
    
    %%���n��M���̃��[�h
    XSeque0 = {};
    YLabel0 = {};
    [XSeque0, YLabel0] = f_loadDataSets(trainDataPath);
    randIndex = randperm(size(YLabel0,1));
    
    XSeque1 = {}; %cell�z��
    YLabel1 = {}; %�f�[�^���x���z��
    for i = 1:length(randIndex)
        XSeque1{i,1} = XSeque0{randIndex(i),1};
        YLabel1{i,1} = YLabel0{randIndex(i),1};
    end
    
    %�M�����̈Ⴄ�f�[�^�̏��O
    usableDataIndex = [];
    for i = 1:size(XSeque1,1)
        thisSignalLen = size(XSeque1{i,1},2);%�M����
        if thisSignalLen == sampleLen
            usableDataIndex(end+1) = i;
        else
            fprintf('unusable data set [i = %d] (unexpected signal length)\n',i);
        end
    end
    
    XSeque2 = {}; %cell�z��
    YLabel2 = {}; %�f�[�^���x���z��
    
    for i = 1:length(usableDataIndex)
        XSeque2{i,1} = XSeque1{usableDataIndex(i),1};
        YLabel2{i,1} = YLabel1{usableDataIndex(i),1};
    end
    
    %���x���̂��ƂŃf�[�^�������킹��
    c0Index = [];
    c1Index = [];
    c2Index = [];
    for i = 1:size(YLabel2,1)
        %c1���x���̃C���f�b�N�X�𒊏o
        if YLabel2{i,1} == categorical("c0")
            c0Index(end+1) = i;
        %c1���x���̃C���f�b�N�X�𒊏o
        elseif YLabel2{i,1} == categorical("c1")
            c1Index(end+1) = i;
        %c1���x���̃C���f�b�N�X�𒊏o
        elseif YLabel2{i,1} == categorical("c2")
            c2Index(end+1) = i;
        end
    end
    XSeque3 = {};
    YLabel3 = {};
    n = 0; %���݂̃��x��
    k = 1; %���݂̃C���f�b�N�X
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
        n = rem(n+1,3);%n = 0�`3�̂ǂꂩ 
        
    end
    
    %%�w�K�p�f�[�^�ւ̕ϊ�
    XFreqe = {}; %���g���ϊ���̃f�[�^
    YCateg = {}; %categorical�ϊ���̃f�[�^
    
    
    %YTrain�̕ϊ� , cell�z�� --> categorical�z��ɕϊ�
    temp = string(YLabel3);%�������񕶎���z��ɕϊ�
    YCateg = categorical(temp);%������z���categorical��

    %XTrain�̕ϊ� , ���n��M�� --> �U������
    for i = 1:size(XSeque3,1)
        [XFreqe{i,1}, XDim,XLen] = ...
            f_signalConverter(XSeque3{i,1},Fs,cutFreqL,cutFreqH);
    end
    
    XTrain = {};
    XValid = {};
    sep = cast(size(XFreqe,1)*trainRate,'uint32'); %�f�[�^��3/4�ŕ���
    len = cast(size(XFreqe,1),'uint32');
    
    YTrain = YCateg(1:sep); %�w�K�p�f�[�^ y : ����catetorical�z��
    YValid = YCateg(sep+1 : end); %���ؗp�f�[�^ y
    for i = 1:len
        if i <= sep
            XTrain{end+1, 1} = XFreqe{i, 1}; %�w�K�p�f�[�^ x : �C���v�b�gcell�z��
        else
            XValid{end+1, 1} = XFreqe{i, 1}; %���ؗp�f�[�^ x
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
    %�w�K�f�[�^�̉��
    plotTrainAndValid;
    %�w�K���ʂ̉��()confuion matrix
    calcConfusionMatrix;
end




function [] = Saver(val, saveLabel, saveDir, dirTree)
fieldNames = fieldnames(dirTree);

%�f�B���N�g���̒��̃t�H���_���Ń��[�v
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