function [hdg] = quaternion2heading(q)
%UNTITLED Summary of this function goes here
%   INPUT: q: quaternion expressed as wxyz (aka: abcd or re,im)

% if an invalid quaternion is passed
if (numel(q) < 4)
    disp("quaternion2heading(q) usage: must pass a 4 elements vector or n-by-4 array ")

% if a single quaternion is given
elseif (numel(q) == 4)
    q(2) = 0;
    q(4) = 0;
    mag = sqrt(q(1)*q(1)+q(3)*q(3));
    
    q(1) = q(1)/mag;
    q(3) = q(3)/mag;
    
    hdg = 2*acos(q(1));

% if an array of quaternions is passed
else 
    q(:,2) = 0;
    q(:,4) = 0;
    mag = sqrt(q(:,1).*q(:,1)+q(:,3).*q(:,3));
    
    q(:,1) = q(:,1)./mag;
    q(:,3) = q(:,3)./mag;
    
    hdg = 2*acos(q(:,1));
    
end

end

