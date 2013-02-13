clear;
clc;

% M = dlmread('AllMotionVectorCollcted.txt');

bewegung = 'Hampelmann';
% norm = 'MovedToZeroSizeNormalized';
norm = 'MovedToZero';

M = dlmread(['AllMotionVectors' bewegung norm '.txt']);

% M = M(7:24,:);

[numVect, numComp]= size(M(:,2:end));
averageMotionVector = mean(M(:,2:end));

[misclassificationsCompleteData,c,V,u] = classifyAll(M);

[misclassificationsMit,misclassificationsOhne,classifications] = takeOneAndClassify(M);
% [misclassificationsMit2,misclassificationsOhne2] = takeTwoAndClassify(M);

[m,indMin] = min(misclassificationsMit+misclassificationsOhne);

dlmwrite(['classifier' bewegung norm '.txt'],c(1:indMin));
dlmwrite(['eigenVectors' bewegung norm '.txt'],V(:,1:indMin)); %V hat Eigenvektoren in jeder Spalte
dlmwrite(['uVector' bewegung norm '.txt'],u);


hold all;
grid on;
axis([0 numVect 0 50])
xlabel('Anzahl der verwendeten Hauptkomponenten')
ylabel('Anzahl der Fehlklassifikationen in Prozent')
% plot(misclassificationsMit,'g-');
% plot(misclassificationsOhne,'y-');
plot(misclassificationsCompleteData/numVect*100,'b-');
plot((misclassificationsMit+misclassificationsOhne)/numVect*100,'r-');
% plot((misclassificationsMit2+misclassificationsOhne2)/numVect*100,'g-');
hold off;
