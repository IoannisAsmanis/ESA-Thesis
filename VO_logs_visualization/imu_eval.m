%% COMPARE IMU AND VICON ORIENTATIONS
% IMPORTANT: for reasons beyond magic, sometimes odom_world.txt contains an
% extra header line. either delete it manually, or change the headerlines
% param in textread to from 2 to 3

clear all
close all
% clc

addpath('../functions')


% % check IMU
path_ca = {
    'logs/20191111-0950'}; % instant at t=1


CONTROL_FILE = true;


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

    % read imu file
    [t, b, c, d, a]=textread(horzcat(path_ca{i},'/imu.txt'), ...
        '%d%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    imu = [t, a, b, c, d];
    imu(:,6) = quaternion2heading(imu(:,2:5));
    imu(:,7) = quaternion2pitch(imu(:,2:5));
    imu(:,8) = quaternion2roll(imu(:,2:5));
    
    % read real gt pose file
    [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/gt_pose.txt'), ...
    '%d%*f%*f%*f%*f%*f%*f%*f%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    gt_pose = [t, x, y, z, a, b, c, d];
    gt_pose(:,9) = quaternion2heading(gt_pose(:,5:8));
    gt_pose(:,10) = quaternion2pitch(gt_pose(:,5:8));
    gt_pose(:,11) = quaternion2roll(gt_pose(:,5:8));    
    
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
    
    % normalize time
    gt_pose(:,1) = (gt_pose(:,1) - gt_pose(1,1))/10^6;
    imu(:,1) = (imu(:,1) - imu(1,1))/10^6;
    if(CONTROL_FILE)
        control(:,1) = (control(:,1) - control(1,1))/10^6;
    end
    
    % travelled distance 
    dist_accum = zeros(size(gt_pose,1),1);
    for j = 2:size(gt_pose,1)
        dist = norm(gt_pose(j,2:4) - gt_pose(j-1,2:4));
        dist_accum(j) = dist + dist_accum(j-1);
    end
    
    % save in a cell array
    imu_ca{i} = imu; clear imu;
    gt_pose_ca{i} = gt_pose; clear gt_pose;
    dist_accum_ca{i} = dist_accum; clear dist_accum;
    if(CONTROL_FILE)
        control_ca{i} = control; clear control;
    end

end


%% PLOT DATA 

close all

% % heading, pitch, roll error of the IMU over time
% figure(200);
% hold on;
% for i=1:n_logs
%     %interpolate gt_pose to fill all the idx of imu
%     gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,9),imu_ca{i}(:,1),'pchip');
%     hdg_err_imu = gt_pose_interp - imu_ca{i}(:,6);
%     
%     %interpolate gt_pose to fill all the idx of imu
%     gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,10),imu_ca{i}(:,1),'pchip');
%     pitch_err_imu = gt_pose_interp - imu_ca{i}(:,7);
%     
%     %interpolate gt_pose to fill all the idx of imu
%     gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,11),imu_ca{i}(:,1),'pchip');
%     roll_err_imu = gt_pose_interp - imu_ca{i}(:,8);
%     
%     plot(imu_ca{i}(:,1), abs(rad2deg(hdg_err_imu)), imu_ca{i}(:,1), abs(rad2deg(pitch_err_imu)), imu_ca{i}(:,1), abs(rad2deg(roll_err_imu)));
%     grid on; ylabel('Orientation error [deg]'), xlabel('time [s]');
%     title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'orientation error over time'});
%     legend('heading error', 'pitch error', 'roll error');
% end
% % legend(legend_names);
% hold off;


% heading, pitch, roll error of the IMU over time
figure(201);
subplot(2,1,1)
hold on;
for i=1:n_logs
    %interpolate gt_pose to fill all the idx of imu
    gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,10),imu_ca{i}(:,1),'pchip');
    pitch_err_imu = gt_pose_interp - imu_ca{i}(:,7);
    
    %interpolate gt_pose to fill all the idx of imu
    gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,11),imu_ca{i}(:,1),'pchip');
    roll_err_imu = gt_pose_interp - imu_ca{i}(:,8);
    
    plot(imu_ca{i}(:,1), (rad2deg(pitch_err_imu)), imu_ca{i}(:,1), (rad2deg(roll_err_imu)));
    grid on; ylabel('Orientation error [deg]'), xlabel('time [s]');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'orientation error over time'});
    legend('pitch error', 'roll error');
end
% legend(legend_names);
hold off;
subplot(2,1,2)
hold on
for i=1:n_logs
    plot(control_ca{i}(:,1), control_ca{i}(:,2), control_ca{i}(:,1), control_ca{i}(:,3));
    grid on; ylabel('motion command [deg]'), xlabel('time [s]');
    title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'motion command over time'});
    legend('translation command', 'orientation command')
end
hold off

% xy plot - line
figure(202);
hold on
for i=1:n_logs
    plot(gt_pose_ca{i}(:,2), gt_pose_ca{i}(:,3));
    grid on, axis equal;
    xlabel('x [m]'), ylabel('y [m]'), title('Visual Odometry Evaluation - XY Plane GT trajectory');
end
hold off


% Last fig used: 202
    