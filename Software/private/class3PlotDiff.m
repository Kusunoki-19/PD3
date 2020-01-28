isSetStyle = true;
for n = 1:3
    %{
    subplot(3,2,n*2 - 1);
    plot((1/1000):(1/1000):1,avgsig{n});
    legend('O2 - P4','O1 - P3','O2 - T6','O1 - T5','T6 - T4','T5 - T3'); 
    %}
    subplot1 = subploter(3,1,n,1);
    ydataLinear = avgspe{n} - avgspe{1};
    ydataLogari = 20*log10(ydataLinear);
    plot1 = plot(xfreqencies,ydataLinear([1,2,3,4,5,6,7,8],:));
    %plot1 = plot(xfreqencies,ydataLogari([1,2,3,4,5,6],:));
    if n == 1
        temp = "only background";
    elseif n == 2
        temp = "Ball";
    else
        temp = "Stick";
    end
    %legend('O2 - P4','O1 - P3','O2 - T6','O1 - T5','T6 - T4','T5 - T3','T4 - CP6','T3 - CP3'); 
    if isSetStyle
        title(strcat("display '",temp,"'"),'FontSize',10);
        set(subplot1,'XTick',0:0.5:20);
        %legend1 = legend(subplot1,'show');
        %set(legend1,'Location','southeast');
        set(plot1(1),'DisplayName','O2 - P4','MarkerSize',4,'LineStyle','none','Marker','o');
        set(plot1(2),'DisplayName','O1 - P3','MarkerSize',4,'LineStyle','none','Marker','p');
        set(plot1(3),'DisplayName','O2 - T6','MarkerSize',4,'LineStyle','none','Marker','s');
        set(plot1(4),'DisplayName','O1 - T5','MarkerSize',4,'LineStyle','none','Marker','d');
        set(plot1(5),'DisplayName','T6 - T4','MarkerSize',4,'LineStyle','none','Marker','^');
        set(plot1(6),'DisplayName','T5 - T3','MarkerSize',4,'LineStyle','none','Marker','v');
        set(plot1(7),'DisplayName','T4 - CP6','MarkerSize',4,'LineStyle','none','Marker','>');
        set(plot1(8),'DisplayName','T3 - CP3','MarkerSize',4,'LineStyle','none','Marker','<');
        if false %•â•ü’Ç‰Á
            hold on
            plot([10.8 10.8],[-100 100],'Color','k','LineStyle','--');
            tempLegend = {};
            for i = 1:size(legend1.String,2) - 1
                tempLegend{end+1} = legend1.String{i};
            end
            legend1.String = tempLegend;
            %legend1.String = legend1.String{1:end-1};
        end
        setXLim;
        setYLimLinear;
        %setYLimLogari;
        ylabel('U•“Á«‚Ì·','FontSize',10);
    end
    
end
function[subs] =  subploter(rownum,colnum,r,c)
subs = subplot(rownum,colnum,(r-1)*colnum + c);
end