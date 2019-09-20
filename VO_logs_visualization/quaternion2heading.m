function [hdg] = quaternion2heading(q)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

q(2) = 0;
q(4) = 0;
mag = sqrt(q(1)*q(1)+q(3)*q(3));

q(1) = q(1)/mag;
q(3) = q(3)/mag;

hdg = 2*acos(q(1));

end

