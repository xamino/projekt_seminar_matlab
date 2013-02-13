clear;
clc;

bewegung = 'Hampelmann';
% norm = 'MovedToZeroSizeNormalized';
norm = 'MovedToZero';

numWav = 2;
if numWav == 2
    numW = '2Sin';
else
    if numWav == 1
        numW = '';
    else
        numW = '2_1Sin';
    end
end

c = dlmread(['classifier' bewegung numW norm '.txt']);
V = dlmread(['eigenVectors' bewegung numW norm '.txt']);
[s,numEigenvectors]=size(V);
average = dlmread(['averageMotionVector' bewegung numW norm '.txt']);
u = dlmread(['uVector' bewegung numW norm '.txt']);

V = diag(u)*V;
alpha = 0.3*u;

motion1 = average'+(alpha*V*c);
motion2 = average'-alpha*V*c;

% frequenz bei beiden gleich setzen
freqInd = 140+numWav*2-1;
motion1(freqInd) = average(freqInd);
motion2(freqInd) = average(freqInd);

if numWav == 1
    [p0_0,eigenpostures0,sinVal0] = getHampelmannParameters(motion1');
    [p0_5,eigenpostures5,sinVal5] = getHampelmannParameters(motion2');
else
    if numWav == 2
        [p0_0,eigenpostures0,sinVal0] = getHampelmannParameters2(motion1');
        [p0_5,eigenpostures5,sinVal5] = getHampelmannParameters2(motion2');
    else
        [p0_0,eigenpostures0,sinVal0] = getHampelmannParameters2_1(motion1');
        [p0_5,eigenpostures5,sinVal5] = getHampelmannParameters2_1(motion2');
    end
end

numFrames = 700;

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

m = motion0;
for i=1:numFrames
   xDiff=0-m(i,25);
   zDiff=0-m(i,27);
   for j=1:3:48
        if j ~= 28
            % S�mtliche weiteren Werte des Frames werden angepasst
            m(i,j)=m(i,j)+xDiff;
            m(i,j+2)=m(i,j+2)+zDiff;
        end
   end
end
motion0 = m;

m = motion5;
for i=1:numFrames
   xDiff=0-m(i,25);
   zDiff=0-m(i,27);
   for j=1:3:48
        if j ~= 28
            % S�mtliche weiteren Werte des Frames werden angepasst
            m(i,j)=m(i,j)+xDiff;
            m(i,j+2)=m(i,j+2)+zDiff;
        end
   end
end
motion5 = m;


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

% % Film als .avi abspeichern
% writerObj = VideoWriter('syntheseHampelmannMovedToZeroSizeNormalized.avi');
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