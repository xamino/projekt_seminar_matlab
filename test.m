clc;
clear;
name = 'burkhard';
motionVector0 = dlmread([name 'Hampelmann/' name 'Hampelmann0normalizeMotionVectorCalc.txt']);
motionVector5 = dlmread([name 'Hampelmann/' name 'Hampelmann5normalizeMotionVectorCalc.txt']);

[p05,eig5,sinVal5] = getHampelmannParameters(motionVector5);
[p00,eig0,sinVal0] = getHampelmannParameters(motionVector0);

px = p05-p00;
eigx = eig5-eig0;
sinValx = sinVal5-sinVal0;

numFrames = 300;

resultScore0 = zeros(numFrames,2);
resultScore5 = zeros(numFrames,2);

for i=1:2
    reconst = zeros(1,numFrames);
    for j=1:1
        reconst = reconst + sinVal0(i,3*j-2)*sin((1:numFrames)*sinVal0(i,3*j-1)+pi/2);
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

subplot(2,1,1);
plot(resultScore0(:,1));
grid on;
hold all;
plot(resultScore0(:,2));
hold off;

subplot(2,1,2);
plot(resultScore5(:,1));
grid on;
hold all;
plot(resultScore5(:,2));
hold off;