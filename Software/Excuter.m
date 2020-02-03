logi = struct;
%��������
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
    %�ŏ��̐��b��؂���
    %�؂���b
    preData.label     =     preData.label(1+ p.Fs* p.firstCutsec:end,:);
    preData.rawEEG    =    preData.rawEEG(1+ p.Fs* p.firstCutsec:end,:);
    preData.timeStamp = preData.timeStamp(1+ p.Fs* p.firstCutsec:end,:);
    %�ŏ��؂���ꂽ�ŏ���0�b�Ƃ��Ē���
    preData.timeStamp = preData.timeStamp - preData.timeStamp(1,1); 
    handlingData = preData;
    
    %�ꎞ�I�ȃf�[�^�̍폜
    clearvars preData;
end

if(logi.clip)
    
    %�V�K�t�H���_�̍쐬
    for i = 1:size(p.validClasses,1)
        for j = 1:size(p.validClasses,2)
            mkdir(strcat(p.savePath,"\",p.validClasses{i,j}));
        end
    end
    
    
    %�f�[�^�̕���
    [dataSets, labels] = ClipDataSets(handlingData);
    
    if p.experiNum == 2
        %MultiDisplay�̂Ƃ���c10~c80(�A�i�E���X�R�}���h��)��c0(��\���R�}���h��)�̃f�[�^��A�� 
        tempDataSets = dataSets; %�u���p�f�[�^
        tempLabels   = labels;   %�u���p�f�[�^
        newDataSets = {}; %�u���p�f�[�^
        newLabels   = {}; %�u���p�f�[�^
        setCount = 1;
        nextContinue = false;
        for i = 1:size(tempLabels,1)
            if(nextContinue)
                nextContinue = false;
                continue;
            end
            if tempLabels{i,1} == 0
                %labels(i)��0�̂Ƃ��A���̃f�[�^�ƘA�����ĐV�����z��ɑ��
                newDataSets{setCount,1} = horzcat(newDataSets{i,1}, newDataSets{i+1,1});
                newLabels{setCount,1}  = tempLabels{i+1,1};
                nextContinue = true;
            else
                newDataSets{setCount,1} = newDataSets{i,1};
                newLabels{setCount,1}  = tempLabels{i,1};
            end
            setCount = setCount + 1;
            
        end
        %�A����̔z������̔z��ɍđ��
        dataSets = newDataSets;
        labels   = newLabels;
        
        %�ꎞ�I�ȃf�[�^�̍폜
        clearvars tempDataSets tempLabels newDataSets newLabels setCount nextContinue;
    end
    
    %���x���̕ϊ�
    %�����������ƍ\���̂�key�Ƃ��ĔF������Ȃ��ȂǕs��������̂ŁA'1' --> 'c1'�̂悤�ɕϊ�����
    for i = 1:length(labels)
        labels{i,1} = num2str(labels{i,1});
        labels{i,1} = strcat('c', labels{i,1});
    end
    %�f�[�^�̕ۑ�
    %�f�B���N�g���c���[�̒T���E�擾
    [~ , dirTree ] = GetDirTree(p.savePath, struct);
    for i = 1:length(labels)
        dataSet = dataSets{i,1};
        temp = labels(i)
        temp = temp{1,1}
        [~ , dirTree ] = GetDirTree(p.savePath, struct);
        Saver(dataSet, temp,  p.savePath, dirTree);
    end
    
    
    %�ꎞ�I�ȃf�[�^�̍폜
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
    
    %���n��M���̃��[�h
    [XData, YData] = LoadDataSets( p.trainDataPath);
    
    %�M�����̈Ⴄ�f�[�^�̏��O
    usableDataIndex = [];
    for i = f.d1List(XData)
        if f.d2Len(XData{i,1}) ==  p.sampleLen %�M�������r
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
    
    
    %�w�K�p�f�[�^�ւ̕ϊ�
    %XTrain�̕ϊ� , ���n��M�� --> �U������
    for i = f.d1List(XData)
        %f_signalConverter --> �f�V�x���ϊ���̒l
        %[XTemp{i,1}, XDim,XLen] = ...
        %    f_signalConverter(XData{i,1},Fs, param.cutFreqL, param.cutFreqH);
        %f_signalConverter2 --> �f�V�x���ϊ��O�̒l
        [XTemp{i,1}, p.XDim,p.XLen] = ...
            SignalConverter2(XData{i,1}, p.Fs, p.cutFreqL, p.cutFreqH);
    end
    
    XData = XTemp; 
    XTemp = {}; 
    
    %16Class�̂Ƃ��̌��ؗp�f�[�^
    if logi.validation && ( p.experiNum == 2)
        figure;
        YAvg = Class16CalcAvg(XData, YData, f, p);
        Class16PlotAvg(YAvg, f, p);
    end
    
    
    %���ؗp�����̃��x�����w�K�p�����̃��x���ɕϊ�
    if  p.experiNum == 2
        YTemp = YData;    
        for i = f.d1List(YData)
            if f.isStrMatchInCell(YTemp{i,1}, ...
                    {'c10','c20','c30','c40','c50','c60','c70','c80'})
                 %���x����c10�`80�̂Ƃ�c0�ɕϊ�
                 YTemp{i,1} = 'c0';

            elseif f.isStrMatchInCell(YTemp{i,1},{'c1','c2','c4','c5'})
                 %���x����c1,2,4,5�̂Ƃ�c1(�{�[��)�ɕϊ�
                 YTemp{i,1} = 'c1';

            elseif f.isStrMatchInCell(YTemp{i,1}, {'c3','c6','c7','c8'})
                 %���x����c3,6,7,8�̂Ƃ�c2(�X�e�B�b�N)�ɕϊ�
                 YTemp{i,1} = 'c2';

            else
                 YTemp{i,1} = 'cx'; %�ǂ�ɂ����Ă͂܂�Ȃ������䃉�x��
            end
        end
    
        YData = YTemp; 
        YTemp = {};
    end
    
    %3Class�̂Ƃ��̌��ؗp�f�[�^
    if logi.validation && (( p.experiNum == 1) || ( p.experiNum == 2))
        figure;
        YAvg = Class3CalcAvg(XData, YData, f, p);
        Class3PlotAvg(YAvg, f, p);
    end    
    
    %���x���̂��ƂŃf�[�^�������킹��
    %�e���x���̃C���f�b�N�X���o
    categoryIndexes = struct; %index���i�[����\���̍쐬
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
    
    %�M���̃V���b�t��
    randIndex = randperm(size(YData,1));
    for i = 1:length(randIndex)
        XTemp{i,1} = XData{randIndex(i),1};
        YTemp{i,1} = YData{randIndex(i),1};
    end
    
    XData = XTemp; 
    XTemp = {}; 
    YData = YTemp; 
    YTemp = {};
    
    %YTrain�̕ϊ� , cell�z�� --> categorical�z��ɕϊ�
    temp = string(YData);%�������񕶎���z��ɕϊ�
    YTemp = categorical(temp);%������z���categorical��
    
    YData = YTemp; 
    YTemp = {};
    
    
    %�f�[�^��trainRate�̊����ŕ���
    sep = cast(f.d1Len(XData)*p.trainRate,'uint32'); 
    XTrain = {};
    YTrain = {};
    XValid = {};
    YValid = {};
    
    XTrain = XData(1:sep); %�w�K�p�f�[�^ x : �������g���z��
    YTrain = YData(1:sep); %�w�K�p�f�[�^ y : ����catetorical�z��
    XValid = XData(sep+1 : end); %���ؗp�f�[�^ x
    YValid = YData(sep+1 : end); %���ؗp�f�[�^ y
    
    
    %�ꎞ�I�ȃf�[�^�̍폜
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
    %�w�K���ʂ̉��()confuion matrix
    if logi.validation
        figure;
        calcConfusionMatrix;
    end
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