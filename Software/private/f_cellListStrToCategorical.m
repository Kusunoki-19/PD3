function [categoricalData] = f_cellListStrToCategorical(cellListStr)
%CELLLISTSTRINGTOCATEGORICAL cell,list,string�f�[�^��categorical�f�[�^�ɕϊ�
%   cellListStr , cell,list,string�f�[�^
cellStr = {};
for i = 1:length(cellListStr)
    %str <-- cell list str
    temp = cellListStr{i,1}(1,1); 
    %cell str <-- str
    temp = cellstr(temp);
    %cell str <-- cell str ���i�̃f�[�^�`���ŕۑ����Ȃ��� cell list str�ɂȂ��Ă��܂�
    cellStr{i,1}  = temp{1,1};
end
categoricalData = categorical(cellStr); 
end
