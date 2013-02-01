clear;
clc;

% M = dlmread('AllMotionVectorCollcted.txt');
M = dlmread('stdUMotionVector.txt');

r = M(:,1);
completeM = M(:,2:end);

[numVect, numComp]= size(completeM);

[V,K,Variances] = princomp(completeM);

misclassifications = zeros(1,numVect-4);

for k=1:numVect/2
    if 1==k
       K_k=K(3:end,:);
       r_k=r(3:end,:);
    else
        if k==numVect/2
            K_k=K(1:end-2,:);
            r_k=r(1:end-2,:);
        else
            K_k = vertcat(K(1:2*(k-1),:),K(2*k+1:end,:));
            r_k = vertcat(r(1:2*(k-1),:),r(2*k+1:end,:));
        end
    end
    
    for i=1:numVect-4
        K_ki = K_k(:,1:i);
        class1 = classify(K(2*k-1,1:i),K_ki,r_k);
        if class1 ~= r(2*k-1)
            misclassifications(i) = misclassifications(i)+1;
        end
        class2 = classify(K(2*k,1:i),K_ki,r_k);
        if class2 ~= r(2*k)
            misclassifications(i) = misclassifications(i)+1;
        end
    end
end

plot(misclassifications);
axis([1 35 1 20]);