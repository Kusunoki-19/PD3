net = TESTClassifierNet;

figure
subplot(1,2,1)
trainPred1 = categorical();
for i = 1:size(XTrain,1)
    trainPred1(end+1) = classify(net,XTrain{i,1});
end
    
LSTMAccuracy = sum(trainPred1 == YTrain)/numel(YTrain)*100;
ccLSTM = confusionchart(YTrain,trainPred1);
ccLSTM.Title = 'Confusion Chart (Training data)';
ccLSTM.ColumnSummary = 'column-normalized';
ccLSTM.RowSummary = 'row-normalized';


subplot(1,2,2)
trainPred2 = categorical();
for i = 1:size(XValid,1)
    trainPred2(end+1) = classify(net,XValid{i,1});
end
LSTMAccuracy = sum(trainPred2 == YValid)/numel(YValid)*100;
ccLSTM = confusionchart(YValid,trainPred2);
ccLSTM.Title = 'Confusion Chart (Validation data)';
ccLSTM.ColumnSummary = 'column-normalized';
ccLSTM.RowSummary = 'row-normalized';
