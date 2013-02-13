function [dividedM,u] = divideByStdDeviation(M)
% teilt alle Eintraege bis auf die erste Zeile durch die Standardabweichung
% �ber die Zeile

    % ermittelt die Dimensionen
    [zeilen, spalten] = size(M);
    
    u = ones(1,spalten-1);
    dividedM = zeros(zeilen,spalten);

    for i=2:spalten
        % F�r jede Spalte wird die Standardabweichung berechnet...
        u(i-1) = std(M(:,i));
       
        for j=1:zeilen
            %...und jeder Eintrag darin dadurch geteilt
            dividedM(j,i) = M(j,i)/u(i-1);
        end
    end

end

