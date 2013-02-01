% Matcht s�mtliche MotionVektorDateien und bef�llt sie gewichtet in eine
% neue Datei

% Grundverzeichnis einlesen
dirData = dir('.');

% Leere Matrix- nachher Endergebnis
MotionVectors=[];

for i=1:(length(dirData))
    
    % Wenn es sich um einen Ordner handelt ->weitermachen
    if (dirData(i).isdir)
            
            % Den Pfad merken
            data = dir([dirData(i).name '/']);
            
            % S�mtliche Dateien durchlaufen
            for j=1:(length(data))
                dataname=data(j).name;
                
                % Den String suchen
                findstring = strfind(dataname, 'Hampelmann0normalizeMotionVectorCalc');
                
                if length(findstring)==0
                    % Kein Treffer
                    findstring = strfind(dataname, 'Hampelmann5normalizeMotionVectorCalc');
                    
                end
                    
                if length(findstring)==0
                    % immer noch kein Treffer
                else
                    % Treffer ->Datei lesen...
                   pfad= [dirData(i).name '/'];
                   M=dlmread([pfad dataname]);
                   
                   % �berpr�fen, welches Gewicht verwendet wurde
                   findWeight = strfind(dataname, '0')
                   if length(findWeight)==0;
                        Weight0=ones(1,1);
                       M=horzcat(Weight0,M);
                   else
                       Weight1=zeros(1,1);
                       M=horzcat(Weight1,M);
                   end
                   
                   
                   
                   
                   if size(MotionVectors,1)==0
                       MotionVectors=M;
                   else
                       % ...und an bisherige Datei anh�ngen
                       MotionVectors= vertcat(MotionVectors,M);
                   end
                   
                 
                end
            end
       
    else
    end
end
dlmwrite('AllMotionVectorCollcted.txt',MotionVectors);




