%% IMPORT DATA

%Open files
% fileID_odom = fopen('logs/20190912-1551/odom_world.txt','r');
% fileID_diff = fopen('logs/20190912-1551/diff_pose.txt','r');

%Read fil (46 extra char)
[t, x, y, z]=textread('logs/20190912-1551/odom_world.txt', '%d%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
odom_pose = [t, x, y, z];
[t, x, y, z]=textread('logs/20190912-1551/diff_pose.txt', '%d%f%f%f%*[^\n]', 'headerlines', 3, 'delimiter', '\t');
diff_pose = [t, x, y, z];

%Close files
% fclose(fileID_odom);
% fclose(fileID_diff);

%% PROCESS DATA

%Create GT pose (gt = diff + odom)
gt_pose = [odom_pose(:,1) odom_pose(:,2:end)+diff_pose(:,2:end)];

figure(1);
%plot(odom_pose(:,2), odom_pose(:,3), 'r', '-*', gt_pose(:,2), gt_pose(:,3), 'g', '-*');
step = 10;
plot(odom_pose(1:step:end,2), odom_pose(1:step:end,3), 'r-*', gt_pose(1:step:end,2), gt_pose(1:step:end,3), 'g-*');
legend('Visual Oodometry pose', 'GT pose'), grid on;
xlabel('x'), ylabel('y'), title('XY Plane Visual Odometry Evaluation');
