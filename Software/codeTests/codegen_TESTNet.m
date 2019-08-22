function y = TESTNet(u)
persistent mynet;
if isempty(mynet)
    mynet =  coder.loadDeepLearningNetwork("D:\_PD3\System\Software\Data\Networks\TESTClassifierNet.mat");
end
y = mynet.predict(u);
end
