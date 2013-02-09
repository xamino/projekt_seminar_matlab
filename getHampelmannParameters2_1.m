function [p0,eigenpostures,sinVal] = getHampelmannParameters2_1(hampelmannVector)
    p0 = [hampelmannVector(1:27),0,hampelmannVector(28),0,hampelmannVector(29:46)];
    eigenpostures(:,1) = [hampelmannVector(47:73),0,hampelmannVector(74),0,hampelmannVector(75:92)];
    eigenpostures(:,2) = [hampelmannVector(93:119),0,hampelmannVector(120),0,hampelmannVector(121:138)];
    amplitudes = hampelmannVector(139:141);
    frequency = hampelmannVector(142);
    phases = hampelmannVector(143:144);
    sinVal(1,:) = [amplitudes(1)  frequency   0          amplitudes(3)	frequency*2     phases(2)];
    sinVal(2,:) = [amplitudes(2)  frequency*2 phases(1)  0              0               0        ];
end

