function XAvg = Class16CalcAvg(X, Y, f, p)
XSum = {};
XAvg = {};
%validClasses = { ... 
%    'c1' ,'c2' ,'c3' ,'c4' ,'c5' ,'c6' ,'c7' ,'c8' , ...
%    'c10','c20','c30','c40','c50','c60','c70','c80'}; 

count = {...
    0,0,0,0, 0,0,0,0, ...
    0,0,0,0, 0,0,0,0 };
% x���ؗp�f�[�^ XDataForValidation , cell double
% y���ؗp�f�[�^ YDataForValidation , cell string
% d1List
% d2List


for classIndex = f.d2List(p.validClasses)
    XSum{classIndex} = zeros(p.XDim,p.XLen);
    XAvg{classIndex} = zeros(p.XDim,p.XLen);
end

%�e�f�[�^���ƂŃ��[�v
for dataIndex = f.d1List(Y)
    %�e�N���X���Ƃŏ����̕��򃋁[�v
    for classIndex = f.d2List(p.validClasses)
        if Y{dataIndex} == p.validClasses{classIndex}
            XSum{classIndex} = ...
                sumMatrix(XSum{classIndex}, X{dataIndex});
            %�e�N���X���ƂŃf�[�^�����J�E���g
            count{classIndex} = count{classIndex} + 1;
        end
    end
end


for classIndex = f.d2List(p.validClasses)
    XAvg{classIndex} = XSum{classIndex} / count{classIndex};
end
end

function summed = sumMatrix(matrix1, matrix2)
if size(matrix1)  == size(matrix2)
    summed = matrix1 + matrix2;
    %�e�`�����l�����Ƃŉ��Z
    %{
    for j = 1:channelNum
        sumspe{classIndex}(j,:) = ...
                       sumspe{classIndex}(j,:) + ...
            XDataForValidation{dataIndex}(j,:);
    end
    %}
else
    disp('�s��̒���������Ȃ�');
end
end