function [dirs, dirTree] = getDirTree(dirs, dirTree)
%getDirTree �^����ꂽpath�̃f�B���N�g�����ċA�I�ɒT��
%   �^����ꂽfolder��folder��file�c���[���擾
curPath = "";
for i = 1 : length(dirs) %list --> str
    curPath = strcat(curPath, dirs(i), '\');
end
fprintf('\n----- %s -----\n',curPath);
d = dir(curPath);

j = 0; %file or folder count
for i = 1 : length(d)
    if d(i).name == '.' %except parent directory path
        continue;
    end
    j = j + 1;
    
    if d(i).isdir == 0 
        % file
        fileName = d(i).name;
        dirTree{j} = fileName;
    else
        % directory
        folderName = d(i).name;
        
        dirs(end+1) = folderName; %forward to child directory
        [dirs ,childDir] = getDirTree(dirs,{}); %get child directory
        
        dirTree{j} = struct(folderName,childDir);
    end
end
dirs = dirs(1:end-1); %back to parent directory
end