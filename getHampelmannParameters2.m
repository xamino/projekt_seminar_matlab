function [p0,eigenpostures,sinVal] = getHampelmannParameters2(hampelmannVector)
    p0 = [hampelmannVector(1:27),0,hampelmannVector(28),0,hampelmannVector(29:46)];
    eigenpostures(:,1) = [hampelmannVector(47:73),0,hampelmannVector(74),0,hampelmannVector(75:92)];
    eigenpostures(:,2) = [hampelmannVector(93:119),0,hampelmannVector(120),0,hampelmannVector(121:138)];
    amplitudes = hampelmannVector(139:142);
    frequency = hampelmannVector(143);
    phases = hampelmannVector(144:147);
    sinVal(1,:) = [amplitudes(1) frequency phases(1) amplitudes(3) frequency*2 phases(3)];
    sinVal(2,:) = [amplitudes(2) frequency*2 phases(2) amplitudes(4) frequency phases(4)];
end

