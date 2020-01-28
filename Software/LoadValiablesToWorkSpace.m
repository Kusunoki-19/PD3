

%1次元配列のインデックスリスト取り出し用の無名関数の関数ハンドル
dList = @(list) 1:length(list);
%多次元配列の1,2次元のインデックスリスト取り出し用の無名関数の関数ハンドル
d1List = @(Matrix) 1:size(Matrix,1);
d2List = @(Matrix) 1:size(Matrix,2);
%構造体のフィールド文字列リスト取得用の無名関数の関数ハンドル
fieldList = @(Struct) string(transpose(fieldnames(Struct)));
%多次元配列の1,2次元の長さ取り出し用の無名関数の関数ハンドル
d1Len = @(Matrix) size(Matrix,1);
d2Len = @(Matrix) size(Matrix,2);
%比較用無名関数の関数ハンドル
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