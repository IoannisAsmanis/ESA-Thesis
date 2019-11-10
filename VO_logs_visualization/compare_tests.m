%% COMPARE MULTIPLE EXPERIMENTS
% IMPORTANT: for reasons beyond magic, sometimes odom_world.txt contains an
% extra header line. either delete it manually, or change the headerlines
% param in textread to from 2 to 3

clear all
close all
% clc


%% OPEN FILES AND PROCESS DATA

addpath('../functions')

% path_ca = {
%     'logs/20190919-1521', %1521 %1342 %1628
%     'logs/20190919-1352', 
%     'logs/20190919-1359'}; 

% path_ca = {
%     'logs/20191007-1633', % camera_calib_4
%     'logs/20191008-0927', % camera_calib_5, pitch=30.4, old pos transform
%     'logs/20191008-0847', % camera_calib_5 and new body-cam transform
%     'logs/20191007-1628'}; % camera_calib_5 and old body-cam transform

% path_ca = {
%     'logs/20191011-1544', % master branch so when I arrived
%     'logs/20191014-1235', % new params no block if not moving
% %     'logs/20191014-1244', % new params, no block if not moving, old transform
%     'logs/20191007-1628'}; % camera_calib_5 and old body-cam transform

% path_ca = {
%     'logs/20191014-1431'}; % camera_calib_5 and old body-cam transform

% path_ca = {
%     'logs/20191015-1627'}; % drift

% path_ca = {
%     'logs/20191016-1316', % cam_calib_2, no imu, drift still
%     'logs/20191016-1320', % cam_calib_2, si imu, drift still
%     'logs/20191016-1344', % cam_calib_5, no imu, drift still
%     'logs/20191016-1352'}; % cam_calib_5, si imu, drift still

% path_ca = {
%     'logs/20191016-1332', % cam_calib_2, si imu, moving
%     'logs/20191016-1336', % cam_calib_2, no imu, moving
%     'logs/20191016-1356', % cam_calib_5, si imu, moving
%     'logs/20191016-1347'}; % cam_calib_5, no imu, moving

% path_ca = {
%     'logs/20191016-1757', % cam_calib_2, si imu, moving
%     'logs/20191016-1800'}; % cam_calib_5, no imu, moving

% new tests translation
% path_ca = {
%     'logs/20191021-1511', % 
%     'logs/20191104-1713', % 
%     'logs/20191011-1544'}; % master branch so when I arrived

% new tests point turn
% path_ca = {'logs/20191021-1723','logs/20191021-1726', 'logs/20191021-1728', 'logs/20191021-1729', 'logs/20191021-1731'}; 

% % velocity tests on Spartan VO
% path_ca = {
%     'logs/20191105-1534', % 
% %     'logs/20191105-1556', % 
%     'logs/20191105-1602', % 
% %     'logs/20191105-1610', % 
%     'logs/20191105-1615', % 
% %     'logs/20191105-1618', % 
%     'logs/20191105-1619', % 
% %     'logs/20191105-1621', % 
%     'logs/20191105-1623'}; % 

% % initial error investigation on Spartan VO
% % SUPER WEIRD AND UNREPEATABLE 
% path_ca = {
%     'logs/20191107-1247', %1056', % start at t=1
%     'logs/20191107-1135'}; %1057'}; % start at t=6

% initial error investigation on Spartan VO
path_ca = {
    'logs/20191107-1345', %1056', % start at t=1
    'logs/20191107-1346'}; %1057'}; % start at t=6


% % initial error investigation on Spartan VO - forwards then backwards
% path_ca = {
%     'logs/20191107-1314', % start immediately at t=1
%     'logs/20191107-1304'}; % start later at t=6

% initial error investigation on Spartan VO if removing 1 vo step
path_ca = {
    'logs/20191107-1345', % start at t=1
    'logs/20191107-1510', % start at t=1 with the if
    'logs/20191107-1557', % start at t=1 with the ifx3
    'logs/20191107-1619', % start at t=1 with the ifx5
    'logs/20191107-1630', % start at t=1 with the ifx15
    'logs/20191107-1346', % start at t=6
    'logs/20191107-1509', % start at t=6 with the if
    'logs/20191107-1556', % start at t=6 with the ifx3
    'logs/20191107-1620', % start at t=6 with the ifx5
    'logs/20191107-1632'}; % start at t=6 with the ifx15

% % gradual acceleration
path_ca = {
    'logs/20191108-1633', % instant at t=1
    'logs/20191108-1634', % instant at t=1
    'logs/20191108-1635', % instant at t=1
    'logs/20191108-1636', % instant at t=1
    'logs/20191108-1637', % instant at t=1
    'logs/20191108-1638', % instant at t=1
    'logs/20191108-1638.1'}; % vstep=0.01 with tstep=0.5

