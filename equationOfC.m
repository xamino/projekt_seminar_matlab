clear;
clc;

% M = dlmread('AllMotionVectorCollcted.txt');

bewegung = 'Hampelmann2_1Sin';
% norm = 'MovedToZeroSizeNormalized';
norm = 'MovedToZero';

M = dlmread(['stdUMotionVector' bewegung norm '.txt']);

% M = M(7:24,:);

r = M(:,1);
r = 2*(r-0.5); % Statt 0 sollte -1 in r stehen
completeM = M(:,2:end);

[numVect, numComp]= size(completeM);

[V,K,Variances] = princomp(completeM);

averageMotionVector = mean(completeM(:,:));

dlmwrite(['averageMotionVector' bewegung norm '.txt'],averageMotionVector);

% Klassifikator c berechnen
% entweder cK=r oder Kc=r loesen
% c = K\r;
c = r'/K';
c = c';

dlmwrite(['classifier' bewegung norm '.txt'],c);
dlmwrite(['eigenVectors' bewegung norm '.txt'],V); %V hat Eigenvektoren in jeder Spalte

%Fehlklassifikationen mit komplettem Datensatz ermitteln
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

%Fehlklassifikationen mit Teildatensatz ermitteln
misclassificationsMit = zeros(1,min(numVect,numComp));
misclassificationsOhne = zeros(1,min(numVect,numComp));

specificMisclassifications = zeros(numVect,numVect);

for k=1:numVect/2
    % entsprechend k werden 2 Zeilen (also die beiden Datensaetze einer
    % Person) aus M entfernt. M_k ist M ohne diese beiden Zeilen
    if 1==k
       M_k=M(3:end,:);
    else
        if k==numVect/2
            M_k=M(1:end-2,:);
        else
            M_k = vertcat(M(1:2*(k-1),:),M(2*k+1:end,:));
        end
    end
    % Klassifikator fuer M_k berechnen
    r_k = M_k(:,1);
    r_k = 2*(r_k-0.5);
    M_k = M_k(:,2:end);
    average_k = mean(M_k(:,:));
    [V_k,K_k,Variances_k] = princomp(M_k);
    % c_k ist der Klassifikator fuer M_k
    c_k = K_k\r_k;
    
    % k_k ist die Projektion der beiden Datensaetze, die vorher entfernt
    % wurden auf die Eigenvektoren der restlichen Datensaetze
    k_k = (completeM(2*k-1:2*k,:)-ones(2,1)*average_k)/V_k';
    
    % Berechnung der Fehlklassifikationen in Abhaenigkeit von i wie oben
    for i=1:min(numVect,numComp)
       c_ki = c_k(1:i);
       k_ki = k_k(:,1:i);
       r_ki = k_ki*c_ki;
       for j=1:2
           if r_ki(j) < 0
               if r(2*k-2+j) > 0
                   misclassificationsMit(i) = misclassificationsMit(i)+1;
                   specificMisclassifications(2*k-2+j,i) = 1;
               end
           else
               if r(2*k-2+j) < 0
                   misclassificationsOhne(i) = misclassificationsOhne(i)+1;
                   specificMisclassifications(2*k-2+j,i) = 1;
               end  
           end
       end
    end
end


sumSpecMis = sum(specificMisclassifications');
sumSpecMis = sumSpecMis';

dlmwrite(['sumMisclassifications' bewegung norm '.txt'],sumSpecMis);

hold all;
grid on;
axis([0 numVect 0 50])
xlabel('Anzahl der verwendeten Hauptkomponenten')
ylabel('Anzahl der Fehlklassifikationen in Prozent')
% plot(misclassificationsMit,'g-');
% plot(misclassificationsOhne,'y-');
plot(misclassificationsCompleteData/numVect*100,'b-');
plot((misclassificationsMit+misclassificationsOhne)/numVect*100,'r-');
hold off;
