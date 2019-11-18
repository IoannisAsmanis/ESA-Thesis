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
% path_ca = {
%     'logs/20191107-1345', %1056', % start at t=1
%     'logs/20191107-1346'}; %1057'}; % start at t=6


% initial error investigation on Spartan VO - forwards then backwards
% path_ca = {
%     'logs/20191107-1314', % start immediately at t=1
%     'logs/20191107-1304'}; % start later at t=6

% initial error investigation on Spartan VO if removing vo steps
% path_ca = {
%     'logs/20191107-1345', % start at t=1
%     'logs/20191107-1510', % start at t=1 with the if
%     'logs/20191107-1557', % start at t=1 with the ifx3
%     'logs/20191107-1619', % start at t=1 with the ifx5
%     'logs/20191107-1630', % start at t=1 with the ifx15
%     'logs/20191107-1346', % start at t=6
%     'logs/20191107-1509', % start at t=6 with the if
%     'logs/20191107-1556', % start at t=6 with the ifx3
%     'logs/20191107-1620', % start at t=6 with the ifx5
%     'logs/20191107-1632'}; % start at t=6 with the ifx15

% % gradual acceleration
% path_ca = {
%     'logs/20191108-1633', % instant at t=1
%     'logs/20191108-1634', % instant at t=1
%     'logs/20191108-1635', % instant at t=1
%     'logs/20191108-1636', % instant at t=1
%     'logs/20191108-1637', % instant at t=1
%     'logs/20191108-1638', % instant at t=1
%     'logs/20191108-1638.1', % instant at t=1
%     'logs/20191111-1901', % instant at t=1
% %     'logs/20191111-1902', % instant at t=1
%     'logs/20191111-1903', % instant at t=1
%     'logs/20191111-1904', % instant at t=1
%     'logs/20191111-1905', % instant at t=1
%     'logs/20191111-1906', % instant at t=1
%     'logs/20191111-1906.1', % instant at t=1
%     'logs/20191111-1907', % instant at t=1
%     'logs/20191111-1908'}; % vstep=0.01 with tstep=0.5

% % check IMU
% path_ca = {
% %     'logs/20191111-0950'}; % 
%     'logs/20191113-1756'}; %
    
% % comparing transforms
% path_ca = {
%     'logs/20191108-1731', % instant at t=1
%     'logs/20191108-1752', % instant at t=1
%     'logs/20191108-1754', % instant at t=1
%     'logs/20191108-1757', % instant at t=1
%     'logs/20191108-1806'}; % 

% 0.9m\s sequence with and w/o numericla correction
% path_ca = {
%     'logs/20191105-1623',
%     'logs/20191112-1644'};

% 0.7m\s for 10s with different exposure
% path_ca = {
%     'logs/20191113-0948',
%     'logs/20191113-0953'};

% % ingle velocity test
% patch_ca = {'logs/20191105-1619'}; % test at 0.07 from 20191101-1513

% new vo timing and vicon interp
% path_ca = {'logs/20191113-1300'};

% % single test
path_ca = {'logs/20191115-1403/no_imu'};

% % check WITH_IMU vs NO_IMU (BEST SO FAR IS 20191115-1403 or 1742)
% path_ca = {
%     'logs/20191115-1403/no_imu'
%     'logs/20191115-1403/with_imu'}; % 20191111-0950 20191113-1756
% path_ca = {
%     'logs/20191115-1742/no_imu'
%     'logs/20191115-1742/with_imu'}; % 20191111-0950 20191113-1756
% path_ca = {
%     'logs/20191114-1438/no_imu'
%     'logs/20191114-1438/with_imu'}; % 20191111-0950 20191113-1756
% path_ca = {
%     'logs/20191107-1346'
%     'logs/20191114-1438/with_imu'}; % 20191111-0950 20191113-1756
% path_ca = {
%     'logs/20191114-1643/no_imu'
%     'logs/20191114-1643/with_imu'}; % 20191111-0950 20191113-1756
% path_ca = {
%     'logs/20191114-1653.1/no_imu'
%     'logs/20191114-1653.1/with_imu'}; % 20191111-0950 20191113-1756
% path_ca = {
%     'logs/20191114-1726/no_imu'
%     'logs/20191114-1726/with_imu'}; % 20191111-0950 20191113-1756
% path_ca = {
%     'logs/20191115-1041/no_imu'
%     'logs/20191115-1041/with_imu'}; 
% path_ca = {
%     'logs/20191115-1132/no_imu'
%     'logs/20191115-1132/with_imu'}; %1126
% path_ca = {
%     'logs/20191115-1627/no_imu'
%     'logs/20191115-1627/with_imu'}; 
% path_ca = {
%     'logs/20191115-1718/no_imu'
%     'logs/20191115-1718/with_imu'}; % 1706
% path_ca = {
%     'logs/20191115-1706/no_imu'
%     'logs/20191115-1706/with_imu'}; 

