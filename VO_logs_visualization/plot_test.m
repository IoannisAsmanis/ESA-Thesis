%% IMPORT DATA
clear all
close all


% set log path (uncomment one)
path = 'logs/20190912-1551';
path = 'logs/20190913-1250';
% path = 'logs/20190913-1239.1'; %nope
% path = 'logs/20190913-1314'; %not too far from 2%
% path = 'logs/20190913-1436';
% path = 'logs/20190913-1646'; %going back
% path = 'logs/20190913-1707'; % move along x and then along y
path = 'logs/20190916-1428'; % move along x and then along y ---
% path = 'logs/20190916-1530';
% path = 'logs/20190916-1716';
% path = 'logs/20190916-1811'; %control
% path = 'logs/20190916-1815';
% path = 'logs/20190916-1840';
% path = 'logs/20190916-1857'; % move along y
% from now on there are control files
% path = 'logs/20190918-1108'; %control
% path = 'logs/20190918-1521'; %test
% path = 'logs/20190918-1558'; %control
% path = 'logs/20190918-1609'; %test
% path = 'logs/20190918-1806'; %control
% path = 'logs/20190918-1808'; %control
% path = 'logs/20190918-1820'; %test move along x
% path = 'logs/20190919-1242'; %control
% path = 'logs/20190919-1255'; %control
% path = 'logs/20190919-1308'; %control
% path = 'logs/20190919-1342'; %test nope
% path = 'logs/20190919-1352'; %test move along x
% path = 'logs/20190919-1359'; %test 
% path = 'logs/20190919-1521'; %test
% path = 'logs/20190919-1628'; %test
% path = 'logs/20190919-1740'; %test
% path = 'logs/20190923-1327'; %point turn heading 
path = 'logs/20190923-1723'; %point turn heading 



