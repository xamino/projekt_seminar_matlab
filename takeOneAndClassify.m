function [numMisclassificationsMit,numMisclassificationsOhne,classifications] = takeOneAndClassify(M)
% Eingabe: M hat in jeder Zeile jeweils den Motionvector einer Testperson,
% in der ersten Spalte sollte die 0/1 stehen, die angibt, ob der Datensatz
% mit oder ohne Gewichtsweste erstellt wurde.

    r = M(:,1);
    r = 2*(r-0.5); % Statt 0 sollte -1 in r stehen
    completeM = M(:,2:end);
    
    [numVect, numComp]= size(completeM);
    
    numMisclassificationsMit = zeros(1,min(numVect,numComp));
    numMisclassificationsOhne = zeros(1,min(numVect,numComp));

    classifications = zeros(numVect,numVect);

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
        % durch Standardabweichungen teilen
        [M_k,u_k] = divideByStdDeviation(M_k);
        % Klassifikator fuer M_k berechnen
        r_k = M_k(:,1);
        r_k = 2*(r_k-0.5);
        M_k = M_k(:,2:end);
        average_k = mean(M_k(:,:));
        [V_k,K_k] = princomp(M_k);
        % c_k ist der Klassifikator fuer M_k
        c_k = K_k\r_k;

        % k_k ist die Projektion der beiden Datensaetze, die vorher entfernt
        % wurden auf die Eigenvektoren der restlichen Datensaetze,
        % zusaetzlich werden die Datensaetze vorher noch durch die
        % Standardabweichnungen der anderen Datensaetze geteilt
        k_k = (completeM(2*k-1:2*k,:)./(ones(2,1)*u_k)-ones(2,1)*average_k)/V_k';

        % Berechnung der Fehlklassifikationen in Abhaenigkeit von i
        for i=1:min(numVect,numComp)
           c_ki = c_k(1:i);
           k_ki = k_k(:,1:i);
           r_ki = k_ki*c_ki;
           for j=1:2
               if r(2*k-2+j) < 0 % Soll-Ergebnis ist -1
                   if r_ki(j) > 0
                       numMisclassificationsMit(i) = numMisclassificationsMit(i)+1;
                   end
                   classifications(2*k-2+j,i) = r_ki(j);
               else % Soll-Ergebnis ist 1
                   if r_ki(j) < 0
                       numMisclassificationsOhne(i) = numMisclassificationsOhne(i)+1;
                   end  
                   classifications(2*k-2+j,i) = -r_ki(j);
               end
           end
        end
    end
end

