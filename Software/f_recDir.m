function [X, Y, dirs, fileCB, folderCB] = f_recDir(X, Y, dirs, fileCB, folderCB)
%RECDIR 与えられたpathのディレクトリを再帰的に探索
%   X , cellリスト , データ本体の情報
%   Y , cellリスト , データのラベル情報
%   dirs , string リスト , ディレクトリ情報の格納
%   fileCB , callback関数アドレス , fileだったときに呼び出すコールバック関数
%   folderCB , callback関数アドレス , folderだったときに呼び出すコールバック関数

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
