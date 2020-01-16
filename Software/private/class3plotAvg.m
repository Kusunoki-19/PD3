for n = 1:3
    %{
    subplot(3,2,n*2 - 1);
    plot((1/1000):(1/1000):1,avgsig{n});
    legend('O2 - P4','O1 - P3','O2 - T6','O1 - T5','T6 - T4','T5 - T3'); 
    %}
    subploter(3,1,n,1);
    xfreqencies = cutFreqL:((cutFreqH - cutFreqL)/XLen):cutFreqH;
    xfreqencies = xfreqencies(1:end-1);
    plot(xfreqencies,avgspe{n});
    xlim([0,40]);
    ylim([-25,60]);
    if n == 1
        temp = "c0";
    elseif n == 2
        temp = "c1";
    else
        temp = "c2";
    end
    title(strcat(" , data label '",temp,"'"))
    xlabel('freqency [Hz]');
    ylabel('magnitude [dB]');
    legend('O2 - P4','O1 - P3','O2 - T6','O1 - T5','T6 - T4','T5 - T3','T4 - CP6','T3 - CP3'); 
end
function subploter(rownum,colnum,r,c)
subplot(rownum,colnum,(r-1)*colnum + c)
end