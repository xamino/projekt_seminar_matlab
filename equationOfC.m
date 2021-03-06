clear;
clc;

% M = dlmread('AllMotionVectorCollcted.txt');

bewegung = 'Seilhuepfen';
% norm = 'MovedToZeroSizeNormalized';
norm = 'MovedToZero';

M = dlmread(['AllMotionVectors' bewegung norm '.txt']);

% M = M(1:30,:);

[numVect, numComp]= size(M(:,2:end));
averageMotionVector = mean(M(:,2:end));

[misclassificationsCompleteData,c,V,u] = classifyAll(M);

[misclassificationsMit,misclassificationsOhne,classifications] = takeOneAndClassify(M);
%[misclassificationsMit2,misclassificationsOhne2] = takeTwoAndClassify(M);

[m,indMin] = min(misclassificationsMit+misclassificationsOhne);

c = c(1:indMin);
V = V(:,1:indMin);

dlmwrite(['classifier' bewegung norm '.txt'],c);
dlmwrite(['eigenVectors' bewegung norm '.txt'],V); %V hat Eigenvektoren in jeder Spalte
dlmwrite(['uVector' bewegung norm '.txt'],u);
dlmwrite(['averageMotionVector' bewegung norm '.txt'],averageMotionVector);

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
