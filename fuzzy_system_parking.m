clc;
clear;
close all;
%% Global Variables
L = 2.5;  % Length of the car
T = 0.1;  % Sample rate
V = 0.5;  % Car speed
%% Initial Conditions
theta = 10;  % Initial direction of the car
x = 0;  % Initial horizontal position of the car
y = 4;  % Initial vertical position of the car
u = 0;  % Initial angle of the wheels
%% Fuzzy System
parking_fis = readfis('parking.fis');  % Import the Fuzzy System
%% Parking Algorithm
for i=1:100000
    if ((y(end)<0.5 && y(end)>=0) && (theta(end)<0.5 && theta(end)>=0))
        break;
    end

    theta_new = angle(theta(end), deg2rad(u(end)), T, V, L);  % Calculate the new theta

    x_new = horizontal(x(end), deg2rad(theta(end)), T, V);  % Calculate the next x

    y_new = vertical(y(end), deg2rad(theta(end)), T, V);  % Calculate the new y

    fis_input = [y(end), theta(end)];  % Fuzzy System Input

    u_new  = evalfis(parking_fis, fis_input);  % Calculate the new u
 
    x = [x x_new];
    y = [y y_new];
    u = [u u_new];
    theta = [theta theta_new];

end

%% Results
figure;
plot(y)
hold on;
plot (theta)
title("Car's trace");
xlabel('Moment');
ylabel("Car's height (y) and angle (theta)");
legend('y','theta')

figure
plot(u)
title("Car's wheel angle")
xlabel('Moment');
ylabel('Wheel angle (u)')
legend('u')
%% Functions
function theta_new  = angle(theta_old, uk, T, V, L)
    theta_new = theta_old + (T * V * tan(uk)/L);
end

function x_new = horizontal(x_old, theta, T, V)
    x_new = x_old + T * V * cos(theta);
end

function y_new = vertical(y_old, theta, T, V)
    y_new = y_old + T * V * sin(theta);
end