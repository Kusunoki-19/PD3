function [categoricalData] = cellListStrToCategorical(cellListStr)
%CELLLISTSTRINGTOCATEGORICAL この関数の概要をここに記述
%   詳細説明をここに記述
for i = 1:length(cellListStr)
    %str <-- cell list str
    temp = cellListStr{i,1}(1,1); 
    %cell str <-- str
    temp = cellstr(temp);
    %cell str <-- cell str 同格のデータ形式で保存しないと cell list strになってしまう
    cellStr{i,1}  = temp{1,1};
end
categoricalData = categorical(cellStr); 
end

