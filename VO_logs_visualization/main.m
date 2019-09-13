%% IMPORT DATA

% set log path (uncomment one)
% path = 'logs/20190912-1551';
% path = 'logs/20190913-1250';
% path = 'logs/20190913-1239.1';
path = 'logs/20190913-1314';
% path = 'logs/20190913-1436';
% path = 'logs/20190913-1646';
% path = 'logs/20190913-1707';

% Read files 
[t, x, y, z, a, b, c, d]=textread(horzcat(path,'/odom_world.txt'), ...
    '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 3, 'delimiter', '\t');
odom_pose = [t, x, y, z, a, b, c, d];
[t, x, y, z, a, b, c, d]=textread(horzcat(path,'/diff_pose.txt'), ...
    '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
diff_pose = [t, x, y, z, a, b, c, d];


%% PROCESS DATA

% Create GT pose (gt = diff + odom)
gt_pose = [odom_pose(:,1) odom_pose(:,2:end)+diff_pose(:,2:end)];

% Normalize time
odom_pose(:,1) = (odom_pose(:,1) - odom_pose(1,1))/10^6;
diff_pose(:,1) = (diff_pose(:,1) - diff_pose(1,1))/10^6;
gt_pose(:,1) = (gt_pose(:,1) - gt_pose(1,1))/10^6;

% compute error norm
diff_norm = zeros(size(diff_pose,1),1);
for i = 1:size(diff_pose,1)
    diff_norm(i) = norm(diff_pose(i,2:3));
end


%% PLOT DATA

% xy plot - line
figure(1);
plot(odom_pose(:,2), odom_pose(:,3), 'r-', gt_pose(:,2), gt_pose(:,3), 'g-');
legend('Visual Oodometry pose', 'GT pose'), grid on;
xlabel('x [m]'), ylabel('y [m]'), title('Visual Odometry Evaluation - XY Plane');
% xy plot - dotted line
figure(2);
step = 10;
plot(odom_pose(1:step:end,2), odom_pose(1:step:end,3), 'r-*', gt_pose(1:step:end,2), gt_pose(1:step:end,3), 'g-*');
legend('Visual Oodometry pose', 'GT pose'), grid on;
xlabel('x [m]'), ylabel('y [m]'), title('Visual Odometry Evaluation - XY Plane');

% zt plot - line
figure(3);
plot(odom_pose(:,1), odom_pose(:,4), 'r-', gt_pose(:,1), gt_pose(:,4), 'g-');
legend('Visual Oodometry pose', 'GT pose'), grid on;
xlabel('time [s]'), ylabel('z [m]'), title('Visual Odometry Evaluation - Z over Time');
% zt plot - dotted line
figure(4);
step = 10;
plot(odom_pose(1:step:end,1), odom_pose(1:step:end,4), 'r-*', gt_pose(1:step:end,1), gt_pose(1:step:end,4), 'g-*');
legend('Visual Oodometry pose', 'GT pose'), grid on;
xlabel('time [s]'), ylabel('z [m]'), title('Visual Odometry Evaluation - Z over Time');

% xy error norm over time
figure(5);
plot(diff_pose(:,1), diff_norm);
grid on;
xlabel('time [s]'), ylabel('xy error [m]'), title('Visual Odometry Evaluation - xy error norm');





