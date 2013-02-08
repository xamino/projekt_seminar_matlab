clc;
clear;

name = 'oemer';
bewegung = 'Hampelmann';
norm = 'MovedToZeroSizeNormalized';
% norm = 'MovedToZero';

numWav = 2;

if numWav == 2
    numW = '2Sin';
else
    numW = '';
end

figure('position',[50 50 800 600],'Name',[name ' ' bewegung ' Vergleich mit/ohne Gewichtsweste'],'NumberTitle','off');

numFrames = 600;

pfad = [name bewegung '/'];
filename = [name bewegung];

motionVector0 = dlmread([pfad filename '0' numW norm 'MotionVectorCalc.txt']);

% name = 'serife';
% pfad = [name bewegung '/'];
% filename = [name bewegung];

motionVector5 = dlmread([pfad filename '5' numW norm 'MotionVectorCalc.txt']);

if numWav == 1
    [p0_0,eigenpostures0,sinVal0] = getHampelmannParameters(motionVector0);
    [p0_5,eigenpostures5,sinVal5] = getHampelmannParameters(motionVector5);
else
    [p0_0,eigenpostures0,sinVal0] = getHampelmannParameters2(motionVector0);
    [p0_5,eigenpostures5,sinVal5] = getHampelmannParameters2(motionVector5);
end

resultScore0 = zeros(numFrames,2);
resultScore5 = zeros(numFrames,2);

for i=1:2
    reconst = zeros(1,numFrames);
    for j=1:numWav
        reconst = reconst + sinVal0(i,3*j-2)*sin((1:numFrames)*sinVal0(i,3*j-1)+sinVal0(i,3*j));
    end
    resultScore0(:,i) = reconst';
end

for i=1:2
    reconst = zeros(1,numFrames);
    for j=1:numWav
        reconst = reconst + sinVal5(i,3*j-2)*sin((1:numFrames)*sinVal5(i,3*j-1)+sinVal5(i,3*j));
    end
    resultScore5(:,i) = reconst';
end

P0_0 = ones(numFrames,1)*p0_0;
P0_5 = ones(numFrames,1)*p0_5;

motion0 = P0_0 + resultScore0*eigenpostures0';
motion5 = P0_5 + resultScore5*eigenpostures5';

M0 = dlmread([pfad filename '0' norm '.txt']);
[numF0,numC0] = size(M0);
M5 = dlmread([pfad filename '5' norm '.txt']);
[numF5,numC5] = size(M5);

for j=1:min([numFrames numF0 numF5]);
    row0 = motion0(j,:);
    row5 = motion5(j,:);
    X0 = zeros(16,1);
    Y0 = zeros(16,1);
    X5 = zeros(16,1);
    Y5 = zeros(16,1);
    rowM0 = M0(j,:);
    rowM5 = M5(j,:);
    XM0 = zeros(16,1);
    YM0 = zeros(16,1);
    XM5 = zeros(16,1);
    YM5 = zeros(16,1);
    for i=1:16
        X0(i) = row0(((i-1)*3)+1);
        Y0(i) = row0(((i-1)*3)+2);
        X5(i) = row5(((i-1)*3)+1);
        Y5(i) = row5(((i-1)*3)+2);
        XM0(i) = rowM0(((i-1)*3)+1);
        YM0(i) = rowM0(((i-1)*3)+2);
        XM5(i) = rowM5(((i-1)*3)+1);
        YM5(i) = rowM5(((i-1)*3)+2);
    end
    plot(X0,Y0,'bo');
    hold on;
    axis equal;
    plot(XM0,YM0,'k.');
    axis([-1 3 -1.2 1.3]);
    plot(X5+2,Y5,'bo');
    plot(XM5+2,YM5,'k.');
    hold off;
    F(j)=getframe;
end

% % Film als .avi abspeichern
% writerObj = VideoWriter([pfad 'Verlgeich_Gewicht_' filename '.avi']);
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