% % comparing transforms ON 15-1124
% path_ca = {
%     'logs/20191115-1404/with_imu', % instant at t=1
%     'logs/20191115-1413/with_imu', % instant at t=1
%     'logs/20191115-1403/with_imu', % instant at t=1
%     'logs/20191115-1358/with_imu', % instant at t=1
%     'logs/20191115-1332/with_imu', % instant at t=1
%     'logs/20191115-1324/with_imu', % instant at t=1
%     'logs/20191115-1331/with_imu', % instant at t=1
%     'logs/20191115-1328/with_imu', % instant at t=1
%     'logs/20191115-1306/with_imu', % instant at t=1
%     'logs/20191115-1309/with_imu', % instant at t=1
%     'logs/20191115-1312/with_imu'}; % 

% % comparing transforms on 15-1335
% path_ca = {
%     'logs/20191115-1734/with_imu', % instant at t=1
%     'logs/20191115-1735/with_imu', % instant at t=1
%     'logs/20191115-1736/with_imu', % instant at t=1
%     'logs/20191115-1738/with_imu', % instant at t=1
%     'logs/20191115-1739/with_imu', % instant at t=1
%     'logs/20191115-1741/with_imu', % instant at t=1
%     'logs/20191115-1742/with_imu', % instant at t=1
%     'logs/20191115-1745/with_imu', % instant at t=1
%     'logs/20191115-1747/with_imu', % instant at t=1
%     'logs/20191115-1748/with_imu', % instant at t=1
%     'logs/20191115-1749/with_imu'}; % 


% set true if also other files are provided in the log folder
CONTROL_FILE = false; control_path = '';
IMU_FILE = false; imu_path = '';
ODOM_TIME = true; % set false if vicon and odom have no timestamp
VICON_FILE = true; %vicon_path = 'logs/20191101-1501'; %'logs/20191115-1124';
VICON_FILE_RPY = false; %new vicon output with also hdg, roll, pitch
ODOM_FILE_RPY = false; %new odom fole with also hdg, roll, pitch


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
vicon_pose_ca = cell(1,n_logs);
vicon_pose_interp_ca = cell(1,n_logs);

