function [IOP] = computeIOP(cam, pitch, vel, vo_period)
%COMPUTEIOP Summary of this function goes here
%   Detailed explanation goes here

VFOV = deg2rad(49);
HFOV = deg2rad(53);
if strcmp(cam, 'loccam')
    h = 0.24;
    pitch = 30.4;
elseif strcmp(cam, 'navcam')
    h = 0.633;
end
pitch = deg2rad(pitch);
    
l1 = h/(cos(pi/2 - pitch - VFOV/2));
l2 = h/(cos(pi/2 - pitch + VFOV/2));

c = sin(VFOV/2 + pi/2)/sin(pi/2 - pitch)*(l2-l1);
g = l1*sin(pi/2 - pitch - VFOV/2);

a = 2*tan(HFOV/2)*g;
b = 2*tan(HFOV/2)*(c + g);
theta = atan( ((b - a)/2)/c );

a_ov = a;
c_ov = max(0, c - vel*vo_period);
% l_ov = c_ov/sin(pi/2 - theta);
b_ov = a_ov + 2*tan(theta)*c_ov;

ov_area = (a_ov + b_ov)*c_ov/2;

IOP = ov_area*100/((a + b)*c/2);

end

