function Class16PlotAvg(YAvg, f, p)
COL = 2; %2óÒ
ROW = 8; %8çs
col = 1;
row = 1;

for classIndex = f.d2List(p.validClasses)
    if classIndex <= 8 
        col = 2; %c1 ~ c8
    else
        col = 1; %c10 ~ c80
    end
    
    if classIndex == 1 || classIndex == 9
            row = 1;
    elseif classIndex == 2 || classIndex == 10
            row = 2;
    elseif classIndex == 3 || classIndex == 11
            row = 3;
    elseif classIndex == 4 || classIndex == 12
            row = 4;
    elseif classIndex == 5 || classIndex == 13
            row = 5;
    elseif classIndex == 6 || classIndex == 14
            row = 6;
    elseif classIndex == 7 || classIndex == 15
            row = 7;
    elseif classIndex == 8 || classIndex == 16
            row = 8;
    end
    
    f.subplotter(ROW, COL, row, col);
    plot(p.xfreqencies,YAvg{classIndex});
    xlim([0,40]);
    ylim([-25,60]);
    titleName = strcat("data label '",p.validClasses{classIndex}, "'");
    title(titleName,'FontSize',p.fig.fontsize);
    
    xlabel('freqency [Hz]','FontSize',p.fig.fontsize);
    ylabel('magnitude [dB]','FontSize',p.fig.fontsize);
    legend('O2 - P4','O1 - P3','O2 - T6','O1 - T5','T6 - T4','T5 - T3','T4 - CP6','T3 - CP3'); 
end
end