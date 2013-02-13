function [M,u] = divideByStdDeviation(M)
% teilt alle Eintraege bis auf die erste Zeile durch die Standardabweichung
% über die Zeile

    % ermittelt die Dimensionen
    [zeilen, spalten] = size(M);
    
    u = ones(1,spalten-1);

    for i=2:spalten
        % Für jede Spalte wird die Standardabweichung berechnet...
        u(i-1) = std(M(:,i));
        for j=1:zeilen
            %...und jeder Eintrag darin dadurch geteilt
            M(j,i) = M(j,i)/u(i-1);
        end
    end

end

