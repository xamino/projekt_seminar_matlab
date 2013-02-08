clear;
clc;

%M = dlmread('AllMotionVectorsHampelmannMovedToZero.txt');
M = dlmread('AllMotionVectorsHampelmannMovedToZeroSizeNormalized.txt');

x = M(:,3)-M(:,29);