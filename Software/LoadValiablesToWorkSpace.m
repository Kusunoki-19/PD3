

%1�����z��̃C���f�b�N�X���X�g���o���p�̖����֐��̊֐��n���h��
dList = @(list) 1:length(list);
%�������z���1,2�����̃C���f�b�N�X���X�g���o���p�̖����֐��̊֐��n���h��
d1List = @(Matrix) 1:size(Matrix,1);
d2List = @(Matrix) 1:size(Matrix,2);
%�\���̂̃t�B�[���h�����񃊃X�g�擾�p�̖����֐��̊֐��n���h��
fieldList = @(Struct) string(transpose(fieldnames(Struct)));
%�������z���1,2�����̒������o���p�̖����֐��̊֐��n���h��
d1Len = @(Matrix) size(Matrix,1);
d2Len = @(Matrix) size(Matrix,2);
%��r�p�����֐��̊֐��n���h��
isStrMatchInCell = @(str, cellStr) any(strcmp(str,cellStr),'all');

Fs = 1000;
sampleTime = 5;
sampleLen = Fs * sampleTime;
channelNum = 8;


trainClasses = {'c0','c1','c2'}; %ball, stick, none : c1 c2 c0
if(isMultiDisplay)
    %c1~8 , c10~80
    validClasses = { ... 
        'c1' ,'c2' ,'c3' ,'c4' ,'c5' ,'c6' ,'c7' ,'c8' , ...
        'c10','c20','c30','c40','c50','c60','c70','c80'}; 
end

firstCutsec = 10;
cutFreqL = 0;
cutFreqH = 200;
trainRate = 0.75;