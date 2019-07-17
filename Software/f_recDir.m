function [X, Y, dirs, fileCB, folderCB] = f_recDir(X, Y, dirs, fileCB, folderCB)
%RECDIR �^����ꂽpath�̃f�B���N�g�����ċA�I�ɒT��
%   X , cell���X�g , �f�[�^�{�̂̏��
%   Y , cell���X�g , �f�[�^�̃��x�����
%   dirs , string ���X�g , �f�B���N�g�����̊i�[
%   fileCB , callback�֐��A�h���X , file�������Ƃ��ɌĂяo���R�[���o�b�N�֐�
%   folderCB , callback�֐��A�h���X , folder�������Ƃ��ɌĂяo���R�[���o�b�N�֐�

curPath = "";
for i = 1 : length(dirs)
    curPath = strcat(curPath, dirs(i), '\');
end
fprintf('\n----- %s -----\n',curPath);
d = dir(curPath);

for i = 1 : length(d)
    if d(i).name == '.' %except parent directory path
        continue;
    end
    
    if d(i).isdir == 0 % file
        %callback
        fileName = d(i).name;
        [X, Y] = fileCB(X, Y, fileName, dirs);
    else % directory 
        folderName = d(i).name;
        [X, Y] = folderCB(X, Y, folderName, dirs);
        
        dirs(end+1) = folderName; %forward to child directory
        [X, Y, index, dirs, ~, ~] = f_recDir(X, Y, index, dirs, fileCB, folderCB);
    end
end
dirs = dirs(1:end-1); %back to parent directory
end
