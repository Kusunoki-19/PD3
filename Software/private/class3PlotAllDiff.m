for n = 1:3
    
    subplot1 = subploter(3,1,n,1);
    xfreqencies = cutFreqL:((cutFreqH - cutFreqL)/XLen):cutFreqH;
    xfreqencies = xfreqencies(1:end-1);
    ydata = avgspe{n} - avgspe{1};
    plot1 = plot(xfreqencies,ydata([1,2,5,6],:));
    
    xlim([9.5,14]);
    ylim([-30,10]);
    if n == 1
        temp = "c0";
    elseif n == 2
        temp = "c1";
    else
        temp = "c2";
    end
    title(strcat("Difference , data label '",temp,"'"),'FontSize',10)
    xlabel('freqency [Hz]','FontSize',10);
    ylabel('magnitude [dB]','FontSize',10);
    
    set(subplot1,'XTick',9.5:0.5:14);
    legend1 = legend(subplot1,'show');
    set(legend1,'Location','southeast');
    set(plot1(1),'DisplayName','O2 - P4','MarkerSize',4,'LineStyle','none','Marker','o');
    set(plot1(2),'DisplayName','O1 - P3','MarkerSize',4,'LineStyle','none','Marker','square');
    set(plot1(3),'DisplayName','T6 - T4','MarkerSize',4,'LineStyle','none','Marker','diamond');
    set(plot1(4),'DisplayName','T5 - T3','MarkerSize',4,'LineStyle','none','Marker','^');
    hold on
    temp = {};
    plot([10.8 10.8],[-100 100],'Color','k','LineStyle','--');
    for i = 1:size(legend1.String,2)-1
        temp{end+1} = legend1.String{i};
    end
    legend1.String = temp;
    
end
function[subs] =  subploter(rownum,colnum,r,c)
subs = subplot(rownum,colnum,(r-1)*colnum + c);
end