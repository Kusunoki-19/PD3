load('Data\testRawData.mat');
rawData =  testRawData

[dataSets, labels] = clipDataSets(rawData)
dataDir = strcat( pwd, "\Data\SaveTestFolder");
%�����������ƍ\���̂�key�Ƃ��ĔF������Ȃ��ȂǕs��������̂ŁA'1' --> 'c1'�̂悤�ɕϊ�����
for i = 1:length(labels) 
    labels{i,1} = num2str(labels{i,1});
    labels{i,1} = strcat('c', labels{i,1});
end

[~ , dirTree ] = getDirTree("D:\_PD3\system\Software\Data\EMG2018", {})
for i = 1:length(dirTree)
    labels(i)
    dirTre
    save(dataSets(i,1))
end

function [] = saver(saveData,saveLabel,dirTree) 
if getfield(dirTree, saveLabel)
    
end
end