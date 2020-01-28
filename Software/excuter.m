%�e�p�����[�^�̐ݒ�
initialize = true;

%�ŏ��̐��b�̐؂���
preprocess = false;
if preprocess
    preprocessedData = out;
end

%�f�[�^�̕���
%���x���̕ϊ�
%�f�[�^�̕ۑ�
clip = false;

%���n��M���̃��[�h
%�M�����̈Ⴄ�f�[�^�̏��O
%���x���̂��ƂŃf�[�^�������킹��
%�w�K�p�f�[�^�ւ̕ϊ�
%YTrain�̕ϊ� , cell�z�� --> categorical�z��ɕϊ�
%XTrain�̕ϊ� , ���n��M�� --> �U������
%�f�[�^��3/4�ŕ����@
load = true;
experimental = 1;
if load
    if experimental == 1
        isMultiDisplay = false;
        trainDataPath = "D:\kusunoki\PD3\Software\Data\EEG\2019";
    elseif experimental == 2
        isMultiDisplay = true;
        trainDataPath = "D:\kusunoki\PD3\Software\Data\EEG\2020";
    end
end

%�f�[�^�̊w�K�ƃ��[�h
train = false;

%�w�K�f�[�^�̉��
%�w�K���ʂ̉��
validation = true;

if(initialize)
    LoadValiablesToWorkSpace;
end

if(preprocess)
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
    for i = 1:size(validClasses,1)
        for j = 1:size(validClasses,2)
            mkdir(strcat(savePath,"\",validClasses{i,j}));
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
            newLabels{setCount,1}  = labels{i+1,1};
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
    
    %���x���̕ϊ�
    %�����������ƍ\���̂�key�Ƃ��ĔF������Ȃ��ȂǕs��������̂ŁA'1' --> 'c1'�̂悤�ɕϊ�����
    for i = 1:length(labels)
        labels{i,1} = num2str(labels{i,1});
        labels{i,1} = strcat('c', labels{i,1});
    end
    %�f�[�^�̕ۑ�
    %�f�B���N�g���c���[�̒T���E�擾
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
    XDataForValidClass3 = {};
    YDataForValidClass3 = {};
    XDataForValidClass16 = {};
    YDataForValidClass16 = {};
    %trainDataPath = strcat(...
    %    "D:\kusunoki\PD3\Software\Data\EEG\", ...
    %    datestr(now,"yyyy\\mm\\dd\\HHMM"));
    
    XData = {};
    YData = {};
    XTemp = {};
    YTemp = {};
    
    %%���n��M���̃��[�h
    [XData, YData] = f_loadDataSets(trainDataPath);
    
    %�M�����̈Ⴄ�f�[�^�̏��O
    usableDataIndex = [];
    for i = d1List(XData)
        if d2Len(XData{i,1}) == sampleLen %�M�������r
            usableDataIndex(end+1) = i;
        else
            fprintf('unusable data set [i = %d] (unexpected signal length)\n',i);
        end
    end
    
    for i = dList(usableDataIndex)
        XTemp{i,1} = XData{usableDataIndex(i),1};
        YTemp{i,1} = YData{usableDataIndex(i),1};
    end
    
    XData = XTemp;
    YData = YTemp;
    XTemp = {};
    YTemp = {};
    
    %�w�K�p�f�[�^�ւ̕ϊ�
    %XTrain�̕ϊ� , ���n��M�� --> �U������
    for i = d1List(XData)
        %f_signalConverter --> �f�V�x���ϊ���̒l
        %[XTemp{i,1}, XDim,XLen] = ...
        %    f_signalConverter(XData{i,1},Fs,cutFreqL,cutFreqH);
        %f_signalConverter2 --> �f�V�x���ϊ��O�̒l
        [XTemp{i,1}, XDim,XLen] = ...
            f_signalConverter2(XData{i,1},Fs,cutFreqL,cutFreqH);
    end
    
    XData = XTemp;
    XTemp = {};
    
    XDataForValidClass16 = XData; %�e�M�������؂��邽�߂Ƀf�[�^��ۑ����Ă���
    YDataForValidClass16 = YData; %�e�M�������؂��邽�߂Ƀf�[�^��ۑ����Ă���
    
    if (isMultiDisplay)
        %���ؗp�����̃��x�����w�K�p�����̃��x���ɕϊ�
        YTemp = YData;    
        for i = d1List(YData)
            if isStrMatchInCell(YTemp{i,1}, ...
                    {'c10','c20','c30','c40','c50','c60','c70','c80'})
                 %���x����c10�`80�̂Ƃ�c0�ɕϊ�
                 YTemp{i,1} = 'c0';

            elseif isStrMatchInCell(YTemp{i,1},{'c1','c2','c4','c5'})
                 %���x����c1,2,4,5�̂Ƃ�c1(�{�[��)�ɕϊ�
                 YTemp{i,1} = 'c1';

            elseif isStrMatchInCell(YTemp{i,1}, {'c3','c6','c7','c8'})
                 %���x����c3,6,7,8�̂Ƃ�c2(�X�e�B�b�N)�ɕϊ�
                 YTemp{i,1} = 'c2';

            else
                 YTemp{i,1} = 'cx'; %�ǂ�ɂ����Ă͂܂�Ȃ������䃉�x��
            end
        end
        YData = YTemp;
        YTemp = {};
    end
    
    XDataForValidClass3 = XData; %�e�M�������؂��邽�߂Ƀf�[�^��ۑ����Ă���
    YDataForValidClass3 = YData; %�e�M�������؂��邽�߂Ƀf�[�^��ۑ����Ă���
    
    %���x���̂��ƂŃf�[�^�������킹��
    %�e���x���̃C���f�b�N�X���o
    categoryIndexes = struct; %index���i�[����\���̍쐬
    for i = trainClasses(1,:)
        categoryIndex = [];
        for j = d1List(YData)
            if i{1,1} == YData{j,1}
                categoryIndex(end+1) = j;
            end
        end
        categoryIndexes = setfield(categoryIndexes, i{1,1}, categoryIndex);
    end
    
    minLen = 0;
    for fieldName = fieldList(categoryIndexes)
        indexLen = length(getfield(categoryIndexes, fieldName));
        if minLen == 0
            minLen = indexLen;
        elseif indexLen < minLen
            minLen = indexLen;
        end
    end
    for fieldName = fieldList(categoryIndexes)
        categoryIndex = getfield(categoryIndexes,fieldName);
        XTemp(end+1:end+minLen, 1) = XData(categoryIndex(1:minLen), 1); 
        YTemp(end+1:end+minLen, 1) = YData(categoryIndex(1:minLen), 1);        
    end
    XData = XTemp;
    YData = YTemp;
    XTemp = {};
    YTemp = {};
    
    %�M���̃V���b�t��
    randIndex = randperm(size(YData,1));
    for i = 1:length(randIndex)
        XTemp{i,1} = XData{randIndex(i),1};
        YTemp{i,1} = YData{randIndex(i),1};
    end
    XData = XTemp;
    YData = YTemp;
    XTemp = {};
    YTemp = {};
    
    
    %YTrain�̕ϊ� , cell�z�� --> categorical�z��ɕϊ�
    temp = string(YData);%�������񕶎���z��ɕϊ�
    YTemp = categorical(temp);%������z���categorical��

    YData = YTemp;
    YTemp = {};
    
    %�f�[�^��trainRate�̊����ŕ���
    sep = cast(d1Len(XData)*trainRate,'uint32'); 
    XTrain = {};
    YTrain = {};
    XValid = {};
    YValid = {};
    
    XTrain = XData(1:sep); %�w�K�p�f�[�^ x : �������g���z��
    YTrain = YData(1:sep); %�w�K�p�f�[�^ y : ����catetorical�z��
    XValid = XData(sep+1 : end); %���ؗp�f�[�^ x
    YValid = YData(sep+1 : end); %���ؗp�f�[�^ y
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
    %�w�K���ʂ̉��()confuion matrix
    calcConfusionMatrix;
end

if(validation)
    %�w�K�f�[�^�̉��
    class3CalcAvg;
    figure;
    class3PlotAvg;
    %figure;
    %class3PlotDiff;
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