for i = 1:8
    figure(4);
    %1 2 -> 0.5 1 -> 1
    %3 4 -> 1.5 2 -> 2
    %5 6 -> 2.5 3 -> 3
    %7 8 -> 3.5 4 -> 4
    if true
        col = rem(i-1,2) + 1;
        row = round(i/2); 
        sprintf('i:%d %d %d', [i,col,row])
        ax = subploter(2, 4,col, row);
    elseif false 
        ax = subploter(1, 8,1, i);
    end
  
    hold(ax,'on');
    times = ((1/1000):(1/1000):1000);
    plot(times, out.rawEEG(1:length(times),i));
    for j = 1:8
        hold(ax,'on');
        %plot([sec10*j, sec10*j],[100,-100], '--r', 'LineWidth',2);
    end
    title(strcat("channel " , num2str(i)),'FontSize',10);
    %xticks([0:sec10:5]);
    %xlim([sec10/2 sec10*3]);
    xlim([100 100.1]);
    ylim([-1 1]*0.1);
    xlabel('����[sec]','FontSize',10);
    ylabel('���g��[Hz]','FontSize',10);
    %cBar = colorbar('FontSize',10);
    %cBar.Label.String = '�U��[dB]';
    %set(ax,'CLim',[-20. 20]);
    
end


function sub =  subploter(COL, ROW ,col ,row)
sub = subplot(ROW,COL,(row-1)*COL + col);
end

function integerNum = cutFew(num)
integerNum = num - rem(num,1);
end