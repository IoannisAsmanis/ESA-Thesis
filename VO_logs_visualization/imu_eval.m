%% COMPARE IMU AND VICON ORIENTATIONS
% IMPORTANT: for reasons beyond magic, sometimes odom_world.txt contains an
% extra header line. either delete it manually, or change the headerlines
% param in textread to from 2 to 3

clear all
close all
% clc

addpath('../functions')


% % check IMU
% % evaluatge imu on complex trajectory
% path_ca = {'logs/20191119-1403/with_imu'};
% vicon_path = 'logs/20191119-1359'; %'logs/20191115-1124';
% imu_path = 'logs/20191119-1359';

% % evaluatge imu on complex trajectory
% path_ca = {'logs/20191121-0928/with_imu'};
% vicon_path = 'logs/20191120-1356'; %'logs/20191115-1124';
% imu_path = 'logs/20191120-1356';

% % evaluatge imu on complex trajectory
path_ca = {'logs/20191119-1403/with_imu'};
vicon_path = 'logs/20191119-1359'; 
imu_path = 'logs/20191119-1359';

% % evaluatge imu on complex trajectory with new vicon object
path_ca = {'logs/20191121-1649/with_imu'};
vicon_path = 'logs/20191121-1619'; 
imu_path = 'logs/20191121-1619';

% % % evaluatge imu on 0.06m/s for 3m trajectory with new vicon object
path_ca = {'logs/20191121-1718/with_imu'};
vicon_path = 'logs/20191121-1715'; 
imu_path = 'logs/20191121-1715';


IMU_FILE = true;
CONTROL_FILE = false;
VICON_FILE_RPY = true;
VICON_FILE = true;
IMU_FILE_RPY = false;
ODOM_FILE = true;
ODOM_FILE_RPY = true;


%% READ FILES

n_logs = size(path_ca,1);

legend_names = cell(1,n_logs);
for i = 1:n_logs
    legend_names{i} = horzcat('test ', num2str(i));
end

dist_accum_ca = cell(1,n_logs);
control_ca = cell(1,n_logs);
gt_pose_ca = cell(1,n_logs);
imu_ca{i} = cell(1,n_logs);

