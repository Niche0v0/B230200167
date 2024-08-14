function [sys,x0,str,ts,simStateCompliance] = WLS_slope(t,x,u,flag)
switch flag,
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;
  case 1,
    sys=mdlDerivatives(t,x,u);
  case 2,
    sys=mdlUpdate(t,x,u);
  case 3,
    sys=mdlOutputs(t,x,u);
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);
  case 9,
    sys=mdlTerminate(t,x,u);
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));
end

%% ��ʼ��
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3;
sizes.NumInputs      = 9;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

x0  = [];
str = [];
ts  = [0.02 0];
simStateCompliance = 'UnknownSimState';

%% ��������״̬�ĵ���
function sys=mdlDerivatives(t,x,u)

sys = [];


%% ������ɢ��״̬����
function sys=mdlUpdate(t,x,u)

sys = [];


%% �������
function sys=mdlOutputs(t,x,u)
% ��̬�������ֵ�ı�������
persistent Yk1 Yk2 Yk3 Hk1 Hk2 Hk3 xk1 xk2 xk3;
if(t == 0)
    Yk1 = [];    
    Hk1 = [];
    Yk2 = [];    
    Hk2 = [];
    Yk3 = [];    
    Hk3 = [];
    xk1 = 0.05;
    xk2 = 0.05;
    xk3 = 0.05;
end

% ��������
vx = u(1);
Fx = u(2);
ax_s = u(3);
az_s = u(4);
ax = u(5);
m1 = u(6);
m2 = u(7);
m3 = u(8);

% ��������
if(t == 0)
    run Parameter.m;
end
global Para_Sim;
global Para_Long;
T = Para_Sim.T;                     % ��������
rou = Para_Long.air_mass_density;   % �����ܶ�,kg/m^3
A = Para_Long.frontal_area;         % ӭ�����,m^2
Cd = Para_Long.aerodynamic_Coeff;   % ����ϵ��
g = Para_Long.gravity_acc;      	% �������ٶ�,m/s^2
f_r = Para_Long.roll_resistance;    % ��������

% WLS��������
gamma = 0.01;                        % HuberȨ��ϵ��
c = 1000;                              % Tukey's biweightȨ��ϵ��
eps = 1000;                         % �˺���Ȩ��ϵ��

% ����������
yk1 = Fx - m1 * ax - 0.5 * rou * Cd * A * vx^2;
hk1 = m1 * g;
Yk1 = [Yk1; yk1];
Hk1 = [Hk1; hk1];
yk2 = Fx - m2 * ax - 0.5 * rou * Cd * A * vx^2;
hk2 = m2 * g;
Yk2 = [Yk2; yk2];
Hk2 = [Hk2; hk2];
yk3 = Fx - m3 * ax - 0.5 * rou * Cd * A * vx^2;
hk3 = m3 * g;
Yk3 = [Yk3; yk3];
Hk3 = [Hk3; hk3];

% Ȩ�ؾ������
% ����Huber������Ȩ�ظ���
E = abs(Yk1 - Hk1 * xk1);
wk1 = zeros(size(E));
wk1(E <= gamma) = 1;
wk1(E > gamma) = gamma ./ E(E > gamma);
% ����Tukey's biweight������Ȩ�ظ���
wk2 = (1 - ((Yk2 - Hk2 * xk2) / c).^2).^2;
% ���ں˺�����Ȩ�ظ���
wk3 = exp(-(Yk3 - Hk3 * xk3).^2 / (2 * eps^2));

Wk1 = diag(wk1);
Wk2 = diag(wk2);
Wk3 = diag(wk3);

% ��Ȩ��С���˷�����
xk1 = (Hk1' * Wk1 * Hk1)^(-1) * Hk1' * Wk1 * Yk1;
xk2 = (Hk2' * Wk2 * Hk2)^(-1) * Hk2' * Wk2 * Yk2;
xk3 = (Hk3' * Wk3 * Hk3)^(-1) * Hk3' * Wk3 * Yk3;

% ��Ȩ��С���˷������Ź������
sys = [asin(xk1 / sqrt(1 + f_r^2)) - atan(f_r);...
       asin(xk2 / sqrt(1 + f_r^2)) - atan(f_r);...
       asin(xk3 / sqrt(1 + f_r^2)) - atan(f_r)];


%% ������һ������ʱ��
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

%% ����
function sys=mdlTerminate(t,x,u)

sys = [];
