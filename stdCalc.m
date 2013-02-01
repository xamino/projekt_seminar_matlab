clear;
clc;

% Liest den gesamten MotionVector ein
name = 'AllMotionVectorCollcted';
M = dlmread([name '.txt']);
B=M;
R=M(:,1);
% ermittelt die Dimensionen
[zeilen, spalten]= size(M);
STDA = ones(1,spalten);
STDA(1,1)=std(M(:,1));
for i=2:spalten
    % Für jede Spalte wird die Standardabweichung berechnet...
    VektorSpalte=M(:,i);
    abweichung = std(VektorSpalte);
    STDA(1,i)=abweichung;
    for j=1:zeilen
        ...und jeder Eintrag darin dadurch geteilt
        M(j,i)=M(j,i)/abweichung;
    end
end

dlmwrite('rVector.txt',R);
dlmwrite('uVector.txt',STDA);
dlmwrite('stdUMotionVector.txt',M);
