%% COMPARE MULTIPLE EXPERIMENTS
clear all
close all
% clc


%% OPEN FILES AND PROCESS DATA

path_ca = {
    'logs/20190919-1342', 
    'logs/20190919-1352', 
    'logs/20190919-1359'}; 

n_logs = size(path_ca,1);

diff_pose_ca = cell(1,n_logs);
odom_pose_ca = cell(1,n_logs);
diff_norm_ca = cell(1,n_logs);
dist_accum_ca = cell(1,n_logs);
    
for i=1:n_logs
    
    % Read odometry file
    [t, x, y, z, a, b, c, d]=textread(horzcat(path_ca{i},'/odom_world.txt'), ...
        '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 3, 'delimiter', '\t');
    odom_pose = [t, x, y, z, a, b, c, d];
    
    % Read difference odometry/vicon file
    [t, x, y, z, a, b, c, d]=textread(horzcat(path_ca{i},'/diff_pose.txt'), ...
        '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 3, 'delimiter', '\t');
    diff_pose = [t, x, y, z, a, b, c, d];
    
    % Read control file
    [ tr, rot, hdg]=textread(horzcat(path_ca{i},'/control.txt'), ...
        '%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    
    % Read control time file
    t=textread(horzcat(path_ca{i},'/control_time.txt'), ...
        '%d', 'headerlines', 2);
    t(size(tr,1)) = t(end);
    control = [t, tr, rot];
    
    % Normalize time
    odom_pose(:,1) = (odom_pose(:,1) - odom_pose(1,1))/10^6;
    diff_pose(:,1) = (diff_pose(:,1) - diff_pose(1,1))/10^6;
%     gt_pose(:,1) = (gt_pose(:,1) - gt_pose(1,1))/10^6;
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
end


%% PLOT DATA

% xy error norm over time vs distance travelled
figure(1);
hold on
for i=1:n_logs
    plot(dist_accum_ca{i}, diff_norm_ca{i});
    grid on;
    xlabel('distance travelled [m]'), ylabel('xy error [m]')
end
title({'Visual Odometry Evaluation', 'xy error norm vs travelled distance'});
legend(path_ca);
hold off

% xy error norm over time vs time
figure(2);
hold on
for i=1:n_logs
    plot(diff_pose_ca{i}(:,1), diff_norm_ca{i});
    grid on;
    xlabel('time [s]'), ylabel('xy error [m]')
end
title({'Visual Odometry Evaluation', 'xy error norm vs time'});
legend(path_ca);
hold off