for i=1:n_logs
    
    % Read odometry file
    [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/odom_world.txt'), ...
        '%u%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 3, 'delimiter', '\t');
    odom_pose = [t/10^6, x, y, z, a, b, c, d];
    
    % Read difference odometry/vicon file
    [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/diff_pose.txt'), ...
        '%u%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    diff_pose = [t/10^6, x, y, z, a, b, c, d];
    
    if(CONTROL_FILE)
        % Read control file
        [tr, rot, hdg]=textread(horzcat(path_ca{i},'/control.txt'), ...
            '%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        
        % Read control time file
        t=textread(horzcat(path_ca{i},'/control_time.txt'), ...
            '%u', 'headerlines', 2);
        t(size(tr,1)) = t(end);
        control = [t/10^6, tr, rot];
        
        % align control signals
        control(control(:,2) == 0, :) = [];
        % add end of control signal
        control(end+1,:) = [control(end,1) 0 0];
    end
    
    if(IMU_FILE)
        % read imu file
        [t, b, c, d, a]=textread(horzcat(path_ca{i},'/imu.txt'), ...
            '%u%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        imu = [t/10^6, a, b, c, d];
        imu(:,6) = quaternion2heading(imu(:,2:5));
        imu(:,7) = quaternion2pitch(imu(:,2:5));
        imu(:,8) = quaternion2roll(imu(:,2:5));
    end
    
    if (VICON_FILE)
        % Read exoter pose file
        [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/vicon.txt'), ...
            '%u%*f%*f%*f%*f%*f%*f%*f%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 3, 'delimiter', '\t');
        vicon_pose = [t/10^6, x, y, z, a, b, c, d];
    end
    
    if (ODOM_FILE_RPY)
        hdg =  textread(horzcat(path_ca{i},'/odom_heading.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        pitch =  textread(horzcat(path_ca{i},'/odom_pitch.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        roll =  textread(horzcat(path_ca{i},'/odom_roll.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        odom_pose(:,9:11) = [hdg, pitch, roll];
    end
    
    if (VICON_FILE_RPY)
        hdg =  textread(horzcat(path_ca{i},'/vicon_heading.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        pitch =  textread(horzcat(path_ca{i},'/vicon_pitch.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        roll =  textread(horzcat(path_ca{i},'/vicon_roll.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        vicon_pose(:,9:11) = [hdg, pitch, roll];
    end
    
    % Create GT pose (gt = diff + odom)
    %gt_pose = [odom_pose(:,1) odom_pose(:,2:end)+diff_pose(:,2:end)];
    
    % read gt pose file
    [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/gt_pose.txt'), ...
        '%u%*f%*f%*f%*f%*f%*f%*f%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
%         '%u%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');        
    gt_pose = [t/10^6, x, y, z, a, b, c, d];
    gt_pose(:,9) = quaternion2heading(gt_pose(:,5:8)); 
    gt_pose(:,10) = quaternion2pitch(gt_pose(:,5:8));
    gt_pose(:,11) = quaternion2roll(gt_pose(:,5:8));
    
    % convert diff heading QUAT to ZYX
    diff_pose(:,9) = quaternion2heading(diff_pose(:,5:8));
    hdg_err = diff_pose(:,9);
    diff_pose(:,10) = quaternion2pitch(diff_pose(:,5:8));
    diff_pose(:,11) = quaternion2roll(diff_pose(:,5:8));
    % convert odom heading QUAT to ZYX
    if (~ODOM_FILE_RPY)
        odom_pose(:,9) = quaternion2heading(odom_pose(:,5:8));
        odom_pose(:,10) = quaternion2pitch(odom_pose(:,5:8));
        odom_pose(:,11) = quaternion2roll(odom_pose(:,5:8));
    end
    % convert vicon heading QUAT to ZYX
    if (~VICON_FILE_RPY)
        vicon_pose(:,9) = quaternion2heading(vicon_pose(:,5:8));
        vicon_pose(:,10) = quaternion2pitch(vicon_pose(:,5:8));
        vicon_pose(:,11) = quaternion2roll(vicon_pose(:,5:8));
    end
    
%     % read odom heading file
%     if (~ODO_FILE_RPY)
%         [hdg]=textread(horzcat(path_ca{i},'/odometry_heading.txt'), ...
%             '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
%         odom_pose(:,9) = hdg;
%     end
%     % read gt heading file
%     [hdg]=textread(horzcat(path_ca{i},'/gt_heading.txt'), ...
%         '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
%     gt_pose(:,9) = hdg;
    
    % create heading error manually
%     hdg_err2 = gt_pose(:,9)-odom_pose(:,9);
    
    % Normalize time
    start_times = [odom_pose(1,1) diff_pose(1,1) gt_pose(1,1)];
    if(CONTROL_FILE)
        start_times = [start_times control_pose(1,1)];
    end
    if(IMU_FILE)
        start_times = [start_times imu(1,1)];
    end
    if(VICON_FILE)
        start_times = [start_times vicon_pose(1,1)];
    end
    start_time = min(start_times);
    
    odom_pose(:,1) = (odom_pose(:,1) - start_time);
    diff_pose(:,1) = (diff_pose(:,1) - start_time);    
    gt_pose(:,1) = (gt_pose(:,1) - start_time);
    if(CONTROL_FILE)
        control(:,1) = (control(:,1) - start_time);
    end
    if(IMU_FILE)
        imu(:,1) = (imu(:,1) - start_time);
    end
    if(VICON_FILE)
        vicon_pose(:,1) = (vicon_pose(:,1) - start_time);
    end
    
    % cut neg time part
%     gt_pose(gt_pose(:,1)<0,:) = [];
%     diff_pose(diff_pose(:,1)<0,:) = [];
%     odom_pose(odom_pose(:,1)<0,:) = [];

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
    dist_accum = zeros(size(gt_pose,1),1);
    for j = 2:size(gt_pose,1)
        dist = norm(gt_pose(j,2:4) - gt_pose(j-1,2:4));
        dist_accum(j) = dist + dist_accum(j-1);     
        %dist_accum(j) = norm(gt_pose(j,2:4) - gt_pose(1,2:4));
    end
    
    
    % initially spartan VO did NOT put time in the vo, so use the timestamps from vicon
    if (~ODOM_TIME)
        odom_pose(:,1) = gt_pose(:,1);
        diff_pose(:,1) = gt_pose(:,1);
    end
    
    % save in cell array and clear loop vars
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
    if(VICON_FILE)
        vicon_pose_ca{i} = vicon_pose; clear vicon_pose;
    end
    clear start_times, clear start_time
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


% ground truth trajectory on xy plane
figure(104);
hold on
for i=1:n_logs
    plot(gt_pose_ca{i}(:,1), gt_pose_ca{i}(:,2));
    xlabel('x [m]'), ylabel('y [m]')
end
title({'Visual Odometry Evaluation', 'ground truth trajectory'});
grid on, %axis equal; 
legend(legend_names);
hold off


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

% % compare error=gt_intepr(from gt in viso2_eval) - odom VS diff_pose
% figure(113), close(113), figure(113);
% subplot(2,1,1)
% hold on;
% for i=1:n_logs
%     %interpolate gt_pose to fill all the idx of odo_pose
%     gt_pose_interp = interp1(gt_pose_ca{i}(:,1), gt_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip');
% 
%     plot(odom_pose_ca{i}(:,1), gt_pose_interp - odom_pose_ca{i}(:,2), ...
%         diff_pose_ca{i}(:,1), diff_pose_ca{i}(:,2));
%     grid on; ylabel('X error [deg]'), xlabel('time [s]');
%     title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'x error over time'});
% end
% legend(legend_names);
% hold off;
% subplot(2,1,2)
% hold on;
% for i=1:n_logs
%     plot(gt_pose_ca{i}(:,1), gt_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), gt_pose_interp)
%     title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'GT POSE vg GT POSE INTERP over time'});
% end
% legend('GT pose', 'GT pose interp')
% hold off


if (VICON_FILE)
    figure(114), close(114), figure(114);
    subplot(3,1,1)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i} = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        plot(odom_pose_ca{i}(:,1), vicon_pose_interp_ca{i} - odom_pose_ca{i}(:,2), ...
            diff_pose_ca{i}(:,1), diff_pose_ca{i}(:,2));
        grid on; ylabel('X error [m]'), xlabel('time [s]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'x error over time'});
    end
    legend('diff pose interp', 'diff pose original') %legend(legend_names);
    hold off;
    
    subplot(3,1,2)
    hold on;
    for i=1:n_logs
        plot(gt_pose_ca{i}(:,1), gt_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), vicon_pose_interp_ca{i})
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'GT POSE vs GT POSE INTERP over time'});
        ylabel('x [m]'), xlabel('time [s]'), grid on
    end
    legend('GT pose', 'GT pose interp')
    hold off
    
    subplot(3,1,3)
    hold on;
    for i=1:n_logs
        plot(odom_pose_ca{i}(:,1), odom_pose_ca{i}(:,2), '-*')
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'odom pose over time'});
        ylabel('x [m]'), xlabel('time [s]'), grid on
    end
    legend('odom pose')
    hold off
end


% new xyz error norm from vicon and odom interp and synchronized over time
if (VICON_FILE)
    figure(115), close(115), figure(115);
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i}(:,2) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,3) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,4) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        for j = 1:size(odom_pose_ca{i}(:,1),1)
            xyz_norm{i}(j) = norm([vicon_pose_interp_ca{i}(j,2) - odom_pose_ca{i}(j,2), ...
                         vicon_pose_interp_ca{i}(j,3) - odom_pose_ca{i}(j,3), ...
                         vicon_pose_interp_ca{i}(j,4) - odom_pose_ca{i}(j,4)]);
        end
        plot(odom_pose_ca{i}(:,1), xyz_norm{i});
        grid on; ylabel('X error [m]'), xlabel('time [s]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'xyz error norm over time'});
    end
    legend(legend_names);
    hold off;  
end


% new xyz error norm from vicon and odom interp and synchronized over dist
% travelled
if (VICON_FILE)
    figure(116), close(116), figure(116);
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i}(:,2) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,3) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,4) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        for j = 1:size(odom_pose_ca{i}(:,1),1)
            xyz_norm{i}(j,1) = norm([vicon_pose_interp_ca{i}(j,2) - odom_pose_ca{i}(j,2), ...
                         vicon_pose_interp_ca{i}(j,3) - odom_pose_ca{i}(j,3), ... 
                         vicon_pose_interp_ca{i}(j,4) - odom_pose_ca{i}(j,4)]);
        end
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        plot(dist_accum_ca{i}(:,1), xyz_norm{i}(:,1), '-*', dist_accum_ca{i}(:,1), 0.02*dist_accum_ca{i}(:,1), 'r--');
        grid on; ylabel('X error [m]'), xlabel('Distance traveled [m]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'xyz error norm over distance'});
    end
    legend(legend_names_2pdt);
    hold off;
end


% x,y,z error components from vicon and odom interp and synchronized over dist
% travelled
if (VICON_FILE)
    figure(117), close(117), figure(117);
    
    subplot(2,2,1)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i}(:,2) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,3) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,4) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        
        plot(dist_accum_ca{i}(:,1), vicon_pose_interp_ca{i}(:,2) - odom_pose_ca{i}(:,2), '-*', dist_accum_ca{i}(:,1), 0.02*dist_accum_ca{i}(:,1), 'r--');
        grid on; ylabel('X error [m]'), xlabel('Distance traveled [m]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'x error component over distance'});
    end
    legend(legend_names_2pdt);
    hold off;
    
    subplot(2,2,2)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i}(:,2) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,3) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,4) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        
        plot(dist_accum_ca{i}(:,1), vicon_pose_interp_ca{i}(:,3) - odom_pose_ca{i}(:,3), '-*', dist_accum_ca{i}(:,1), 0.02*dist_accum_ca{i}(:,1), 'r--');
        grid on; ylabel('Y error [m]'), xlabel('Distance traveled [m]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'y error component over distance'});
    end
    legend(legend_names_2pdt);
    hold off;
    
    subplot(2,2,3)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i}(:,2) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,3) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,4) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        
        plot(dist_accum_ca{i}(:,1), vicon_pose_interp_ca{i}(:,4) - odom_pose_ca{i}(:,4), '-*', dist_accum_ca{i}(:,1), 0.02*dist_accum_ca{i}(:,1), 'r--');
        grid on; ylabel('Z error [m]'), xlabel('Distance traveled [m]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'z error component over distance'});
    end
    legend(legend_names_2pdt);
    hold off;
    
    subplot(2,2,4)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i}(:,2) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,3) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,4) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        for j = 1:size(odom_pose_ca{i}(:,1),1)
            xyz_norm{i}(j,1) = norm([vicon_pose_interp_ca{i}(j,2) - odom_pose_ca{i}(j,2), ...
                         vicon_pose_interp_ca{i}(j,3) - odom_pose_ca{i}(j,3), ... 
                         vicon_pose_interp_ca{i}(j,4) - odom_pose_ca{i}(j,4)]);
        end
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        plot(dist_accum_ca{i}(:,1), xyz_norm{i}(:,1), '-*', dist_accum_ca{i}(:,1), 0.02*dist_accum_ca{i}(:,1), 'r--');
        grid on; ylabel('XYZ error norm [m]'), xlabel('Distance traveled [m]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'xyz error norm over distance'});
    end
    legend(legend_names_2pdt);
    hold off;
end


% hdg pitch roll errors from vicon and odom interp and synchronized over dist
% travelled
if (VICON_FILE)
    figure(118), close(118), figure(118);
    
    subplot(2,2,1)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i}(:,9) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,9), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,10) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,10), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,11) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,11), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,9) - odom_pose_ca{i}(:,9)), '-*');
        grid on; ylabel('heading error [deg]'), xlabel('Distance traveled [m]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'heading error component over distance'});
    end
    legend(legend_names);
    hold off;
    
    subplot(2,2,2)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i}(:,9) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,9), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,10) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,10), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,11) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,11), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,10) - odom_pose_ca{i}(:,10)), '-*');
        grid on; ylabel('pitch error [deg]'), xlabel('Distance traveled [m]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'pitch error component over distance'});
    end
    legend(legend_names);
    hold off;
    
    subplot(2,2,3)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i}(:,9) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,9), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,10) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,10), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,11) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,11), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,11) - odom_pose_ca{i}(:,11)), '-*');
        grid on; ylabel('roll error [deg]'), xlabel('Distance traveled [m]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'roll error component over distance'});
    end
    legend(legend_names);
    hold off;
    
    subplot(2,2,4)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        vicon_pose_interp_ca{i}(:,9) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,9), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,10) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,10), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,11) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,11), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % compute norm of rpy error
        for j = 1:size(odom_pose_ca{i}(:,1),1)
            rpy_norm{i}(j,1) = norm([vicon_pose_interp_ca{i}(j,9) - odom_pose_ca{i}(j,9), ...
                         vicon_pose_interp_ca{i}(j,10) - odom_pose_ca{i}(j,10), ... 
                         vicon_pose_interp_ca{i}(j,11) - odom_pose_ca{i}(j,11)]);
        end
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        plot(dist_accum_ca{i}(:,1), rpy_norm{i}(:,1), '-*');
        grid on; ylabel('rpy error norm [deg]'), xlabel('Distance traveled [m]');
        title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'rpy error norm over distance'});
    end
    legend(legend_names);
    hold off;