for i=1:n_logs

    if(ODOM_FILE_RPY)
        % Read odometry file
        [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/odom_world.txt'), ...
            '%u%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 3, 'delimiter', '\t');
        odom_pose = [t/10^6, x, y, z, a, b, c, d];
        hdg =  textread(horzcat(path_ca{i},'/odom_heading.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        pitch =  textread(horzcat(path_ca{i},'/odom_pitch.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        roll =  textread(horzcat(path_ca{i},'/odom_roll.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        odom_pose(:,9:11) = [hdg, pitch, roll];
    else
        
    end
    if(IMU_FILE)
        % read imu file
        [t, b, c, d, a]=textread(horzcat(imu_path,'/imu.txt'), ...
            '%u%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        imu = [t/10^6, a, b, c, d];
%         imu = imu(1:18173,:);
    end
    if(~IMU_FILE_RPY)
        % convert to rpy
        imu(:,6) = quaternion2heading(imu(:,2:5));
        imu(:,7) = quaternion2pitch(imu(:,2:5));
        imu(:,8) = quaternion2roll(imu(:,2:5));
    else
        % read the real imu rpy logs
        hdg =  textread(horzcat(vicon_path,'/imu_heading.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        pitch =  textread(horzcat(vicon_path,'/imu_pitch.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        roll =  textread(horzcat(vicon_path,'/imu_roll.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        imu(:,6:8) = [hdg, pitch, roll];
    end
        
    if(~VICON_FILE)
        % read gt pose file
        [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/gt_pose.txt'), ...
            '%u%*f%*f%*f%*f%*f%*f%*f%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        gt_pose = [t/10^6, x, y, z, a, b, c, d];
    else
        % Read exoter pose file
        [t, x, y, z, b, c, d, a]=textread(horzcat(vicon_path,'/vicon.txt'), ... %path_ca{i},'/vicon.txt'), ...
            '%u%*f%*f%*f%*f%*f%*f%*f%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 3, 'delimiter', '\t');
        vicon_pose = [t/10^6, x, y, z, a, b, c, d];
    end
    
    if (~VICON_FILE_RPY)
        gt_pose(:,9) = quaternion2heading(gt_pose(:,5:8));
        gt_pose(:,10) = quaternion2pitch(gt_pose(:,5:8));
        gt_pose(:,11) = quaternion2roll(gt_pose(:,5:8));
    else
        % read the real vicon logs
        hdg =  textread(horzcat(vicon_path,'/vicon_heading.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        pitch =  textread(horzcat(vicon_path,'/vicon_pitch.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        roll =  textread(horzcat(vicon_path,'/vicon_roll.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        vicon_pose(:,9:11) = [hdg, pitch, roll];
    end
    
    if(CONTROL_FILE)
        % Read control file
        [ tr, rot, hdg]=textread(horzcat(path_ca{i},'/control.txt'), ...
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
    
    % Normalize time
    start_times = [];
    if(CONTROL_FILE)
        start_times = [start_times control_pose(1,1)];
    end
    if(IMU_FILE)
        start_times = [start_times imu(1,1)];
    end
    if(VICON_FILE)
        start_times = [start_times vicon_pose(1,1)];
    end
    if(ODOM_FILE)
        start_times = [start_times odom_pose(1,1)];
    end
    start_time = min(start_times);
    
    if(ODOM_FILE)
        odom_pose(:,1) = (odom_pose(:,1) - start_time);
    end
    if(CONTROL_FILE)
        control(:,1) = (control(:,1) - start_time);
    end
    if(IMU_FILE)
        imu(:,1) = (imu(:,1) - start_time);
    end
    if(VICON_FILE)
        vicon_pose(:,1) = (vicon_pose(:,1) - start_time);
    end
    
    % travelled distance 
    dist_accum = zeros(size(vicon_pose,1),1);
    for j = 2:size(vicon_pose,1)
        dist = norm(vicon_pose(j,2:4) - vicon_pose(j-1,2:4));
        dist_accum(j) = dist + dist_accum(j-1);
    end
    
    % save in a cell array
    imu_ca{i} = imu; clear imu;
%     gt_pose_ca{i} = gt_pose; clear gt_pose;
%     dist_accum_ca{i} = dist_accum; clear dist_accum;
    vicon_pose_ca{i} = vicon_pose; clear vicon_pose;
    if(CONTROL_FILE)
        control_ca{i} = control; clear control;
    end
    if(ODOM_FILE)
        odom_pose_ca{i} = odom_pose; clear odom_pose
    end

end


%% PLOT DATA 

close all

% rpy of GT vs rpy of imu over time
figure(200);
for i=1:n_logs
    %interpolate gt_pose to fill all the idx of imu
%     vicon_pose_interp(:,9) = interp1(vicon_pose_ca{i}(:,1),vicon_pose_ca{i}(:,9),imu_ca{i}(:,1),'pchip');
%     
%     %interpolate gt_pose to fill all the idx of imu
%     vicon_pose_interp(:,10) = interp1(vicon_pose_ca{i}(:,1),vicon_pose_ca{i}(:,10),imu_ca{i}(:,1),'pchip');
%     
%     %interpolate gt_pose to fill all the idx of imu
%     vicon_pose_interp(:,11) = interp1(vicon_pose_ca{i}(:,1),vicon_pose_ca{i}(:,11),imu_ca{i}(:,1),'pchip');
    
    subplot(2,2,1)
    plot(vicon_pose_ca{i}(:,1), rad2deg(vicon_pose_ca{i}(:,9)), imu_ca{i}(:,1), rad2deg(imu_ca{i}(:,6)));
    grid on; ylabel('Angle [deg]'), xlabel('time [s]'), legend('GT', 'IMU');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Heading'});
    
    subplot(2,2,2)
    plot(vicon_pose_ca{i}(:,1), rad2deg(vicon_pose_ca{i}(:,10)), imu_ca{i}(:,1), rad2deg(imu_ca{i}(:,7)));
    grid on; ylabel('Angle [deg]'), xlabel('time [s]'), legend('GT', 'IMU');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Pitch'});
    
    subplot(2,2,3)
    plot(vicon_pose_ca{i}(:,1), rad2deg(vicon_pose_ca{i}(:,11)), imu_ca{i}(:,1), rad2deg(imu_ca{i}(:,8)));
    grid on; ylabel('Angle [deg]'), xlabel('time [s]'), legend('GT', 'IMU');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Roll'});
end


% rpy of GT vs rpy of imu vs rpy of odom over time
figure(200);
for i=1:n_logs
 
    subplot(2,2,1)
    plot(vicon_pose_ca{i}(:,1), rad2deg(vicon_pose_ca{i}(:,9)), ...
        imu_ca{i}(:,1), rad2deg(imu_ca{i}(:,6)-pi+vicon_pose_ca{i}(1,9)), ...
        odom_pose_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,9)));
    grid on; ylabel('Angle [deg]'), xlabel('time [s]'), legend('GT', 'IMU', 'VO');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Heading'});
    
    subplot(2,2,2)
    plot(vicon_pose_ca{i}(:,1), rad2deg(vicon_pose_ca{i}(:,10)), ...
        imu_ca{i}(:,1), rad2deg(imu_ca{i}(:,7)), ...
        odom_pose_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,10)));
    grid on; ylabel('Angle [deg]'), xlabel('time [s]'), legend('GT', 'IMU', 'VO');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Pitch'});
    
    subplot(2,2,3)
    plot(vicon_pose_ca{i}(:,1), rad2deg(vicon_pose_ca{i}(:,11)), ...
        imu_ca{i}(:,1), rad2deg(imu_ca{i}(:,8)), ...
        odom_pose_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,11)));
    grid on; ylabel('Angle [deg]'), xlabel('time [s]'), legend('GT', 'IMU', 'VO');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Roll'});
end

% heading, pitch, roll error of the IMU over time
figure(201);
hold on;
for i=1:n_logs
    %interpolate gt_pose to fill all the idx of imu
    vicon_pose_interp = interp1(vicon_pose_ca{i}(:,1),vicon_pose_ca{i}(:,10),imu_ca{i}(:,1),'pchip');
    pitch_err_imu = vicon_pose_interp - imu_ca{i}(:,7);
    
    %interpolate gt_pose to fill all the idx of imu
    vicon_pose_interp = interp1(vicon_pose_ca{i}(:,1),vicon_pose_ca{i}(:,11),imu_ca{i}(:,1),'pchip');
    roll_err_imu = vicon_pose_interp - imu_ca{i}(:,8);
    
    plot(imu_ca{i}(:,1), (rad2deg(pitch_err_imu)), imu_ca{i}(:,1), (rad2deg(roll_err_imu)));
    grid on; ylabel('Orientation error [deg]'), xlabel('time [s]');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'orientation error over time'});
    legend('pitch error', 'roll error');
end
% legend(legend_names);
hold off;


% xy plot - line
figure(202);
hold on
for i=1:n_logs
    plot(vicon_pose_ca{i}(:,2), vicon_pose_ca{i}(:,3));
    grid on, axis equal;
    xlabel('x [m]'), ylabel('y [m]'), title('Visual Odometry Evaluation - XY Plane GT trajectory');
end
hold off


% Last fig used: 202
    