clc;
close all;
%% ���ݶ�ȡ
m_ref = out.simout(:, 1);
m_wls1 = out.simout(:, 2);
m_wls2 = out.simout(:, 3);
m_wls3 = out.simout(:, 4);
m_ls = out.simout(:, 5);
slope_ref = out.simout(:, 6);
slope_wls1 = out.simout(:, 7);
slope_wls2 = out.simout(:, 8);
slope_wls3 = out.simout(:, 9);
slope_ls = out.simout(:, 10);
time = out.simout(:, 11);

%% ��ͼ
wordsize = 10;
% ��������
figure(1);
set(gcf,'Units','centimeters', 'position',[1 5 12 12]);
set(gca, 'FontSize', wordsize, 'FontName', 'Times', 'position',[.15 .4 .8 .4]);
plot(time, m_ref, 'k', 'linewidth', 1.2);
hold on;
plot(time, m_wls1, 'r', 'linewidth', 1.2);
hold on;
plot(time, m_wls2, 'b', 'linewidth', 1.2);
hold on;
plot(time, m_wls3, 'color', [34,139,34]/255, 'linewidth', 1.2);
hold on;
plot(time, m_ls, 'color', [218,165,32]/255, 'linewidth', 1.2);
legend('ʵ������', 'WLSM: Huber��������', 'WLSM: Tukey biweight��������', 'WLSM: �˺�������', 'LSM');
title('���ڲ�ͬ��С���˷������������ƽ��');
xlabel('ʱ��(��)');
ylabel('����(ǧ��)');
% �¶ȹ���
figure(2);
set(gcf,'Units','centimeters', 'position',[15 5 12 12]);
set(gca, 'FontSize', wordsize, 'FontName', 'Times', 'position',[.1 .4 .8 .4]);
plot(time, slope_ref, 'k', 'linewidth', 1.2);
hold on;
plot(time, slope_wls1, 'r', 'linewidth', 1.2);
hold on;
plot(time, slope_wls2, 'b', 'linewidth', 1.2);
hold on;
plot(time, slope_wls3, 'color', [34,139,34]/255, 'linewidth', 1.2);
hold on;
plot(time, slope_ls, 'color', [218,165,32]/255, 'linewidth', 1.2);
legend('ʵ���¶�', 'WLSM: Huber��������', 'WLSM: Tukey biweight��������', 'WLSM: �˺�������', 'LSM');
title('���ڲ�ͬ��С���˷������¶ȹ��ƽ��');
xlabel('ʱ��(��)');
ylabel('�¶�(��)');

%% ����ͳ��
% �������ƽ����AAE
AAE_m_wls1 = mean(abs(m_ref - m_wls1));
AAE_m_wls2 = mean(abs(m_ref - m_wls2));
AAE_m_wls3 = mean(abs(m_ref - m_wls3));
AAE_m_ls = mean(abs(m_ref - m_ls));
% �µ����ƽ����AAE
AAE_slope_wls1 = mean(abs(slope_ref - slope_wls1));
AAE_slope_wls2 = mean(abs(slope_ref - slope_wls2));
AAE_slope_wls3 = mean(abs(slope_ref - slope_wls3));
AAE_slope_ls = mean(abs(slope_ref - slope_ls));