end


% RPY gt
if(VICON_FILE)
    figure(119), close(119), figure(119)
    
    legend_names_2pdt = cell(1,n_logs);
    for i = 1:n_logs
        legend_names_2pdt{(i-1)+i} = horzcat('test ', num2str(i), ' GT');
        legend_names_2pdt{(i-1)+i+1} = horzcat('test ', num2str(i), ' Odom');
    end

    for i = 1:n_logs
        subplot(2,2,1)
        hold on
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,9)), dist_accum_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,9)))
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Heading GT vs Heading Odom over time'})
        legend(legend_names_2pdt), ylabel('angle [deg]'), xlabel('time [s]')
        hold off
        
        subplot(2,2,2)
        hold on
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,10)), dist_accum_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,10)))
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Pitch GT vs Pitch Odom over time'})
        legend(legend_names_2pdt), ylabel('angle [deg]'), xlabel('time [s]')
        hold off
        
        subplot(2,2,3)
        hold on
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,11)), dist_accum_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,11)))
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Roll GT vs Roll Odomover time'})
        legend(legend_names_2pdt), ylabel('angle [deg]'), xlabel('time [s]')
        hold off
    end
end


% figs used: 119






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
% figure;
% hold on;
% for i=1:n_logs
%     plot(diff_pose_ca{i}(:,1), abs(rad2deg(diff_pose_ca{i}(:,10))))
%     grid on; ylabel('Orientation error [deg]'), xlabel('time [s]');
%     title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'orientation error over time'});
% end
% legend('pitch error 1', 'pitch error 2');hold off;
% 
% 
% [odom_pose_ca{1}(:,1) odom_pose_ca{1}(:,2) vicon_pose_interp];
% 
% 
% figure()
% for i=1:n_logs
%     plot(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), ...
%          odom_pose_ca{i}(:,1), odom_pose_ca{i}(:,2))
% end


