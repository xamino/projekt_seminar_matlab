% In diesem Skript wird die Aufnahme normalisiert. Hierf�r der Datensatz
% entlang dem "Knochen" mit der Nummer 10 (Verbindung H�fte) auf 0 normiert.
clear;
clc;

name = 'olaf';
gewicht = '0';
bewegung = 'Seilhuepfen';

pfad = [name bewegung '/'];
name = [name bewegung gewicht];

M = dlmread([pfad name '.txt']);

[numFrames, numComp]= size(M);
for i=1:numFrames
    
    % Z und X Wert des 10. Knochen werden ben�tigt und die Differenz
    % gebildet
    xDiff=0-M(i,28);
    zDiff=0-M(i,30);
    for j=1:3:numComp
              % S�mtliche weiteren Werte des Frames werden angepasst
             M(i,j)=M(i,j)+xDiff;
             M(i,j+2)=M(i,j+2)+zDiff;
        
        
    end
    
end

dlmwrite([pfad name 'normalize.txt'],M);