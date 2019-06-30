load('Data\testRawData.mat');
rawData =  testRawData

[dataSets, labels] = clipDataSets(rawData)
dataPath = strcat( pwd, "\Data\SaveTestFolder");
[~ , dirTree ] = getDirTree("dataPath", struct)
%数字だけだと構造体のkeyとして認識されないなど不具合も多いので、'1' --> 'c1'のように変換する
for i = 1:length(labels) 
    labels{i,1} = num2str(labels{i,1});
    labels{i,1} = strcat('c', labels{i,1});
end

for i = 1:length(dirTree)
    dataSet = dataSets{i,1}
    saver('dataSet',labels(i), dataPath,dirTree)
end

function [] = saver(dataName,saveLabel,saveDir, dirTree) 
for fieldName = fieldnames(dirTree)
    fieldName = fieldName{1,1};
    saveLabel = saveLabel{1,1};
    if strcmp(fieldName , saveLabel)
        filesNum = length(dirTree.(fieldName).files);
        dataPath = strcat(saveDir,'\', fieldName);
        fileName = strcat(saveLabel , '_', int2str(filesNum), '.mat');
        
        save(strcat(dataPath,'\', fileName),dataName);
        return
    else 
        saver(dataName,saveLabel, strcat(saveDir,'\', fieldName),dirTree.(fieldName)) ;
    end
     
end


end