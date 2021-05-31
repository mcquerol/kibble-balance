Speaker_mechanical = tf([1],[25.53543e-3 1343.97]); %speaker transfer function (mechanical part)
Speaker_electrical = tf([1],[10e-3 10]); % speaker transfer function R = 10 ohm and L = 10mH
K1 = 5; %instrumentation amplifier gain
BL = 4.196203; % BL constant
result1 = feedback((Speaker_mechanical * K1 * Speaker_electrical * BL),1); % closed loop system with unity feedback without PID
x = figure;
step(result1);
%--------------------------------------------------------------------------------------------
Kcr = 53641; %critical gain obtained from routh array of G(s)
Pcr = 0.00433562; %critical period, s
% the following three were obtained from Ziegler-Nichols method II table
% for PI controller
Kp_pi = 0.45 * Kcr;
Ki_pi = (1/1.2) * Pcr;
% for PID controller
Kp_pid = 0.6 * Kcr;
Ki_pid = 0.5 * Pcr;
Kd_pid = 0.125 * Pcr;
% %output the values
disp("----------Kp Ki and Kd-----------");
disp("PID: Kp = " + Kp_pid + ", Ki = " + Ki_pid + ", Kd = " + Kd_pid);
% system with PID in series
sys=pid(Kp_pid,Ki_pid,Kd_pid);
result2 = feedback((Speaker_mechanical * K1 * Speaker_electrical * BL*sys),1);
y = figure;
step(result2);
% display the two step responses
figure(x);
grid();
figure(y);
grid();
% Display input and output as arbitrary values
run_time=60;
t = 0:0.1:run_time;
u = t;
[y,t,x] = lsim(result2,u,t);
z=figure;
plot(t,y,'b',t,u,'r')
figure(z);
xlabel('Time (sec)');
ylabel('Amplitude');
title('Input-red, Output-blue');
% measure and calculate steady state error (non linearity)
m1 = (y(end)-y(1))/run_time; %slope of output
m2 = (u(end)-u(1))/run_time; %slope of input
diff = m2-m1;
disp("Steady state error of " + diff + ": ");