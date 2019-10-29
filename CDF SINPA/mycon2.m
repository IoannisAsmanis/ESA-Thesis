function [c,ceq] = mycon2(x)

I = pi*((x(2))^4)/4 - pi*((x(1))^4)/4;
Mb = 0.24976;
sigma_alu = 2e10;
sigma_max = 2e7;

c(1) = x(1) - x(2) + 0.004;
c(2) = x(3) - x(4) + 0.004;
ceq = x(5) + x(6) - 1.2;

% c(2) = Mb*x(2)/I - sigma_max;
% ceq = 0; %Mb*x(2)/I - sigma_max;
