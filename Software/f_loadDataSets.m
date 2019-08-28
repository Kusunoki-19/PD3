function [X,Y] = f_loadDataSets(dataPath) 
%F_LOADDATASETS ��΃p�X�ŎQ�Ƃ����dataSets�̃��[�h�Ɗi�[
%   dataPath , string , �f�[�^�̐�΃p�X
[X, Y, ~, ~, ~, ~] = f_recDir({}, {}, 1, dataPath, @readCB, @demoCB);
end

function [X, Y] = readCB(X, Y, fileName, dirs)
%READCB recDir�̃R�[���o�b�N�֐�
%   file�R�[���o�b�N�֐��B�T����̃f�B���g���Ńt�@�C����ǂݍ���
fprintf('%s\t',fileName);
curPath = "";
for i = 1 : length(dirs)
    curPath = strcat(curPath, dirs(i), '\');
end

filePath = strcat(curPath, fileName);
tempX = importdata(filePath); 

if isstruct(tempX)
    tempX = tempX.val;%�f�[�^�^�̈Ⴄ���̂��������̂ł��̑΍�
end

X{(end+1),1} = tempX;
Y{(end+1),1} = dirs(end);
end

function [X, Y] = demoCB(X, Y, name, dirs)
%DEMOCB recDir�̃R�[���o�b�N�֐�
%   �^���R�[���o�b�N�֐�
end