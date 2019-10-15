%% COMPARE MULTIPLE EXPERIMENTS
clear all
close all
% clc


%% OPEN FILES AND PROCESS DATA

% path_ca = {
%     'logs/20190919-1521', %1521 %1342 %1628
%     'logs/20190919-1352', 
%     'logs/20190919-1359'}; 

% path_ca = {
%     'logs/20191007-1633', % camera_calib_4
%     'logs/20191008-0927', % camera_calib_5, pitch=30.4, old pos transform
%     'logs/20191008-0847', % camera_calib_5 and new body-cam transform
%     'logs/20191007-1628'}; % camera_calib_5 and old body-cam transform

path_ca = {
    'logs/20191011-1544', % master branch so when I arrived
    'logs/20191014-1235', % new params no block if not moving
%     'logs/20191014-1244', % new params, no block if not moving, old transform
    'logs/20191007-1628'}; % camera_calib_5 and old body-cam transform

path_ca = {
    'logs/20191014-1431'}; % camera_calib_5 and old body-cam transform

% set true if also control.txt and control_time.txt are provided in the log folder
CONTROL_FILE = false;

%% READ FILES

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
    [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/odom_world.txt'), ...
        '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 3, 'delimiter', '\t');
    odom_pose = [t, x, y, z, a, b, c, d];
    
    % Read difference odometry/vicon file
    [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/diff_pose.txt'), ...
        '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    diff_pose = [t, x, y, z, a, b, c, d];
    
    if(CONTROL_FILE)
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
    end
    
    % Create GT pose (gt = diff + odom)
    %gt_pose = [odom_pose(:,1) odom_pose(:,2:end)+diff_pose(:,2:end)];
    
    % read real gt pose file
    [t, x, y, z]=textread(horzcat(path_ca{i},'/gt_pose.txt'), ...
        '%u%*f%*f%*f%*f%*f%*f%*f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    gt_pose = [t, x, y, z];
    
    % read odom heading file
    [hdg]=textread(horzcat(path_ca{i},'/odometry_heading.txt'), ...
        '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    odom_pose(:,9) = hdg;
    
    % read gt heading file
    [hdg]=textread(horzcat(path_ca{i},'/gt_heading.txt'), ...
        '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    gt_pose(:,9) = hdg;
    
    % Normalize time
    odom_pose(:,1) = (odom_pose(:,1) - odom_pose(1,1))/10^6;
    diff_pose(:,1) = (diff_pose(:,1) - diff_pose(1,1))/10^6;    
    gt_pose(:,1) = (gt_pose(:,1) - gt_pose(1,1))/10^6;
    if(CONTROL_FILE)
        control(:,1) = (control(:,1) - control(1,1))/10^6;
    end
    
    % cut neg time part
    gt_pose(gt_pose(:,1)<0,:) = [];
    diff_pose(diff_pose(:,1)<0,:) = [];
    odom_pose(odom_pose(:,1)<0,:) = [];
    
    % compute error norm
    diff_norm = zeros(size(diff_pose,1),1);
    for j = 1:size(diff_pose,1)
        diff_norm(j) = norm(diff_pose(j,2:4));
    end
    
    % travelled distance up to now
    dist_accum = zeros(size(odom_pose,1),1);
    for j = 2:size(odom_pose,1)
        %dist_accum(j) = norm(gt_pose(j,2:4) - gt_pose(j-1,2:4));
        %dist_accum(j) = dist_accum(j) + dist_accum(j-1);
        dist_accum(j) = norm(gt_pose(j,2:4) - gt_pose(1,2:4));
    end
    
    % save in cell array
    diff_pose_ca{i} = diff_pose;
    odom_pose_ca{i} = odom_pose;
    diff_norm_ca{i} = diff_norm;
    dist_accum_ca{i} = dist_accum;
    if(CONTROL_FILE)
        control_ca{i} = control;
    end
    gt_pose_ca{i} = gt_pose;
end


%% PLOT DATA

close all

% del = diff_pose_ca{2}(2,1) - diff_pose_ca{2}(1,1);
% diff_pose_ca{2}(:,1) = diff_pose_ca{2}(:,1) - del;
% diff_pose_ca{2}(1,1) = 0;

% % realign diff pose times (align test 3 to test 1, if needed align all to a single one)
% del = diff_pose_ca{3}(2,1) - diff_pose_ca{3}(1,1);
% diff_pose_ca{3}(:,1) = diff_pose_ca{3}(:,1) - del;
% diff_pose_ca{3}(1,1) = 0;

% xy error norm over time vs distance travelled
figure(101);
hold on
for i=1:n_logs
    plot(dist_accum_ca{i}, diff_norm_ca{i});
    grid on;
    xlabel('distance travelled [m]'), ylabel('xy error [m]')
end
plot(dist_accum_ca{i}, dist_accum_ca{i}*0.02, 'r--')
title({'Visual Odometry Evaluation', 'xyz error norm over travelled distance'});
legend_names_t = [legend_names(:)', {'2% distance traveled'}]; legend(legend_names_t)
hold off

% xy error norm over time vs time
legend_names_2pdt = cell(1,n_logs);
for i = 1:n_logs
    legend_names_2pdt{(i-1)+i} = horzcat('test ', num2str(i));
    legend_names_2pdt{(i-1)+i+1} = horzcat('test ', num2str(i), ', 2% distance traveled');
end
figure(102);
hold on
for i=1:n_logs
    plot(diff_pose_ca{i}(:,1), diff_norm_ca{i}, diff_pose_ca{i}(:,1), dist_accum_ca{i}.*0.02, 'r--');
    grid on;
    xlabel('time [s]'), ylabel('xy error [m]')
end
% plot(diff_pose_ca{i}(:,1), dist_accum_ca{i}.*0.02, 'r-')
title({'Visual Odometry Evaluation', 'xy error norm over time'});
legend(legend_names_2pdt);
hold off

if(CONTROL_FILE)
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
end

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

% heading error vs heading change over time
figure(105);
for i=1:n_logs
    subplot(n_logs,1,i);
    plot(odom_pose_ca{i}(:,1), odom_pose_ca{i}(:,9), gt_pose_ca{i}(:,1), gt_pose_ca{i}(:,9));
    grid on, legend('odom heading', 'GT heading');
    xlabel('time [s]'), ylabel('angle [rad]');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'heading error vs GT heading over time'});
end
% title({'Visual Odometry Evaluation', 'heading error vs travelled distance'});

% % IF NO FIRST STEP ERROR 
% % xy error norm over time vs distance travelled
% for i=1:n_logs
%     diff_norm_ca_nofirsterror{i} = [diff_norm_ca{i}(1); diff_norm_ca{i}(2:end) - diff_norm_ca{i}(2)];
% end
% figure(106);
% hold on
% for i=1:n_logs
%     plot(dist_accum_ca{i}, diff_norm_ca_nofirsterror{i});
%     grid on;
%     xlabel('distance travelled [m]'), ylabel('xy error [m]')
% end
% plot(dist_accum_ca{i}, dist_accum_ca{i}*0.02)
% title({'Visual Odometry Evaluation', 'xyz error norm over travelled distance'});
% legend_names_t = [legend_names(:)', {'2% distance traveled'}]; legend(legend_names_t)
% hold off
