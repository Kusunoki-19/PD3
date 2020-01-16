sumspe = {};
avgspe = {};
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

for classIndex = d2List(validClasses)
    sumspe{classIndex} = zeros(XDim,XLen);
    avgspe{classIndex} = zeros(XDim,XLen);
end

%各データごとでループ
for dataIndex = d1List(XDataForValidation)
    %各クラスごとで処理の分岐ループ
    for classIndex = d2List(validClasses)
        if YDataForValidation{dataIndex} == validClasses{classIndex}
            sumspe{classIndex} = ...
                sumMatrix(sumspe{classIndex}, XDataForValidation{dataIndex});
            %各クラスごとでデータ数をカウント
            count{classIndex} = count{classIndex} + 1;
        end
    end
end


for classIndex = d2List(validClasses)
    avgspe{classIndex} = sumspe{classIndex} / count{classIndex};
end

function summed = sumMatrix(matrix1, matrix2)
if size(matrix1)  == size(matrix2)
    summed = matrix1 + matrix2
    %各チャンネルごとで加算
    %{
    for j = 1:channelNum
        sumspe{classIndex}(j,:) = ...
                       sumspe{classIndex}(j,:) + ...
            XDataForValidation{dataIndex}(j,:);
    end
    %}
end
end