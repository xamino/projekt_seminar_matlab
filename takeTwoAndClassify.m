function [numMisclassificationsMit,numMisclassificationsOhne] = takeTwoAndClassify(M)
%

    [numVect, numComp]= size(M);
    
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
    end

end

