clear;
clc;

bewegung = 'Hampelmann2Sin';

for n = 1:2
    
    switch n
        case 1
            norm = 'MovedToZero';
        otherwise
            norm = 'MovedToZeroSizeNormalized';
    end

    % Liest den gesamten MotionVector ein
    M = dlmread(['AllMotionVectors' bewegung norm '.txt']);
    % Weglassen von r

    % ermittelt die Dimensionen
    [zeilen, spalten]= size(M);
    STDA = ones(1,spalten);

    for i=2:spalten
        % Für jede Spalte wird die Standardabweichung berechnet...
        VektorSpalte=M(:,i);
        abweichung = std(VektorSpalte);
        STDA(1,i-1)=abweichung;
        for j=1:zeilen
            %...und jeder Eintrag darin dadurch geteilt
            M(j,i)=M(j,i)/abweichung;
        end
    end

    dlmwrite(['uVector' bewegung norm '.txt'],STDA);
    dlmwrite(['stdUMotionVector' bewegung norm '.txt'],M);

end
