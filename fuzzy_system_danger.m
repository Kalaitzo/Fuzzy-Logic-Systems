clc
clear;
close all;
%% Run the Model
x0 = [0.8 0.2];
time = [0 10];

[t,x] = ode45(@system,time,x0);

figure(1);
plot(t,x)
title('x1 & x2 Change Through Time')
xlabel('Time')
ylabel('Percentage')
legend('x1','x2')
%% Load the designed Fuzzy system
fis = readfis('danger.fis');
%% Calculate the output of the system
for i = 1:length(x)
    figure(2);
    
    [output,fuzzifiedIn,ruleOut,aggregatedOut,ruleFiring] = evalfis(fis,[x(i,1) x(i,2)]);
    outputRange = linspace(fis.output.range(1),fis.output.range(2),length(aggregatedOut))'; 
    plot(outputRange,aggregatedOut,[output output],[0 1])
    
    title('Fuzzy System Output')
    xlabel('Danger')
    ylabel('Membership Outputs')
    legend('Aggregated Output','Defuzzified Output')

end

figure(3);
output = evalfis(fis,x);
plot(output)
title('Fuzzy System Defuzzified Centroid Output')
xlabel('time')
ylabel('Defuzzified Output')
%% Functions
function x_dot = system(~,x)
    a = 0.1;
    b = 0.8;
    x1_dot = -a*x(1) + b*x(1)*x(2);
    x2_dot = -b*x(1)*x(2);
    x_dot = [x1_dot; x2_dot];
end