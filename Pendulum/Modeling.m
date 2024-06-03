M = .5;
m = .2;
b = .1;
L = .3;
I = .006;
g = 9.8;

P = (M+m)*I+M*m*L^2;

% 取θ=π为系统平衡点
% 创建系统状态方程
A = [0 1 0 0;
     0 -(I+m*L^2)*b/P (m^2*g*L^2)/P 0;
     0 0 0 1;
     0 -(m*L*b)/P (m*g*L*(M+m))/P 0];
B = [0;
     (I+m*L^2)/P;
     0;
     (m*L)/P];

C = [1 0 0 0;
     0 0 1 0];

D = [0;
     0];

states = {'x' 'x_dot' 'phi' 'phi_dot'};
inputs = {'u'};
outputs = {'x';'phi'};

sys_ss = ss(A,B,C,D,'statename',states,'inputname',inputs,'outputname',outputs);

% 创建系统传递函数
q = (M+m)*(I+m*L^2)-(m*L)^2;
s = tf('s');

P_cart = (((I+m*L^2)/q)*s^2 - (m*g*L/q))/(s^4 + (b*(I + m*L^2))*s^3/q - ((M + m)*m*g*L)*s^2/q - b*m*g*L*s/q);

P_pend = (m*L*s/q)/(s^3 + (b*(I + m*L^2))*s^2/q - ((M + m)*m*g*L)*s/q - b*m*g*L/q);

sys_tf = [P_cart ; P_pend];

inputs = {'u'};
outputs = {'x'; 'phi'};

set(sys_tf,'InputName',inputs)
set(sys_tf,'OutputName',outputs)


% 系统状态方程转化为传递函数
[num_tf , den_tf] = tfdata(sys_ss);
sys_ss2tf = tf(num_tf,den_tf);
[z_tf_pend , p_tf_pend , k_tf_pend] = zpkdata(P_pend,'v');
[z_tf_cart , p_tf_cart , k_tf_cart] = zpkdata(P_cart,'v');
[z_ss , p_ss , k_ss] = zpkdata(sys_ss,'v');
sys_tf2zpk_pend = zpk(z_tf_pend,p_tf_pend,k_tf_pend);
sys_tf2zpk_cart = zpk(z_tf_cart,p_tf_cart,k_tf_cart);
sys_ss2zpk = zpk(z_ss,p_ss,k_ss);