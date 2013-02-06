clear;
clc;

M = dlmread('AllMotionVectorsHampelmannMovedToZeroSizeNormalized.txt');

x = M(:,3)-M(:,30);