% function motionVector = motionAnalysis(name)

clear;
clc;

name = 'thomas';
gewicht = '0';
bewegung = 'Hampelmann';
norm = 'MovedToZeroSizeNormalized';

pfad = [name bewegung '/'];

name = [name bewegung gewicht norm];

M = dlmread([pfad name '.txt']);
% Matrix der erhobenen Daten. Zeilen: zeitlich aufeinanderfolgende Posen

startFactor = 0;
endFactor = 1;
% name = [name '_10_zyk'];

M = M(end*startFactor+1:(end-1)*endFactor,:); % Weglassen der letzten Zeile, da nicht intakt

% handr = M(:,23);
% handl = M(:,20);
% plot(handr);
% hold all;
% plot(handl);
% hold off;

[numFrames, numComp]= size(M);
%numComp ist die Anzahl der Dimensionen der Vektoren, die eine einzelne Pose beschreiben
%numFrames ist die Anzahl der Posen/Frames aus den Testdaten

numEigenvectors = 2;
% Anzahl der Eigenvektoren, die verwendet werden sollen
% Definitionsbereich = {1,...,numComp}

numWav = 1;
% Anzahl der Sinuswellen, die in der angenäherten Koeffizientenfunktion enthalten sein sollen
% Definitionsbereich = {1,...,numFrames/2} (Fouriertransformation) oder {1,...,8} (fit)
 
[COEFF,SCORE,LATENT] = princomp(M); % Hauptkomponentenanlyse

% fehler durch pca
err = zeros(2,numEigenvectors);
err(1,:) = 100/sum(LATENT).*LATENT(1:numEigenvectors); % geht das auch einfacher? ^^

p0 = mean(M(:,1:numComp)); % Durchschnittspose bestimmen

P0 = ones(numFrames,1)*p0; % Matrix mit der Durchschnittspose in jeder Spalte

x = 1:numFrames;

SCORE = SCORE(:,1:numEigenvectors); % Weglassen der nicht benötigten Koeffizienten
COEFF = COEFF(:,1:numEigenvectors); % Weglassen der nicht benötigten Eigenvektoren

%x = (0:4*pi/numFrames:4*pi*(1-1/numFrames)); %(alte Lösung)
% val = fitHampelmann(SCORE,numEigenvectors, numFrames);
val = zeros(numEigenvectors, numWav*3);

for i=1:numEigenvectors
   [fun,gof] = fit(x',SCORE(:,i),['sin' int2str(numWav)]);
   val(i,:) = coeffvalues(fun);

   err(2,i) = gof.rsquare; % error from fit
end

dlmwrite([pfad name 'Error.txt'],err);

resultScore = zeros(size(SCORE));
for i=1:numEigenvectors
    reconst = zeros(1,numFrames);
    for j=1:numWav
        reconst = reconst + val(i,3*j-2)*sin((1:numFrames)*val(i,3*j-1)+val(i,3*j));
    end
    resultScore(:,i) = reconst';
end


Zwischenergebnis = P0 + SCORE*COEFF';
 
Ergebnis = P0 + resultScore*COEFF';

motionVector = createHampelmannVector(p0,COEFF,val);

dlmwrite([pfad name 'MotionVectorCalc.txt'],motionVector);

% eigenwerte(LATENT,name,pfad);
koeffizienten(SCORE,resultScore,name,pfad,numWav,numFrames);
% animate(name,pfad,M,Zwischenergebnis,Ergebnis,numEigenvectors,numWav);

% end