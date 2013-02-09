clear;
clc;

x = 0:0.1:10;

a1 = 1;
a2 = 0.5;
f1 = 2.2;
f2 = 5.2;
p1 = 2.5;
p2 = 1;

w_1 = a1*sin(f1*x+p1);
w_2 = a2*sin(f2*x+p2);

subplot(2,1,1);
hold all;
plot(x,w_1);
plot(x,w_2);
hold off;

p2 = p2-f2*p1/f1;
p1 = 0;

w_1_ = a1*sin(f1*x+p1);
w_2_ = a2*sin(f2*x+p2);

subplot(2,1,2);
hold all;
plot(x,w_1_);
plot(x,w_2_);
hold off;