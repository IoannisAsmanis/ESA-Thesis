%% Find r2,r1 that give min mass
clear all
close all
clc


%% Input data

l1 = .75;
l2 = .75;
ro = 2800;
Mb = 0.24976;


%% Calculation
% 
% disp("LIMB 1")
% A = []; 
% b = []; 
% lb = [0.01 0.002];
% ub = [0.2 0.25];
% mass=@(x) (pi * ((2*x(2))^2 - (2*x(1))^2))/4 * l1 * ro;
% val=fmincon(mass,[0.001 0.002], A, b, [], [], lb, ub, @mycon);
% limb1_min_mass=mass(val)
% limb1_min_r2=val(2)
% limb1_min_r1=val(1)
% limb1_I = pi*((val(2))^4)/4 - pi*((val(1))^4)/4;
% limb1_bend_stress=Mb*val(2)/limb1_I
% 
% disp("LIMB 2")
% A = []; 
% b = []; 
% lb = [0.01 0.002];
% ub = [0.2 0.25];
% mass=@(x) (pi * ((2*x(2))^2 - (2*x(1))^2))/4 * l2 * ro;
% val=fmincon(mass,[0.001 0.002], A, b, [], [], lb, ub, @mycon);
% limb2_min_mass=mass(val)
% limb2_min_r2=val(2)
% limb2_min_r1=val(1)
% limb2_I = pi*((val(2))^4)/4 - pi*((val(1))^4)/4;
% limb2_bend_stress=Mb*val(2)/limb2_I


%%

A = []; 
b = []; 
lb = [0.01 0.002 0.01 0.002 0.2 0.2];
ub = [0.2 0.25 0.2 0.25 1.0 1.0];
mass=@(x) ((pi * ((2*x(4))^2 - (2*x(3))^2))/4 * x(6) * ro) + ((pi * ((2*x(2))^2 - (2*x(1))^2))/4 * x(5) * ro);
val=fmincon(mass,[0.001 0.002 0.001 0.002 0.6 0.6], A, b, [], [], lb, ub, @mycon2);

total_mass=mass(val)
disp("LIMB 1")
limb1_mass = ((pi * ((2*val(2))^2 - (2*val(1))^2))/4 * l1 * ro)
limb1_length = val(5)
limb1_min_r2 = val(2)
limb1_min_r1 = val(1)
limb1_I = pi*((val(2))^4)/4 - pi*((val(1))^4)/4;
limb1_bend_stress = Mb*val(2)/limb1_I
disp("LIMB 2")
limb2_mass = ((pi * ((2*val(4))^2 - (2*val(3))^2))/4 * l1 * ro)
limb1_length = val(6)
limb2_min_r2 = val(4)
limb2_min_r1 = val(3)
limb2_I = pi*((val(4))^4)/4 - pi*((val(3))^4)/4;
limb2_bend_stress = Mb*val(4)/limb2_I






