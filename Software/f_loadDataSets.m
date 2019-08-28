function [X,Y] = f_loadDataSets(dataPath) 
%F_LOADDATASETS 絶対パスで参照されるdataSetsのロードと格納
%   dataPath , string , データの絶対パス
[X, Y, ~, ~, ~, ~] = f_recDir({}, {}, 1, dataPath, @readCB, @demoCB);
end

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