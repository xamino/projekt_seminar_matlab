%Verschiebt alle Datensaetze auf 0 und normalisiert ueber Koerpergroesse
clear;
clc;

bewegung = 'Hampelmann';

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
                
                M = M(1:end-1,:);
                %Weglassen der letzten Zeile, da nicht intakt
    
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
                
                
                Y = zeros(numFrames,numComp/3);
                %Matrix mit nur Y-Eintraegen
                for j = 2:3:numComp
                    Y(:,(j+1)/3) = M(:,j);
                end
                
                minY = min(Y(:));
                
                % Datensatz so nach oben verschieben, dass 0 der Boden ist
%                 for j = 2:3:numComp
%                     M(:,j) = M(:,j) - ones(numFrames,1)*minY;
%                 end

                dlmwrite([name '/' name g 'MovedToZero.txt'],M);
                
                averagePosture = mean(M);
                
                if g == '0'
                    %durchschnittlicher Abstand zwischen Kopf(1) und Huefte(10)
                    dist1To10 = averagePosture(2)-averagePosture(29);
                end
                
                M = M.*(0.6/dist1To10*ones(size(M)));
                
                dlmwrite([name '/' name g 'MovedToZeroSizeNormalized.txt'],M);
    
            end
        end
    end
    
end