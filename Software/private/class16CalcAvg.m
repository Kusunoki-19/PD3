function XAvg = Class16CalcAvg(X, Y, f, p)
XSum = {};
XAvg = {};
%validClasses = { ... 
%    'c1' ,'c2' ,'c3' ,'c4' ,'c5' ,'c6' ,'c7' ,'c8' , ...
%    'c10','c20','c30','c40','c50','c60','c70','c80'}; 

count = {...
    0,0,0,0, 0,0,0,0, ...
    0,0,0,0, 0,0,0,0 };
% x検証用データ XDataForValidation , cell double
% y検証用データ YDataForValidation , cell string
% d1List
% d2List


for classIndex = f.d2List(p.validClasses)
    XSum{classIndex} = zeros(p.XDim,p.XLen);
    XAvg{classIndex} = zeros(p.XDim,p.XLen);
end

%各データごとでループ
for dataIndex = f.d1List(Y)
    %各クラスごとで処理の分岐ループ
    for classIndex = f.d2List(p.validClasses)
        if Y{dataIndex} == p.validClasses{classIndex}
            XSum{classIndex} = ...
                sumMatrix(XSum{classIndex}, X{dataIndex});
            %各クラスごとでデータ数をカウント
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
    %各チャンネルごとで加算
    %{
    for j = 1:channelNum
        sumspe{classIndex}(j,:) = ...
                       sumspe{classIndex}(j,:) + ...
            XDataForValidation{dataIndex}(j,:);
    end
    %}
else
    disp('行列の長さが合わない');
end
end