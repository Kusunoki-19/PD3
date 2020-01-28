COL = 2; %2óÒ
ROW = 8; %8çs
col = 1;
row = 1;
%validClasses = { ... 
%    'c1' ,'c2' ,'c3' ,'c4' ,'c5' ,'c6' ,'c7' ,'c8' , ...
%    'c10','c20','c30','c40','c50','c60','c70','c80'}; 

for classIndex = d2List(validClasses)
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
    
    subploter(ROW, COL, row, col);
    xfreqencies = cutFreqL:((cutFreqH - cutFreqL)/XLen):cutFreqH;
    xfreqencies = xfreqencies(1:end-1);
    plot(xfreqencies,avgspe{classIndex});
    xlim([0,40]);
    ylim([-25,60]);

    title(strcat("data label '",validClasses{classIndex}, "'"))
    xlabel('freqency [Hz]');
    ylabel('magnitude [dB]');
    legend('O2 - P4','O1 - P3','O2 - T6','O1 - T5','T6 - T4','T5 - T3','T4 - CP6','T3 - CP3'); 
    
end

function subploter(rownum,colnum,r,c)
subplot(rownum,colnum,(r-1)*colnum + c)
end