% % check IMU
% path_ca = {
%     'logs/20191108-1451'}; % instant at t=1
    
% % comparing transforms
path_ca = {
    'logs/20191108-1731', % instant at t=1
    'logs/20191108-1752', % instant at t=1
    'logs/20191108-1754', % instant at t=1
    'logs/20191108-1757', % instant at t=1
    'logs/20191108-1806'}; % 

% set true if also other files are provided in the log folder
CONTROL_FILE = false;
IMU_FILE = false;


%% READ FILES

n_logs = size(path_ca,1);

legend_names = cell(1,n_logs);
for i = 1:n_logs
    legend_names{i} = horzcat('test ', num2str(i));
end

diff_pose_ca = cell(1,n_logs);
odom_pose_ca = cell(1,n_logs);
diff_norm_xy_ca = cell(1,n_logs);
dist_accum_ca = cell(1,n_logs);
control_ca = cell(1,n_logs);
gt_pose_ca = cell(1,n_logs);
hdg_err_ca = cell(1,n_logs);
imu_ca{i} = cell(1,n_logs);

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
    if(IMU_FILE)
        % read imu file
        [t, b, c, d, a]=textread(horzcat(path_ca{i},'/imu.txt'), ...
            '%d%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        imu = [t, a, b, c, d];
        imu(:,6) = quaternion2heading(imu(:,2:5));
        imu(:,7) = quaternion2pitch(imu(:,2:5));
        imu(:,8) = quaternion2roll(imu(:,2:5));
    end
    
    % Create GT pose (gt = diff + odom)
    %gt_pose = [odom_pose(:,1) odom_pose(:,2:end)+diff_pose(:,2:end)];
    
    % read real gt pose file
    [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/gt_pose.txt'), ...
        '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    gt_pose = [t, x, y, z, a, b, c, d];
    gt_pose(:,9) = quaternion2heading(gt_pose(:,5:8)); 
    gt_pose(:,10) = quaternion2pitch(gt_pose(:,5:8));
    gt_pose(:,11) = quaternion2roll(gt_pose(:,5:8));
    
    % convert diff heading QUAT to ZYX
    diff_pose(:,9) = quaternion2heading(diff_pose(:,5:8));
    hdg_err = diff_pose(:,9);
    
    % read odom heading file
    [hdg]=textread(horzcat(path_ca{i},'/odometry_heading.txt'), ...
        '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    odom_pose(:,9) = hdg;
    
    % read gt heading file
    [hdg]=textread(horzcat(path_ca{i},'/gt_heading.txt'), ...
        '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    gt_pose(:,9) = hdg;
    
%     hdg_err2 = gt_pose(:,9)-odom_pose(:,9);
    
    % Normalize time
    odom_pose(:,1) = (odom_pose(:,1) - odom_pose(1,1))/10^6;
    diff_pose(:,1) = (diff_pose(:,1) - diff_pose(1,1))/10^6;    
    gt_pose(:,1) = (gt_pose(:,1) - gt_pose(1,1))/10^6;
    if(CONTROL_FILE)
        control(:,1) = (control(:,1) - control(1,1))/10^6;
    end
    if(IMU_FILE)
        imu(:,1) = (imu(:,1) - imu(1,1))/10^6;
    end
    
    % cut neg time part
    gt_pose(gt_pose(:,1)<0,:) = [];
    diff_pose(diff_pose(:,1)<0,:) = [];
    odom_pose(odom_pose(:,1)<0,:) = [];

    % compute xy error norm
    diff_norm_xy = zeros(size(diff_pose,1),1);
    for j = 1:size(diff_pose,1)
        diff_norm_xy(j) = norm(diff_pose(j,2:3));
    end
    
    % compute xyz error norm
    diff_norm_xyz = zeros(size(diff_pose,1),1);
    for j = 1:size(diff_pose,1)
        diff_norm_xyz(j) = norm(diff_pose(j,2:4));
    end
    
    % travelled distance up to now
    dist_accum = zeros(size(odom_pose,1),1);
    for j = 2:size(gt_pose,1)
        dist = norm(gt_pose(j,2:4) - gt_pose(j-1,2:4));
        dist_accum(j) = dist + dist_accum(j-1);     
        %dist_accum(j) = norm(gt_pose(j,2:4) - gt_pose(1,2:4));
    end
    
    
    % currently spartan VO does NOT put time in the vo, so use the timestamps
    % from vicon
    odom_pose(:,1) = gt_pose(:,1);
    diff_pose(:,1) = gt_pose(:,1);
    
    % save in cell array
    diff_pose_ca{i} = diff_pose; clear diff_pose;
    odom_pose_ca{i} = odom_pose; clear odom_pose;
    diff_norm_xy_ca{i} = diff_norm_xy; clear diff_norm_xy;
    diff_norm_xyz_ca{i} = diff_norm_xyz; clear diff_norm_xyz;
    dist_accum_ca{i} = dist_accum; clear dist_accum;
    hdg_err_ca{i} = hdg_err; clear hdg_err;
    if(CONTROL_FILE)
        control_ca{i} = control; clear control;
    end
    gt_pose_ca{i} = gt_pose; clear gt_pose;
    if(IMU_FILE)
        imu_ca{i} = imu; clear imu;
    end
end


%% PLOT DATA 

% % remove by hand stuff over tot indexes
% tot=20;
% for i = 1:n_logs
%     dist_accum_ca{i} = dist_accum_ca{i}(1:tot);
%     diff_pose_ca{i} = diff_pose_ca{i}(1:tot,:);
%     diff_norm_xyz_ca{i} = diff_norm_xyz_ca{i}(1:tot);
% end

close all

% del = diff_pose_ca{2}(2,1) - diff_pose_ca{2}(1,1);
% diff_pose_ca{2}(:,1) = diff_pose_ca{2}(:,1) - del;
% diff_pose_ca{2}(1,1) = 0;

% % realign diff pose times (align test 3 to test 1, if needed align all to a single one)
% del = diff_pose_ca{3}(2,1) - diff_pose_ca{3}(1,1);
% diff_pose_ca{3}(:,1) = diff_pose_ca{3}(:,1) - del;
% diff_pose_ca{3}(1,1) = 0;


% % xy error norm over time vs distance travelled
% figure(101);
% hold on
% for i=1:n_logs
%     plot(dist_accum_ca{i}, diff_norm_xy_ca{i});
%     grid on;
%     xlabel('distance travelled [m]'), ylabel('xy error [m]')
% end
% plot(dist_accum_ca{i}, dist_accum_ca{i}*0.02, 'r--')
% title({'Visual Odometry Evaluation', 'xy error norm over travelled distance'});
% legend_names_t = [legend_names(:)', {'2% distance traveled'}]; legend(legend_names_t)
% hold off


% xyz error norm over distance travelled vs 2% error
figure(109);
hold on
for i=1:n_logs
    plot(dist_accum_ca{i}, diff_norm_xyz_ca{i});
    grid on;
    xlabel('distance travelled [m]'), ylabel('xyz error [m]')
end
plot(dist_accum_ca{i}, dist_accum_ca{i}*0.02, 'r--')
title({'Visual Odometry Evaluation', 'xyz error norm over travelled distance'});
legend_names_t = [legend_names(:)', {'2% distance traveled'}]; legend(legend_names_t)
hold off


% % xy error norm over time vs 2% error
% figure(102); close(102); figure(102);
% legend_names_2pdt = cell(1,n_logs);
% for i = 1:n_logs
%     legend_names_2pdt{(i-1)+i} = horzcat('test ', num2str(i));
%     legend_names_2pdt{(i-1)+i+1} = horzcat('test ', num2str(i), ', 2% distance traveled');
% end
% hold on
% for i=1:n_logs
%     plot(diff_pose_ca{i}(:,1), diff_norm_xy_ca{i}, diff_pose_ca{i}(:,1), dist_accum_ca{i}.*0.02, 'r--');
%     grid on;
%     xlabel('time [s]'), ylabel('xy error [m]')
% end
% plot(diff_pose_ca{i}(:,1), 0.03*diff_pose_ca{i}.*0.02, 'r-')
% title({'Visual Odometry Evaluation', 'xy error norm over time'});
% legend(legend_names_2pdt);
% hold off


% xyz error norm over time vs 2% error
figure(111); close(111); figure(111);
legend_names_2pdt = cell(1,n_logs);
for i = 1:n_logs
    legend_names_2pdt{(i-1)+i} = horzcat('test ', num2str(i));
    legend_names_2pdt{(i-1)+i+1} = horzcat('test ', num2str(i), ', 2% distance traveled');
end
hold on
for i=1:n_logs
    plot(diff_pose_ca{i}(:,1), diff_norm_xyz_ca{i}, '-*');%, diff_pose_ca{i}(:,1), dist_accum_ca{i}.*0.02, 'r--');
    grid on;
    xlabel('time [s]'), ylabel('xyz error [m]')
end
% plot(diff_pose_ca{i}(:,1), 0.03*diff_pose_ca{i}.*0.02, 'r-')
title({'Visual Odometry Evaluation', 'xyz error norm over time'});
legend(legend_names);%_2pdt);
hold off


% control over time
if(CONTROL_FILE)
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


% % ground truth trajectory on xy plane
% figure(104);
% hold on
% for i=1:n_logs
%     plot(gt_pose_ca{i}(:,2), gt_pose_ca{i}(:,3));
%     xlabel('x [m]'), ylabel('y [m]')
% end
% title({'Visual Odometry Evaluation', 'ground truth trajectory'});
% grid on, axis equal; 
% legend(legend_names);
% hold off


% % heading estimate vs heading gt over time
% figure(105);
% for i=1:n_logs
%     subplot(n_logs,1,i);
%     plot(odom_pose_ca{i}(:,1), odom_pose_ca{i}(:,9), gt_pose_ca{i}(:,1), gt_pose_ca{i}(:,9));
%     grid on, legend('odom heading', 'GT heading');
%     xlabel('time [s]'), ylabel('angle [rad]');
%     title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'heading error vs GT heading over time'});
% end


% x y z error components over time
figure(106); close(106); figure(106);
comp = {'X', 'Y', 'Z', 'XY'};
for j = 1:3
    subplot(2,2,j);
    hold on;
    for i=1:n_logs
        plot(diff_pose_ca{i}(:,1), diff_pose_ca{i}(:,j+1));
    end
    legend(legend_names);
    grid on, xlabel('time [s]'), ylabel('error [m]'), title(horzcat('Visual Odometry Evaluation - ', comp{j}, ' error over Time'));
    hold off;
end
subplot(2,2,4);
hold on;
for i=1:n_logs
    plot(diff_pose_ca{i}(:,1), diff_norm_xy_ca{i});
end
legend(legend_names);
grid on, xlabel('time [s]'), ylabel('error [m]'), title(horzcat('Visual Odometry Evaluation - XY error norm over Time'));
hold off;


% % IF NO FIRST STEP ERROR 
% % xy error norm over time vs distance travelled
% for i=1:n_logs
%     diff_norm_ca_nofirsterror{i} = [diff_norm_ca{i}(1); diff_norm_ca{i}(2:end) - diff_norm_ca{i}(2)];
% end
% figure(107);
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


% % heading error over time
% figure(108);
% hold on;
% for i=1:n_logs
%     plot(diff_pose_ca{i}(:,1), abs(rad2deg(diff_pose_ca{i}(:,9))));
%     grid on; xlabel('time [s]'), ylabel('angle [deg]');
%     title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'heading error over time'});
% end
% legend(legend_names);
% hold off;


