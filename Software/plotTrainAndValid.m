%%
dataX = {};
dataY = {};
dataX = XTrain;
dataY = YTrain;
calcAvg;

trainAvg = {};
trainAvg = avgspe;
%%
dataX = {};
dataY = {};
dataX = XValid;
dataY = YValid;
calcAvg;

validAvg = {};
validAvg = avgspe;
%%
figure
avgspe = trainAvg;
c = 1;
graphName = "Average 1";
plotAvg;

avgspe = validAvg;
c = 2;
graphName = "Average 2";
plotAvg;
%%
figure
avgspe = trainAvg;
c = 1;
graphName = "Difference 1";
plotDiff;
avgspe = validAvg;
c = 2;
graphName = "Difference";
plotDiff;
%%
figure
dataX = {};
dataY = {};
dataX = XFreqe;
dataY = YCateg;
calcAvg;

allAvg = {};
allAvg = avgspe;
plotAllDiff;
