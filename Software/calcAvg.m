sumspe = {};
avgspe = {};
count = {0,0,0};

for i = 1:3
    sumspe{i} = zeros(XDim,XLen);
    avgspe{i} = zeros(XDim,XLen);
end

for i = 1:length(dataY)
    if dataY(i) == categorical("c0")
        n = 1;
    end
    if dataY(i) == categorical("c1")
        n = 2;
    end
    if dataY(i) == categorical("c2")
        n = 3;
    end
    
    for j = 1:channelNum
        sumspe{n}(j,:) = sumspe{n}(j,:) + dataX{i,1}(j,:);
    end
    count{n} = count{n} + 1;
end

for n = 1:3
    avgspe{n} = sumspe{n} / count{n};
end