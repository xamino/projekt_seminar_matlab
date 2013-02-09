function hampelmannVector = createHampelmannVector2(p0,eigenpostures,sinValues)
    p0 = [p0(1:27) p0(29) p0(31:end)];
    eig1 = eigenpostures(:,1);
    eig1 = [eig1(1:27) ; eig1(29) ; eig1(31:end)];
    eig2 = eigenpostures(:,2);
    eig2 = [eig2(1:27) ; eig2(29) ; eig2(31:end)];
    amplitudes = [sinValues(:,1); sinValues(:,4)];
    frequency = sinValues(1,2);
    phases = [sinValues(:,3); sinValues(:,6)];
    phases = phases';
    phases(2) = phases(2) - 2*phases(1);
    phases(3) = phases(3) - 2*phases(1);
    phases(4) = phases(4) - phases(1);
    hampelmannVector = [p0 eig1' eig2' amplitudes' frequency phases(2:4)];
end