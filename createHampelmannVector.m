function hampelmannVector = createHampelmannVector(p0,eigenpostures,sinValues)
    p0 = [p0(1:27) p0(29) p0(31:end)];
    eig1 = eigenpostures(:,1);
    eig1 = [eig1(1:27) ; eig1(29) ; eig1(31:end)];
    eig2 = eigenpostures(:,2);
    eig2 = [eig2(1:27) ; eig2(29) ; eig2(31:end)];
    amplitudes = sinValues(:,1);
    frequency = sinValues(1,2);
    if 0 > sin(pi-sinValues(1,3)*2+sinValues(2,3)) %Mathematik
        eig2 = (-1)*eig2;
    end
    hampelmannVector = [p0 eig1' eig2' amplitudes' frequency];
end