% erstellt fuer jeden Datensatz einen Motionvector und sammelt diese in
% einer Matrix, außerdem wird der Komprimierungsfehler dokumentiert
clear;
clc;

bewegung = 'Hampelmann';

startFactor = 0;
endFactor = 1;

numEigenvectors = 2;
% Anzahl der Eigenvektoren, die verwendet werden sollen
% Definitionsbereich = {1,...,numComp}

numWav = 2;
% Anzahl der Sinuswellen, die in der angenäherten Koeffizientenfunktion enthalten sein sollen
% Definitionsbereich = {1,...,numFrames/2} (Fouriertransformation) oder {1,...,8} (fit)

if numWav == 2
    numW = '2Sin';
else
    numW = '';
end

for n = 1:2
    
    switch n
        case 1
            norm = 'MovedToZero';
        otherwise
            norm = 'MovedToZeroSizeNormalized';
    end

    % Leere Matrix
    MotionVectors=[];

    % Grundverzeichnis einlesen
    dirData = dir('.');

    for j=1:(length(dirData))

        % Wenn es sich um einen Ordner handelt ->weitermachen
        if (dirData(j).isdir)

            name = dirData(j).name;

            %entweder Hampelmann oder Seilhuepfen
            findstring = strfind(name, bewegung);
            if ~isempty(findstring)
            % gewuenschte Bewegung
                
                % Fuer mit und ohne Gewicht
                for g = [0,5]
                    M = dlmread([name '/' name int2str(g) norm '.txt']);

                    M = M(end*startFactor+1:end*endFactor,:);
                    % Weglassen von Frames

                    [numFrames, numComp]= size(M);
                    %numComp ist die Anzahl der Dimensionen der Vektoren, die eine einzelne Pose beschreiben
                    %numFrames ist die Anzahl der Posen/Frames aus den Testdaten

                    [COEFF,SCORE,LATENT] = princomp(M); % Hauptkomponentenanlyse

                    % fehler durch pca
                    err = zeros(2,numEigenvectors);
                    err(1,:) = 100/sum(LATENT).*LATENT(1:numEigenvectors);


                    p0 = mean(M(:,1:numComp)); % Durchschnittspose bestimmen

                    SCORE = SCORE(:,1:numEigenvectors); % Weglassen der nicht benötigten Koeffizienten
                    COEFF = COEFF(:,1:numEigenvectors); % Weglassen der nicht benötigten Eigenvektoren

                    val = zeros(numEigenvectors, numWav*3);

                    x = 1:numFrames;

                    for i=1:numEigenvectors
                       [fun,gof] = fit(x',SCORE(:,i),['sin' int2str(numWav)]);
                       val(i,:) = coeffvalues(fun);

                       err(2,i) = gof.rsquare; % error caused by fit
                    end
                    
                    if numWav == 1 || 0.03 > max([abs(val(1,2)/(val(1,5)/2)-1) abs(val(1,2)/(val(2,2)/2)-1) abs(val(1,2)/val(2,5)-1)])
                        dlmwrite([name '/' name int2str(g) numW norm 'Error.txt'],err);

                        if strcmp(bewegung,'Hampelmann')
                            if numWav == 1
                                motionVector = createHampelmannVector(p0,COEFF,val);
                            else
                                motionVector = createHampelmannVector2(p0,COEFF,val);
                            end
                        end

                        dlmwrite([name '/' name int2str(g) numW norm 'MotionVectorCalc.txt'],motionVector);
                        
                        if g == 0
                            motionVector0 = [0 motionVector];
                        else
                            motionVector5 = [1 motionVector];
                            if size(MotionVectors,1)==0
                                MotionVectors=motionVector0;
                            else
                                % ...und an bisherige Datei anhängen
                                MotionVectors= vertcat(MotionVectors,motionVector0);
                            end
                            MotionVectors= vertcat(MotionVectors,motionVector5);
                        end
                    else
                        ['keine akzeptable Anpassung der Sinuswerte bei ' name]
                        break;
                    end
                end
            end
        end
    end
    dlmwrite(['AllMotionVectors' bewegung numW norm '.txt'],MotionVectors);
end