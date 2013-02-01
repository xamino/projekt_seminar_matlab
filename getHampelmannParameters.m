function [p0,eigenpostures,sinVal] = getHampelmannParameters(hampelmannVector)
    p0 = [hampelmannVector(1:27),0,hampelmannVector(28),0,hampelmannVector(29:46)];
    eigenpostures(:,1) = [hampelmannVector(47:73),0,hampelmannVector(74),0,hampelmannVector(75:92)];
    eigenpostures(:,2) = [hampelmannVector(93:119),0,hampelmannVector(120),0,hampelmannVector(121:138)];
    sinVal(1,:) = [hampelmannVector(139) hampelmannVector(141) pi/2];
    sinVal(2,:) = [hampelmannVector(140) hampelmannVector(141)*2 pi/2];
end