% heading error over distance traveled
figure(110);
hold on;
for i=1:n_logs
    plot(dist_accum_ca{i}(:,1), abs(rad2deg(diff_pose_ca{i}(:,9))));
    grid on; xlabel('distance traveled [m]'), ylabel('angle [deg]');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'heading error over distance traveled'});
end
legend(legend_names);
hold off;


% heading, pitch, roll error of the IMU over time
if (IMU_FILE)
    figure(112);
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of imu
        gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,9),imu_ca{i}(:,1),'pchip');
        hdg_err_imu = gt_pose_interp - imu_ca{i}(:,6);
        
        %interpolate gt_pose to fill all the idx of imu
        gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,10),imu_ca{i}(:,1),'pchip');
        pitch_err_imu = gt_pose_interp - imu_ca{i}(:,7);
        
        %interpolate gt_pose to fill all the idx of imu
        gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,11),imu_ca{i}(:,1),'pchip');
        roll_err_imu = gt_pose_interp - imu_ca{i}(:,8);
        
        plot(imu_ca{i}(:,1), abs(rad2deg(hdg_err_imu)), imu_ca{i}(:,1), abs(rad2deg(pitch_err_imu)), imu_ca{i}(:,1), abs(rad2deg(roll_err_imu)));
        grid on; ylabel('Orientation error [deg]'), xlabel('time [s]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'orientation error over time'});
        legend('heading error', 'pitch error', 'roll error');
    end
    % legend(legend_names);
    hold off;
end

% figs used: 112


%% STUFF

% % compute telta time in vo samples
% t = 2;
% delta_time_vo(1) = odom_pose_ca{t}(1,1);
% for i=2:size(odom_pose_ca{t},1)-1
%     delta_time_vo(i) = odom_pose_ca{t}(i+1,1)-odom_pose_ca{t}(i,1);
% end
% 
% % fit line to diff_pose
% p = zeros(n_logs,2);
% for i=1:n_logs
%     p(i,:) = polyfit(dist_accum_ca{i}, diff_norm_xyz_ca{i}, 1);
% end
% p(:,1)
% 
% % plot errorn norm and fitted line
% i=1;
% figure;
% plot(dist_accum_ca{i}(:,1), diff_norm_xyz_ca{i}, dist_accum_ca{i}(:,1), dist_accum_ca{i}(:,1)*p(i,1) + p(i,2))
% 
% 






