function [p0,eigenpostures,sinVal] = getSeilhuepfenParameters(seilhuepfenVector)
    p0 = [seilhuepfenVector(1:27),0,seilhuepfenVector(28),0,seilhuepfenVector(29:46)];
    eigenpostures(:,1) = [seilhuepfenVector(47:73),0,seilhuepfenVector(74),0,seilhuepfenVector(75:92)];
    eigenpostures(:,2) = [seilhuepfenVector(93:119),0,seilhuepfenVector(120),0,seilhuepfenVector(121:138)];
    amplitudes = seilhuepfenVector(139:140);
    frequencies = seilhuepfenVector(141:142);
    phase = seilhuepfenVector(143);
    sinVal(1,:) = [amplitudes(1) frequencies(1) 0];
    sinVal(2,:) = [amplitudes(2) frequencies(2) phase];
end

