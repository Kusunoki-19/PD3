curPath = split(pwd,'\'); %���݂̃f�B���N�g����'\'�L���ŕ������z��ɑ��
systemPath = ""; %�S�̂��܂Ƃ߂�system�f�B���N�g��
for i  = 1:length(curPath)
    systemPath = strcat(systemPath, curPath(i));
    systemPath = strcat(systemPath, '\');
    if(curPath(i) == "system")
        break;
    end
end

EEGClassifierNet = load(strcat(systemPath,'Data\Networks\EEGClassifierNet.mat'));
EMGClassifierNet = load(strcat(systemPath,'Data\Networks\EMGClassifierNet.mat'));



