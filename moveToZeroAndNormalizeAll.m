%Verschiebt alle Datensaetze auf 0 und normalisiert ueber Koerpergroesse
clear;
clc;

bewegung = 'Seilhuepfen';

% Grundverzeichnis einlesen
dirData = dir('.');

for i=1:(length(dirData))
    
    % Wenn es sich um einen Ordner handelt ->weitermachen
    if (dirData(i).isdir)
        
        name = dirData(i).name;
        
        %entweder Hampelmann oder Seilhuepfen
        findstring = strfind(name, bewegung);
        if ~isempty(findstring)
        % gewuenschte Bewegung
        
            % Fuer mit und ohne Gewicht
            for g = ['0','5']
                M = dlmread([name '/' name g '.txt']);
    
                [numFrames, numComp]= size(M);
                for f=1:numFrames

                    % Z und X Wert des 10. Knochen werden benötigt und die Differenz
                    % gebildet
                    xDiff=0-M(f,28);
                    zDiff=0-M(f,30);
                    for j=1:3:numComp
                         % Sämtliche weiteren Werte des Frames werden angepasst
                         M(f,j)=M(f,j)+xDiff;
                         M(f,j+2)=M(f,j+2)+zDiff;
                    end

                end

                dlmwrite([name '/' name g 'MovedToZero.txt'],M);
                
                averagePosture = mean(M);
                
                %durchschnittlicher Abstand zwischen Kopf(1) und Huefte(10)
                dist1To10 = averagePosture(2)-averagePosture(29);
                
                M = M.*(0.6/dist1To10*ones(size(M)));
                
                dlmwrite([name '/' name g 'MovedToZeroSizeNormalized.txt'],M);
    
            end
        end
    end
    
end