clear;
clc;

c = dlmread('classifier.txt');
V = dlmread('eigenVectors.txt');
[s,numEigenvectors]=size(V);
average = dlmread('averageMotionVector.txt');
% u = dlmread('uVector.txt');
% U = ones(numEigenvectors,1)*u;
% V = U'.*V;

motion1 = average'+0.01*V*c;
motion2 = average'-0.01*V*c;

[p0_0,eigenpostures0,sinVal0] = getHampelmannParameters(motion1');
[p0_5,eigenpostures5,sinVal5] = getHampelmannParameters(motion2');

numFrames = 300;

resultScore0 = zeros(numFrames,2);
resultScore5 = zeros(numFrames,2);

for i=1:2
    reconst = zeros(1,numFrames);
    for j=1:1
        reconst = reconst + sinVal0(i,3*j-2)*sin((1:numFrames)*sinVal0(i,3*j-1)+sinVal0(i,3*j));
    end
    resultScore0(:,i) = reconst';
end

for i=1:2
    reconst = zeros(1,numFrames);
    for j=1:1
        reconst = reconst + sinVal5(i,3*j-2)*sin((1:numFrames)*sinVal5(i,3*j-1)+sinVal5(i,3*j));
    end
    resultScore5(:,i) = reconst';
end

P0_0 = ones(numFrames,1)*p0_0;
P0_5 = ones(numFrames,1)*p0_5;

motion0 = P0_0 + resultScore0*eigenpostures0';
motion5 = P0_5 + resultScore5*eigenpostures5';

for j=1:numFrames
    row0 = motion0(j,:);
    row5 = motion5(j,:);
    X0 = zeros(16,1);
    Y0 = zeros(16,1);
    X5 = zeros(16,1);
    Y5 = zeros(16,1);
    for i=1:16
        X0(i) = row0(((i-1)*3)+1);
        Y0(i) = row0(((i-1)*3)+2);
        X5(i) = row5(((i-1)*3)+1);
        Y5(i) = row5(((i-1)*3)+2);
    end
    plot(X0,Y0,'bo');
    hold on;
    axis equal;
    axis([-1 3 -1.2 1.5]);
    plot(X5+2,Y5,'bo');
    hold off;
    F(j)=getframe;
end

% Film als .avi abspeichern
writerObj = VideoWriter('synthese.avi');
writerObj.FrameRate = 25;
writerObj.Quality = 100;
open(writerObj);

for k = 1:numFrames
   writeVideo(writerObj,F(k));
end

close(writerObj);

movie(F,20,30);