% Read odometry file
[t, x, y, z, b, c, d, a]=textread(horzcat(path,'/odom_world.txt'), ...
    '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
odom_pose = [t, x, y, z, a, b, c, d];

% Read difference odometry/vicon file
[t, x, y, z, b, c, d, a]=textread(horzcat(path,'/diff_pose.txt'), ...
    '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
diff_pose = [t, x, y, z, a, b, c, d];

% % Read control file
% [ tr, rot, hdg]=textread(horzcat(path,'/control.txt'), ...
%     '%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
% 
% % Read control time file
% t=textread(horzcat(path,'/control_time.txt'), ...
%     '%d', 'headerlines', 2);
% t(end+1) = t(end);
% control = [t, tr, rot];

% read real gt file
[t, x, y, z, b, c, d, a]=textread(horzcat(path,'/gt_pose.txt'), ...
    '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
gt_pose = [t, x, y, z, a, b, c, d];

% read odom heading file
[hdg]=textread(horzcat(path,'/odometry_heading.txt'), ...
    '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
odom_pose(:,9) = hdg;

% read gt heading file
[hdg]=textread(horzcat(path,'/gt_heading.txt'), ...
    '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
gt_pose(:,9) = hdg;

% % Read joystick file
% % [t, a0, a1, a2, a3, a4, a5, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11]=textread(horzcat(path,'/joystick_raw.txt'), ...
% %     '%*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %f %f %f %f %f %f %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d %f %f %f %f %f %f %f %f %f %f %f %f', 'headerlines', 2);
% % joystick_raw = [t, a0, a1, a2, a3, a4, a5, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11];


%% PROCESS DATA

% convert odom quaternion to odom heading
hdg = quaternion2heading(odom_pose(:,5:8));
% odom_pose(:,9) = hdg;

% convert gt quaternion to gt heading
hdg = quaternion2heading(gt_pose(:,5:8));
% gt_pose(:,9) = hdg;

% convert diff quaternion to diff heading
hdg = quaternion2heading(diff_pose(:,5:8));
diff_pose(:,9) = hdg;

% Create GT pose (gt = diff + odom)
gt_pose = [odom_pose(:,1) odom_pose(:,2:end)+diff_pose(:,2:end)];

% Normalize time
odom_pose(:,1) = (odom_pose(:,1) - odom_pose(1,1))/10^6;
diff_pose(:,1) = (diff_pose(:,1) - diff_pose(1,1))/10^6;
gt_pose(:,1) = (gt_pose(:,1) - gt_pose(1,1))/10^6;
% control(:,1) = (control(:,1) - control(1,1))/10^6;
% gt_pose2(:,1) = (gt_pose2(:,1) - gt_pose2(1,1))/10^6;

% compute error norm
diff_norm = zeros(size(diff_pose,1),1);
for i = 1:size(diff_pose,1)
    diff_norm(i) = norm(diff_pose(i,2:3));
end

% travelled distance up to now
dist_accum = zeros(size(odom_pose,1),1);
for i = 2:size(odom_pose,1)
    dist_accum(i) = norm(gt_pose(i,2:4) - gt_pose(i-1,2:4));
    dist_accum(i) = dist_accum(i) + dist_accum(i-1);
end


%% PLOT DATA

% % xy plot - line
% figure(1);
% plot(odom_pose(:,2), odom_pose(:,3), 'r-', gt_pose(:,2), gt_pose(:,3), 'g-');
% legend('Visual Oodometry pose', 'GT pose'), grid on, axis equal;
% xlabel('x [m]'), ylabel('y [m]'), title('Visual Odometry Evaluation - XY Plane');
% % xy plot - dotted line
% figure(2);
% step = 10;
% plot(odom_pose(1:step:end,2), odom_pose(1:step:end,3), 'r-*', gt_pose(1:step:end,2), gt_pose(1:step:end,3), 'g-*');
% legend('Visual Oodometry pose', 'GT pose'), grid on, axis equal;
% xlabel('x [m]'), ylabel('y [m]'), title('Visual Odometry Evaluation - XY Plane');

% % zt plot - line
% figure(3);
% plot(odom_pose(:,1), odom_pose(:,4), 'r-', gt_pose(:,1), gt_pose(:,4), 'g-');
% legend('Visual Oodometry pose', 'GT pose'), grid on, axis equal;
% xlabel('time [s]'), ylabel('z [m]'), title('Visual Odometry Evaluation - Z over Time');
% % zt plot - dotted line
% figure(4);
% step = 10;
% plot(odom_pose(1:step:end,1), odom_pose(1:step:end,4), 'r-*', gt_pose(1:step:end,1), gt_pose(1:step:end,4), 'g-*');
% legend('Visual Oodometry pose', 'GT pose'), grid on, axis equal;
% xlabel('time [s]'), ylabel('z [m]'), title('Visual Odometry Evaluation - Z over Time');

% % xy error norm over time vs 2% distance travelled
% figure(5);
% plot(diff_pose(:,1), diff_norm, 'b-', diff_pose(:,1), dist_accum.*0.02, 'r-');
% grid on, legend('xy error norm', '2% travelled distance');
% xlabel('time [s]'), ylabel('xy error [m]'), title('Visual Odometry Evaluation - xy error norm');

% % x and y components error and control over time
% figure(6);
% plot(diff_pose(:,1), diff_pose(:,2), 'b-', diff_pose(:,1), diff_pose(:,3), 'r-', control(:,1), control(:,2));
% grid on, legend('x error', 'y error', 'control');
% xlabel('time [s]'), ylabel('xy error [m] and control [m/s]'), title('Visual Odometry Evaluation - x y error components and control');

% % x and y components error and x and y trajectory over time 
% figure(6);
% subplot(2,1,1), plot(diff_pose(:,1), diff_pose(:,2), 'b-', diff_pose(:,1), diff_pose(:,3), 'r-');
% title({'Visual Odometry Evaluation', 'x y error components vs x y ground truth over time'})
% grid on, legend('x error', 'y error');
% subplot(2,1,2), plot(gt_pose(:,1), gt_pose(:,2), gt_pose(:,1), gt_pose(:,3));
% grid on, legend('GT x', 'GT y');
% xlabel('time [s]'), ylabel('xy error [m]');

% % control over time
% figure(7);
% plot(control(:,1), control(:,2), control(:,1), control(:,3));
% grid on, legend('translation', 'rotation');
% xlabel('time [s]'), ylabel('command'), title('Visual Odometry Evaluation - translation and rotation commands');

% % z over distance travelled
% figure(8);
% plot(dist_accum, gt_pose(:,4));
% grid on;
% xlabel('distance [m]'), ylabel('z [m]'), title('Visual Odometry Evaluation - z over distance travelled');

% % xy gt plot over time - line
% figure(9);
% plot(gt_pose(:,1), gt_pose(:,2), 'r-', gt_pose(:,1), gt_pose(:,3), 'g-');
% legend('x pose from vicon', 'y pose from vicon'), grid on;
% xlabel('time [s]'), ylabel('x,y [m]'), title('Visual Odometry Evaluation - ');

% % xy vo plot over time - line
% figure(10);
% plot(odom_pose(:,1), odom_pose(:,2), 'r-', odom_pose(:,1), odom_pose(:,3), 'g-');
% legend('x pose from vo', 'y pose from vo'), grid on, axis equal;
% xlabel('time [s]'), ylabel('x,y [m]'), title('Visual Odometry Evaluation - ');

% heading vs gt_heading over time
figure(11);
% plot(odom_pose(:,1), odom_pose(:,9), gt_pose2(:,1), gt_pose2(:,9));
plot(odom_pose(:,1), odom_pose(:,9), gt_pose(:,1), gt_pose(:,9));
grid on, legend('odom heading', 'GT heading');
xlabel('time [s]'), ylabel('angle [rad]'), title('Visual Odometry Evaluation - heading evaluation over time');

% xy trajectory over time (z)
figure(12);
plot3(gt_pose(:,2), gt_pose(:,3), gt_pose(:,1));
grid on, xlim([0 5]), ylim([2.5 7.5]); %legend('odom heading', 'GT heading');
xlabel('position [m]'), ylabel('position [m]'), zlabel('time [s]');
title('Visual Odometry Evaluation - xy trajectory over time');




