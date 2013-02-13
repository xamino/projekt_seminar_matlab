function [misclassificationsCompleteData,c,V,u] = classifyAll( M )
%Fehlklassifikationen mit komplettem Datensatz ermitteln

% durch Standardabweichungen teilen
[M,u] = divideByStdDeviation(M);

r = M(:,1);
r = 2*(r-0.5); % Statt 0 sollte -1 in r stehen
completeM = M(:,2:end);

[numVect, numComp]= size(completeM);

[V,K] = princomp(completeM);

% Klassifikator c berechnen
% entweder cK=r oder Kc=r loesen
% c = K\r;
c = r'/K';
c = c';

misclassificationsCompleteData = zeros(1,min(numVect,numComp));

for i=1:min(numVect,numComp)
   % in c_i sind die ersten i Werte von c
   c_i = c(1:i);
   % in K_i sind die ersten i Koeffzienten jedes Datensatzes
   K_i = K(:,1:i);
   % Skalarmultiplikation zur Berechnung der Klassifikation fuer jeden
   % Datensatz, negativ => keine Gewichtsweste, positiv => Gewichtsweste
   r_i = K_i*c_i;
   % wenn das Ergebnis der Skalarmultiplikation der Koeffezienten eines
   % Datensatzes multipliziert mit der 1 bzw. -1 aus r negativ ist,
   % unterscheiden sich die Vorzeichen und der Datensatz wurde falsch
   % klassifiziert
   r_i = r_i.*r;
   for j=1:size(r_i)
       % Anzahl der negativen Werte in r_i ist die Anzahl der
       % Fehlklassifikationen mit den ersten i Werten von c
       if r_i(j) < 0
           misclassificationsCompleteData(i) = misclassificationsCompleteData(i)+1;
       end
   end
end

end

