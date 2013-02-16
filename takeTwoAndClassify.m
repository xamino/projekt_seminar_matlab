function [numMisclassificationsMit,numMisclassificationsOhne] = takeTwoAndClassify(M)
%
    r = M(:,1);
    r = 2*(r-0.5); % Statt 0 sollte -1 in r stehen
    completeM = M(:,2:end);
    [numVect, numComp]= size(completeM);
    
    numMisclassificationsMit = zeros(1,min(size(M)));
    numMisclassificationsOhne = zeros(1,min(size(M)));
    
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
        [~,~,classifications] = takeOneAndClassify(M_k);
        
        mit = M_k(2:2:end,:);
        ohne = M_k(1:2:end,:);
        classMit = classifications(2:2:end,:);
        classOhne = classifications(1:2:end,:);

        % Berechnung der Fehlklassifikationen in Abhaenigkeit von i
        for i=1:min(numVect-2,numComp)
           [~,indMit] = sort(classMit(:,i),'ascend');
           [~,indOhne] = sort(classOhne(:,i),'ascend');
           class = classifyMotion(vertcat(mit(indMit(1:end*2/4),:),ohne(indOhne(1:end*2/4),:)),completeM(2*k-1:2*k,:),i);
           for j=1:2
               if r(2*k-2+j) < 0 % Soll-Ergebnis ist -1
                   if class(j,i) > 0
                       numMisclassificationsMit(i) = numMisclassificationsMit(i)+1;
                   end
                   classifications(2*k-2+j,i) = class(j,i);
               else % Soll-Ergebnis ist 1
                   if class(j,i) < 0
                       numMisclassificationsOhne(i) = numMisclassificationsOhne(i)+1;
                   end  
                   classifications(2*k-2+j,i) = -class(j,i);
               end
           end
        end
    end

end

