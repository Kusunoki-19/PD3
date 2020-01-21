for c = 1:5
    if c == 1
        out = out41;
    elseif c == 2
        out = out42;
    elseif c == 3
        out = out43;
    elseif c == 4
        out = out44;
    elseif c == 5
        out = out45;
    end
    figure(c);
    experimental4StftPlot
end