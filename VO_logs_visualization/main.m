%% IMPORT DATA

% set log path (uncomment one)
path = 'logs/20190912-1551';
% path = 'logs/20190913-1250';
% path = 'logs/20190913-1239.1';
% path = 'logs/20190913-1314';

%Read fil (46 extra char)
[t, x, y, z]=textread(horzcat(path,'/odom_world.txt'), '%d%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
odom_pose = [t, x, y, z];
[t, x, y, z]=textread(horzcat(path,'/diff_pose.txt'), '%d%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
diff_pose = [t, x, y, z];

%Close files
% fclose(fileID_odom);
% fclose(fileID_diff);

%% PROCESS DATA

%Create GT pose (gt = diff + odom)
gt_pose = [odom_pose(:,1) odom_pose(:,2:end)+diff_pose(:,2:end)];

%Normalize time
odom_pose(:,1) = (odom_pose(:,1) - odom_pose(1,1))/10^6;
diff_pose(:,1) = (diff_pose(:,1) - diff_pose(1,1))/10^6;
gt_pose(:,1) = (gt_pose(:,1) - gt_pose(1,1))/10^6;


%% PLOT DATA

% xy plot - line
figure(1);
plot(odom_pose(:,2), odom_pose(:,3), 'r-', gt_pose(:,2), gt_pose(:,3), 'g-');
legend('Visual Oodometry pose', 'GT pose'), grid on;
xlabel('x'), ylabel('y'), title('Visual Odometry Evaluation - XY Plane');
% xy plot - dotted line
figure(2);
step = 10;
plot(odom_pose(1:step:end,2), odom_pose(1:step:end,3), 'r-*', gt_pose(1:step:end,2), gt_pose(1:step:end,3), 'g-*');
legend('Visual Oodometry pose', 'GT pose'), grid on;
xlabel('x'), ylabel('y'), title('Visual Odometry Evaluation - XY Plane');

% zt plot - line
figure(3);
plot(odom_pose(:,1), odom_pose(:,4), 'r-', gt_pose(:,1), gt_pose(:,4), 'g-');
legend('Visual Oodometry pose', 'GT pose'), grid on;
xlabel('time [s]'), ylabel('z'), title('Visual Odometry Evaluation - Z over Time');
% zt plot - dotted line
figure(4);
step = 10;
plot(odom_pose(1:step:end,1), odom_pose(1:step:end,4), 'r-*', gt_pose(1:step:end,1), gt_pose(1:step:end,4), 'g-*');
legend('Visual Oodometry pose', 'GT pose'), grid on;
xlabel('time [s]'), ylabel('z'), title('Visual Odometry Evaluation - Z over Time');





