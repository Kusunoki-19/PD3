function XAvg = Class3CalcAvg(X, Y, f, p)
XSum = {};
XAvg = {};
count = {0,0,0};

for i = 1:3
    XSum{i} = zeros(p.XDim,p.XLen);
    XAvg{i} = zeros(p.XDim,p.XLen);
end

for i = 1:length(Y)
    if string(Y(i)) == "c0"
        n = 1;
    end
    if string(Y(i)) == "c1"
        n = 2;
    end
    if string(Y(i)) == "c2"
        n = 3;
    end
    
    XSum{n} = XSum{n} + X{i,1};
    count{n} = count{n} + 1;
end

for n = 1:3
    XAvg{n} = XSum{n} / count{n};
end

end
