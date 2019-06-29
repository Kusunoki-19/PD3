function [X, Y, index, dirs, fileCB, folderCB] = recDir(X, Y, index, dirs, fileCB, folderCB)
%RECDIR 与えられたpathのディレクトリを再帰的に探索
%   与えられたfolderとdirのコールバック関数をそれぞれ実行
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
        [X, Y, index, dirs, ~, ~] = recDir(X, Y, index, dirs, fileCB, folderCB);
    end
end
dirs = dirs(1:end-1); %back to parent directory
end

%{ 
%callback sample 
function [X, Y] = readCB(X, Y, fileName, dirs)
%READCB recDirのコールバック関数
%   fileコールバック関数。探索先のディレトリでファイルを読み込む
fprintf('%s\t',fileName);
curPath = "";
for i = 1 : length(dirs)
    curPath = strcat(curPath, dirs(i), '\');
end

filePath = strcat(curPath, fileName);
tempX = importdata(filePath); 

if isstruct(tempX)
    tempX = tempX.val;%データ型の違うものがあったのでその対策
end

X{(end+1),1} = tempX;
Y{(end+1),1} = dirs(end);
end

function [X, Y] = demoCB(X, Y, name, dirs)
%DEMOCB recDirのコールバック関数
%   疑似コールバック関数
end

function [X, Y] = saveCB(X, Y, name, dirs)
%SAVECB recDirのコールバック関数
%   dirコールバック関数。ファイルのセーブを行う
end
%}
