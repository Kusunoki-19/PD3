function [dirs, dirTree] = f_getDirTree(dirs, dirTree)
%getDirTree 与えられたpathのディレクトリを再帰的に探索
%   与えられたfolderのfolderとfileツリーを取得
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
        [dirs ,childDir] = f_getDirTree(dirs,{}); %get child directory
        
        dirTree = setfield(dirTree, folderName, childDir);
    end
end
dirTree = setfield(dirTree, 'files', fileNames);
dirs = dirs(1:end-1); %back to parent directory
end