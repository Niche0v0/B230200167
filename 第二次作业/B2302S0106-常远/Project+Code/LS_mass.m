function [sys,x0,str,ts,simStateCompliance] = LS_mass(t,x,u,flag)
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
sizes.NumOutputs     = 1;
sizes.NumInputs      = 4;
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
persistent Pk xk;
if(t == 0)
    Pk = 1;    
    xk = 1000;
end

% ��������
vx = u(1);
Fx = u(2);
ax_s = u(3);
az_s = u(4);

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

% ��������
yk = Fx - 0.5 * rou * Cd * A * vx^2;
hk = ax_s + f_r * az_s;

% ��С���˷�����
Pk = (Pk^(-1) + hk' * hk)^(-1);
xk = xk + Pk * hk' * (yk - hk * xk);

% ��Ȩ��С���˷������Ź������
sys = xk;

%% ������һ������ʱ��
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

%% ����
function sys=mdlTerminate(t,x,u)

sys = [];
