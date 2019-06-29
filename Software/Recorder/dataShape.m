[~, ~, ~, ~, ~] = recDir({}, {}, 1,"D:\kusunoki\PD3\Data\EMG2018", @readCB, @demoCB);

%%
%�^����ꂽpath�̃f�B���N�g�����ċA�I�ɒT���������Ɋi�[����Ă���t�@�C����ǂݍ���
function [X, Y, index, dirs, fileCB, folderCB] = recDir(X, Y, index, dirs, fileCB, folderCB)
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

%%
function [X, Y] = demoCB(X, Y, name, dirs)
end

%%
function [X, Y] = saveCB(X, Y, name, dirs)
end

%%
function [X, Y] = readCB(X, Y, fileName, dirs)
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
