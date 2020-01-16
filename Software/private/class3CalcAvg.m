sumspe = {};
avgspe = {};
count = {0,0,0};
X = XDataForValidClass3;
Y = YDataForValidClass3;


for i = 1:3
    sumspe{i} = zeros(XDim,XLen);
    avgspe{i} = zeros(XDim,XLen);
end

for i = 1:length(Y)
    if Y(i) == "c0"
        n = 1;
    end
    if Y(i) == "c1"
        n = 2;
    end
    if Y(i) == "c2"
        n = 3;
    end
    
    sumspe{n} = sumspe{n} + X{i,1};
    count{n} = count{n} + 1;
end

for n = 1:3
    avgspe{n} = sumspe{n} / count{n};
end