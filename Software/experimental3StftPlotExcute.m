for c = 1:4
    if c == 1
        out = out1;
    elseif c == 2
        out = out2;
    elseif c == 3
        out = out3;
    elseif c == 4
        out = out4;
    end
    figure(c);
    Experimental3StftPlot;
end