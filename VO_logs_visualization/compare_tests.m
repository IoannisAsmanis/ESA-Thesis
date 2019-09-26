%% COMPARE MULTIPLE EXPERIMENTS
clear all
close all
% clc


%% OPEN FILES AND PROCESS DATA

path_ca = {
    'logs/20190919-1521', %1521 %1342 %1628
    'logs/20190919-1352', 
    'logs/20190919-1359'}; 

n_logs = size(path_ca,1);

legend_names = cell(1,n_logs);
for i = 1:n_logs
    legend_names{i} = horzcat('test ', num2str(i));
end

diff_pose_ca = cell(1,n_logs);
odom_pose_ca = cell(1,n_logs);
diff_norm_ca = cell(1,n_logs);
dist_accum_ca = cell(1,n_logs);
control_ca = cell(1,n_logs);
gt_pose_ca = cell(1,n_logs);
    
for i=1:n_logs
    
    % Read odometry file
    [t, x, y, z, b, c, d, ad]=textread(horzcat(path_ca{i},'/odom_world.txt'), ...
        '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    odom_pose = [t, x, y, z, a, b, c, d];
    
    % Read difference odometry/vicon file
    [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/diff_pose.txt'), ...
        '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    diff_pose = [t, x, y, z, a, b, c, d];
    
    % Read control file
    [ tr, rot, hdg]=textread(horzcat(path_ca{i},'/control.txt'), ...
        '%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    
    % Read control time file
    t=textread(horzcat(path_ca{i},'/control_time.txt'), ...
        '%d', 'headerlines', 2);
    t(size(tr,1)) = t(end);
    control = [t, tr, rot];
    
    % align control signals
    control(control(:,2) == 0, :) = [];
    % add end of control signal
    control(end+1,:) = [control(end,1) 0 0];
    
    % Normalize time
    odom_pose(:,1) = (odom_pose(:,1) - odom_pose(1,1))/10^6;
    diff_pose(:,1) = (diff_pose(:,1) - diff_pose(1,1))/10^6;
    control(:,1) = (control(:,1) - control(1,1))/10^6;
    
    % Create GT pose (gt = diff + odom)
    gt_pose = [odom_pose(:,1) odom_pose(:,2:end)+diff_pose(:,2:end)];
    
    % cut neg time part
    gt_pose(gt_pose(:,1)<0,:) = [];
    diff_pose(diff_pose(:,1)<0,:) = [];
    odom_pose(odom_pose(:,1)<0,:) = [];
    
    % compute error norm
    diff_norm = zeros(size(diff_pose,1),1);
    for j = 1:size(diff_pose,1)
        diff_norm(j) = norm(diff_pose(j,2:3));
    end
    
    % travelled distance up to now
    dist_accum = zeros(size(odom_pose,1),1);
    for j = 2:size(odom_pose,1)
        dist_accum(j) = norm(gt_pose(j,2:4) - gt_pose(j-1,2:4));
        dist_accum(j) = dist_accum(j) + dist_accum(j-1);
    end
    
    % save in cell array
    diff_pose_ca{i} = diff_pose;
    odom_pose_ca{i} = odom_pose;
    diff_norm_ca{i} = diff_norm;
    dist_accum_ca{i} = dist_accum;
    control_ca{i} = control;
    gt_pose_ca{i} = gt_pose;
end


%% PLOT DATA

% xy error norm over time vs distance travelled
figure(101);
hold on
for i=1:n_logs
    plot(dist_accum_ca{i}, diff_norm_ca{i});
    grid on;
    xlabel('distance travelled [m]'), ylabel('xy error [m]')
end
title({'Visual Odometry Evaluation', 'xy error norm over travelled distance'});
legend(legend_names);
hold off

% xy error norm over time vs time
figure(102);
hold on
for i=1:n_logs
    plot(diff_pose_ca{i}(:,1), diff_norm_ca{i});
    grid on;
    xlabel('time [s]'), ylabel('xy error [m]')
end
title({'Visual Odometry Evaluation', 'xy error norm over time'});
legend(legend_names);
hold off

% control over time
figure(103);
hold on
for i=1:n_logs
    plot(control_ca{i}(:,1), control_ca{i}(:,2));
    grid on;
    xlabel('time [s]'), ylabel('command [m/s]')
end
title({'Visual Odometry Evaluation', 'control signal over time'});
legend(legend_names);
hold off

% ground truth trajectory on xy plane
figure(104);
hold on
for i=1:n_logs
    plot(gt_pose_ca{i}(:,2), gt_pose_ca{i}(:,3));
    xlabel('x [m]'), ylabel('y [m]')
end
title({'Visual Odometry Evaluation', 'ground truth trajectory'});
grid on, axis equal; 
legend(legend_names);
hold off

% % heading error over time
% figure(105);
% for i=1:n_logs
%     plot(odom_pose_ca{i}(:,1), odom_pose_ca{i}(:,9)-gt_pose_ca{i}(:,9));
%     grid on;
%     xlabel('distance travelled [m]'), ylabel('heading [rad]')
% end
% grid on, legend(legend_names);
% xlabel('time [s]'), ylabel('angle [rad]'), title('Visual Odometry Evaluation - heading error over time');
% 
% % heading error over distance travelled
% figure(105);
% for i=1:n_logs
%     plot(dist_accum_ca{i}, odom_pose_ca{i}(:,9)-gt_pose_ca{i}(:,9));
%     grid on;
%     xlabel('distance travelled [m]'), ylabel('heading [rad]')
% end
% grid on, legend(legend_names);
% xlabel('time [s]'), ylabel('angle [rad]'), title('Visual Odometry Evaluation - heading error over distance travelled');
