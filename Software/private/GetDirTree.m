function [dirs, dirTree] = GetDirTree(dirs, dirTree)
%getDirTree �^����ꂽpath�̃f�B���N�g�����ċA�I�ɒT��
%   dirs , string ���X�g , �f�B���N�g�����X�g
%   dirTree , �\���� , �f�B���N�g���\���̂̏��
curPath = "";
for i = 1 : length(dirs) %list --> str
    curPath = strcat(curPath, dirs(i), '\');
end
fprintf('\n----- %s -----\n',curPath);
d = dir(curPath);
fileNames = string([]); %string list
fileNum = 0; %file count
folderNum = 0; %folder count
for i = 1 : length(d)
    if d(i).name == '.' %except parent directory path
        continue;
    end
   
    
    if d(i).isdir == 0 
        % file
        fileName = d(i).name;
        fileNum = fileNum + 1;
        fileNames(fileNum) = fileName;
        
    else
        % directory
        folderName = d(i).name;
        
        dirs(end+1) = folderName; %forward to child directory
        [dirs ,childDir] = GetDirTree(dirs,{}); %get child directory
        
        dirTree = setfield(dirTree, folderName, childDir);
    end
end
dirTree = setfield(dirTree, 'files', fileNames);
dirs = dirs(1:end-1); %back to parent directory
end