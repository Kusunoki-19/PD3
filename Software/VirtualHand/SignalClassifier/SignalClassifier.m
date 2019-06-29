curPath = split(pwd,'\'); %現在のディレクトリを'\'記号で分割し配列に代入
systemPath = ""; %全体をまとめるsystemディレクトリ
for i  = 1:length(curPath)
    systemPath = strcat(systemPath, curPath(i));
    systemPath = strcat(systemPath, '\');
    if(curPath(i) == "system")
        break;
    end
end

EEGClassifierNet = load(strcat(systemPath,'Data\Networks\EEGClassifierNet.mat'));
EMGClassifierNet = load(strcat(systemPath,'Data\Networks\EMGClassifierNet.mat'));



