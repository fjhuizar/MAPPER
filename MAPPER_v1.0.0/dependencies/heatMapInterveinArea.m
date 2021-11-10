function [geometricalLabel] = heatMapInterveinArea(yfit, interveinLabels, geometricalStats)
    areaLabel = interveinLabels;
    for i = 1: length(yfit)
        areaLabel(areaLabel == yfit(i)) = geometricalStats(yfit(i));
    end
end



