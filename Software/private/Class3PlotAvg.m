function Class3PlotAvg(XAvg, f, p)
for n = 1:3
    %{
    subplot(3,2,n*2 - 1);
    plot((1/1000):(1/1000):1,avgsig{n});
    legend('O2 - P4','O1 - P3','O2 - T6','O1 - T5','T6 - T4','T5 - T3'); 
    %}
    subplot1 = f.subplotter(3,1,n,1);
    plot1 = plot(p.xfreqencies,XAvg{n});
    %plot(xfreqencies,20*log10(avgspe{n}));
    if n == 1
        titleName = "background only";
    elseif n == 2
        titleName = "Ball";
    else
        titleName = "Stick";
    end
    if p.fig.isSetStyle
        title(titleName,'FontSize',p.fig.fontsize);
        set(subplot1,'XTick',p.fig.xtick);
        set(plot1(1),'DisplayName','O2 - P4','MarkerSize',4,'LineStyle','none','Marker','o');
        set(plot1(2),'DisplayName','O1 - P3','MarkerSize',4,'LineStyle','none','Marker','p');
        set(plot1(3),'DisplayName','O2 - T6','MarkerSize',4,'LineStyle','none','Marker','s');
        set(plot1(4),'DisplayName','O1 - T5','MarkerSize',4,'LineStyle','none','Marker','d');
        set(plot1(5),'DisplayName','T6 - T4','MarkerSize',4,'LineStyle','none','Marker','^');
        set(plot1(6),'DisplayName','T5 - T3','MarkerSize',4,'LineStyle','none','Marker','v');
        set(plot1(7),'DisplayName','T4 - CP6','MarkerSize',4,'LineStyle','none','Marker','>');
        set(plot1(8),'DisplayName','T3 - CP3','MarkerSize',4,'LineStyle','none','Marker','<');
        %set(legend1,'Location','southeast');
        %legend('O2 - P4','O1 - P3','O2 - T6','O1 - T5','T6 - T4','T5 - T3','T4 - CP6','T3 - CP3');
        xlim([p.fig.xlim1 p.fig.xlim2]);
        ylim([p.fig.ylim1 p.fig.ylim2]);
        xlabel('freqency [Hz]','FontSize',p.fig.fontsize);
        ylabel('Amplitude','FontSize',p.fig.fontsize);
    end
end
end
