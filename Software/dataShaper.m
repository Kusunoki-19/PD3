load('Data\testRawData.mat');
rawData =  testRawData
%rawData = out.rawEMG1

[dataSets, labels] = f_clipDataSets(rawData)
dataPath = strcat( pwd, "\Data\EMG2019");
[~ , dirTree ] = f_getDirTree(dataPath, struct);
%数字だけだと構造体のkeyとして認識されないなど不具合も多いので、'1' --> 'c1'のように変換する
for i = 1:length(labels) 
    labels{i,1} = num2str(labels{i,1});
    labels{i,1} = strcat('c', labels{i,1});
end

for i = 1:length(labels)
    dataSet = dataSets{i,1};
    temp = labels(i)
    temp = temp{1,1}
    [~ , dirTree ] = f_getDirTree(dataPath, struct);
    saver(dataSet, temp,  dataPath, dirTree);
end

function [] = saver(val, saveLabel, saveDir, dirTree) 
fieldNames = fieldnames(dirTree)
for i = 1:length(fieldNames)
    fieldName = fieldNames{i,1};
    
    if strcmp(fieldName , saveLabel) 
        %save location directory --> save data
        filesNum = length(dirTree.(fieldName).files);
        dataPath = strcat(saveDir,'\', fieldName);
        fileName = strcat(saveLabel , '_', int2str(filesNum), '.mat');
        
        save(strcat(dataPath,'\', fileName), 'val');
        return
    elseif strcmp(fieldName, 'files')
        %there are files
    else
        %not save location directory --> search child directory
        saver(val, saveLabel, strcat(saveDir,'\', fieldName), dirTree.(fieldName));
    end
    
end
end