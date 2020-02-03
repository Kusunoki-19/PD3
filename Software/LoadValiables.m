function [func, param] = LoadValiables
%%
%�����Q���܂Ƃ߂��\����
%%
func = struct;
%1�����z��̃C���f�b�N�X���X�g���o���p�̖����֐��̊֐��n���h��
func.dList = @(list) 1:length(list);
%�������z���1,2�����̃C���f�b�N�X���X�g���o���p�̖����֐��̊֐��n���h��
func.d1List = @(Matrix) 1:size(Matrix,1);
func.d2List = @(Matrix) 1:size(Matrix,2);
%�\���̂̃t�B�[���h�����񃊃X�g�擾�p�̖����֐��̊֐��n���h��
func.fieldList = @(Struct) string(transpose(fieldnames(Struct)));
%�������z���1,2�����̒������o���p�̖����֐��̊֐��n���h��
func.d1Len = @(Matrix) size(Matrix,1);
func.d2Len = @(Matrix) size(Matrix,2);
%��r�p�����֐��̊֐��n���h��
func.isStrMatchInCell = @(str, cellStr) any(strcmp(str,cellStr),'all');

%�T�u�v���b�g
func.subplotter = @(ROW, COL, row, col) subplot(ROW,COL,(row-1)*COL + col);
%%
%�p�����[�^���܂Ƃ߂��\����
param = struct;
%%

param.Fs = 1000;
param.sampleTime = 5;
param.sampleLen = param.Fs * param.sampleTime;
param.channelNum = 8;

param.experiNum = 2;

param.trainClasses = {'c0','c1','c2'}; %ball, stick, none : c1 c2 c0
if param.experiNum == 2
    %c1~8 , c10~80
    param.validClasses = { ... 
        'c1' ,'c2' ,'c3' ,'c4' ,'c5' ,'c6' ,'c7' ,'c8' , ...
        'c10','c20','c30','c40','c50','c60','c70','c80'}; 
end

if param.experiNum == 1
    param.isMultiDisplay = false;
    param.dataPath = "D:\kusunoki\PD3\Software\Data\Experimental1";

elseif param.experiNum == 2
    param.isMultiDisplay = true;
    param.dataPath = "D:\kusunoki\PD3\Software\Data\Experimental2";
end
param.trainDataPath = param.dataPath;
param.savePath = strcat(...
    param.dataPath, "\", ...
    datestr(now,"yyyy\\mm\\dd\\HHMM"));

param.firstCutsec = 10;
param.cutFreqL = 0;
param.cutFreqH = 200;
param.trainRate = 0.75;

param.fig.xlim1 = 9.3;
param.fig.xlim2 = 13.1;
param.fig.ylim1 = 0.5;
param.fig.ylim2 = 5;
param.fig.fontsize = 10;
end