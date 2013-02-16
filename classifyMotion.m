function class = classifyMotion(M,eingabe,ind)
% klassifiziert 

[numVect,numComp] = size(M);
class = zeros(2,min(numVect+2,numComp));

% durch Standardabweichungen teilen
[M,u] = divideByStdDeviation(M);

% Klassifikator fuer M berechnen
r = M(:,1);
r = 2*(r-0.5);
M = M(:,2:end);
average = mean(M(:,:));
[V,K] = princomp(M);
% c ist der Klassifikator fuer M
c = K\r;

% k ist die Projektion der Eingaben, auf die Eigenvektoren der restlichen Datensaetze,
% zusaetzlich werden die Datensaetze vorher noch durch die
% Standardabweichnungen der anderen Datensaetze geteilt
k = (eingabe./(ones(2,1)*u)-ones(2,1)*average)/V';

if nargin == 3
    start = ind;
    ende = ind;
else
    start = 1;
    ende = min(numVect+2,numComp);
end

% Berechnung der Fehlklassifikationen in Abhaenigkeit von i
for i=start:ende
   c_i = c(1:i);
   k_i = k(:,1:i);
   class(:,i) = k_i*c_i;
end

end

