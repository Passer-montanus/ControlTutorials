% m mass                1.0 kg
% k spring constant     1.0 N/m
% b damping constant    0.2 Ns/m
% F input force         1.0 N

m = 1;
k = 1;
b = 0.2;
F = 1;

A = [0 1; -k/m -b/m];
B = [0 1/m]';
C = [1 0];
D = [0];

% 通过ss2tf和tfdata两种方式得到传递函数
sys_ss = ss(A,B,C,D)
[num, den] = ss2tf(A,B,C,D)
sys_tf = tf(num,den)
[num1, den1] = tfdata(sys_ss)
sys_tf1 = tf(num1,den1)

% 利用传递函数和系统矩阵分析系统的稳定性
p2 = pole(sys_tf1)
p1 = pole(sys_tf)
eig(A)

