% erstellt fuer jeden Datensatz einen Motionvector und sammelt diese in
% einer Matrix, außerdem wird der Komprimierungsfehler dokumentiert
clear;
clc;

bewegung = 'Seilhuepfen';

startFactor = 0;
endFactor = 1;

numEigenvectors = 2;
% Anzahl der Eigenvektoren, die verwendet werden sollen
% Definitionsbereich = {1,...,numComp}

numWav = 2;
% Anzahl der Sinuswellen, die in der angenäherten Koeffizientenfunktion enthalten sein sollen
% 1.5 soll hierbei bedeuten, dass bei den Koeffizienten des ersten
% Eigenvektors 2 Sinuswellen benutzt werden, bei denen des zweiten jedoch
% nur eine

if strcmp(bewegung,'Seilhuepfen')
    numWav = 1;
end

if numWav == 2
    numW = '2Sin';
else
    if numWav == 1.5
        numW = '2_1Sin';
    else
        numW = '';
    end
end

for n = 1:2
    
    switch n
        case 1
            norm = 'MovedToZero';
        otherwise
            norm = 'MovedToZeroSizeNormalized';
    end
    
    firstRead = true;

    % Leere Matrix
    MotionVectors = [];
    totalErr = [];

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

                    % fehler durch pca und fit
                    err = zeros(2,length(LATENT));
                    err(1,:) = 1/sum(LATENT).*LATENT;


                    p0 = mean(M(:,1:numComp)); % Durchschnittspose bestimmen

                    SCORE = SCORE(:,1:numEigenvectors); % Weglassen der nicht benötigten Koeffizienten
                    COEFF = COEFF(:,1:numEigenvectors); % Weglassen der nicht benötigten Eigenvektoren

                    val = zeros(numEigenvectors, 3*ceil(numWav));

                    x = 1:numFrames;

                    for i=1:numEigenvectors
                        if numWav == 1.5
                            numSin = 3-i;
                        else
                            numSin = numWav;
                        end
                       [fun,gof] = fit(x',SCORE(:,i),['sin' int2str(numSin)]);
                       val(i,1:numSin*3) = coeffvalues(fun);

                       err(2,i) = gof.rsquare; % error caused by fit
                    end
                    
                    if strcmp(bewegung,'Seilhuepfen') || ((numWav == 1 && 0.01 > abs(val(1,2)/(val(2,2)/2)-1))...
                        || (numWav == 2 && 0.03 > max([abs(val(1,2)/(val(1,5)/2)-1) abs(val(1,2)/(val(2,2)/2)-1) abs(val(1,2)/val(2,5)-1)]))...
                        || (numWav == 1.5 && 0.01 > max([abs(val(1,2)/(val(1,5)/2)-1) abs(val(1,2)/(val(2,2)/2)-1)])))
                        
                        dlmwrite([name '/' name int2str(g) numW norm 'Error.txt'],err);
                        

                        if strcmp(bewegung,'Hampelmann')
                            if numWav == 1
                                motionVector = createHampelmannVector(p0,COEFF,val);
                            else
                                if numWav == 2
                                    motionVector = createHampelmannVector2(p0,COEFF,val);
                                else
                                    motionVector = createHampelmannVector2_1(p0,COEFF,val);
                                end
                            end
                        else
                            motionVector = createSeilhuepfenVector(p0,COEFF,val);
                        end

                        dlmwrite([name '/' name int2str(g) numW norm 'MotionVectorCalc.txt'],motionVector);
                        
                        if g == 0
                            motionVector0 = [0 motionVector];
                            % Gesamtfehler , Fehler der pca
                            totalErr0 = [sum(err(1,:).*err(2,:)) , sum(err(1,1:numEigenvectors)) , 0];
                            % Fehler durch fit
                            totalErr0(3) = totalErr0(1)/totalErr0(2);
                        else
                            motionVector5 = [1 motionVector];
                            % Gesamtfehler , Fehler der pca
                            totalErr5 = [sum(err(1,:).*err(2,:)) , sum(err(1,1:numEigenvectors)) , 0];
                            % Fehler durch fit
                            totalErr5(3) = totalErr5(1)/totalErr5(2);
                            if size(MotionVectors,1)==0
                                MotionVectors=motionVector0;
                                totalErr = totalErr0;
                            else
                                % ...und an bisherige Datei anhängen
                                MotionVectors= vertcat(MotionVectors,motionVector0);
                                totalErr = vertcat(totalErr,totalErr0);
                            end
                            MotionVectors= vertcat(MotionVectors,motionVector5);
                            totalErr = vertcat(totalErr,totalErr5);
                            
                            % Namen aller Testpersonen, deren Daten verwendet
                            % werden in Datei schreiben
                            if firstRead
                                fid = fopen(['AlleTestpersonen' bewegung numW norm '.txt'], 'w+');
                                firstRead = false;
                            else
                                fid = fopen(['AlleTestpersonen' bewegung numW norm '.txt'], 'a+');
                            end
                            fprintf(fid, '%s\n', name);
                            fclose(fid);
                        end
                    else
                        ['keine akzeptable Anpassung der Sinuswerte bei ' name]
                        break;
                    end
                end
            end
        end
    end
    
    totalErr = vertcat(totalErr,[min(totalErr);max(totalErr);mean(totalErr)]);
    
    dlmwrite(['AllMotionVectors' bewegung numW norm '.txt'],MotionVectors);
    dlmwrite(['Errors' bewegung numW norm '.txt'],totalErr);
end