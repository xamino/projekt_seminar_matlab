clear;
clc;

bewegung = 'Hampelmann';
numWav = 2;
norm = 'MovedToZero';

if strcmp(bewegung,'Seilhuepfen')
    numWav = 1;
    numW = '';
else
    if numWav == 1
        numW = '';
    else
        if numWav == 2
            numW = '2Sin';
        else
            numW = '2_1Sin';
        end
    end
end


M = dlmread(['AllMotionVectors' bewegung numW norm '.txt']);
% err = dlmread('sumMisclassificationsHampelmannMovedToZeroSizeNormalized.txt');

[numVect, numComp]= size(M);

ohne = zeros(numVect/2, numComp-1);
mit = zeros(numVect/2, numComp-1);
% oErr = zeros(numVect/2,1);
% mErr = zeros(numVect/2,1);

o = 1;
m = 1;
for i=1:numVect
    if M(i,1) == 0
        ohne(o,:) = M(i,2:end);
        % oErr(o) = err(i);
        o=o+1;
    else
        mit(m,:) = M(i,2:end);
        % mErr(m) = err(i);
        m=m+1;
    end
end

% [oErr,oInd] = sort(oErr,'ascend');
% [mErr,mInd] = sort(mErr,'ascend');
% 
% for i=1:numVect/2
%     ohne(:,i) = ohne(oInd,i);
%     mit(:,i) = mit(mInd,i);
% end

% ohne = ohne(1:numVect/2,:);
% mit = mit(1:numVect/2,:);

av0 = mean(ohne);
av1 = mean(mit);

diff = av0-av1;

% frequenz anpassen
if strcmp(bewegung,'Hampelmann')
    freqInd = 140+numWav*2-1;
else
    freqInd = [141,142];
end

diff(freqInd) = 1/10*diff(freqInd);

avGes = (av0+av1)/2;

alpha = 10;

motion1 = avGes+alpha*diff;
motion2 = avGes-alpha*diff;


if strcmp(bewegung,'Seilhuepfen')
    [p0_0,eigenpostures0,sinVal0] = getSeilhuepfenParameters(motion1);
    [p0_5,eigenpostures5,sinVal5] = getSeilhuepfenParameters(motion2);
else
    if strcmp(numW,'2_1Sin')
        [p0_0,eigenpostures0,sinVal0] = getHampelmannParameters2_1(motion1);
        [p0_5,eigenpostures5,sinVal5] = getHampelmannParameters2_1(motion2);
    else
        if strcmp(numW,'2Sin')
            [p0_0,eigenpostures0,sinVal0] = getHampelmannParameters2(motion1);
            [p0_5,eigenpostures5,sinVal5] = getHampelmannParameters2(motion2);
        else
            if strcmp(numW,'')
                [p0_0,eigenpostures0,sinVal0] = getHampelmannParameters(motion1);
                [p0_5,eigenpostures5,sinVal5] = getHampelmannParameters(motion2);
            end
        end
    end
end

numFrames = 600;

resultScore0 = zeros(numFrames,2);
resultScore5 = zeros(numFrames,2);

for i=1:2
    reconst = zeros(1,numFrames);
    for j=1:ceil(numWav)
        reconst = reconst + sinVal0(i,3*j-2)*sin((1:numFrames)*sinVal0(i,3*j-1)+sinVal0(i,3*j));
    end
    resultScore0(:,i) = reconst';
end

for i=1:2
    reconst = zeros(1,numFrames);
    for j=1:ceil(numWav)
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
    axis([-1 3 -1.5 1.7]);
    plot(X5+2,Y5,'bo');
    hold off;
    F(j)=getframe;
end

% % Film als .avi abspeichern
% writerObj = VideoWriter('synthese2HampelmannMovedToZeroSizeNormalized.avi');
% writerObj.FrameRate = 25;
% writerObj.Quality = 100;
% open(writerObj);
% 
% for k = 1:numFrames
%    writeVideo(writerObj,F(k));
% end
% 
% close(writerObj);
% 
% movie(F,20,30);