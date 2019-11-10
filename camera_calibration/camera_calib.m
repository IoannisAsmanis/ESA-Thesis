%% CAMERA CALIBRATION
clear all
close all 
clc

% add functions path
addpath 'C:\Users\Matteo de Benedetti\Documents\ESA-Thesis\functions'


%% Read Files

% Read camera pose file
path = 'logs/20190926-1434';
[t, x, y, z, b, c, d, a]=textread(horzcat(path,'/camera_vicon_pose.txt'), ...
    '%d%*f%*f%*f%*f%*f%*f%*f%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
cam_pose = [t, x, y, z, a, b, c, d];

% Read exoter pose file
path = 'logs/20190926-1434';
[t, x, y, z, b, c, d, a]=textread(horzcat(path,'/exoter_vicon_pose.txt'), ...
    '%d%*f%*f%*f%*f%*f%*f%*f%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
exoter_pose = [t, x, y, z, a, b, c, d];


%% Process data

% remove NaNs
for i = 1:size(cam_pose,2)
    cam_pose(any(isnan(cam_pose(i,:))), :) = [];
end

% average data
cam_pose_avg = mean(cam_pose); 
exoter_pose_avg = mean(exoter_pose);

% % print pos
% cam_pose_avg(2:4)
% exoter_pose_avg(2:4)
% print quat
% cam_pose_avg(5:8)
% exoter_pose_avg(5:8)

% convert quaternion to Euler ZYX
cam_eul = [quaternion2heading(cam_pose_avg(5:8))
           quaternion2pitch(cam_pose_avg(5:8))
           quaternion2roll(cam_pose_avg(5:8))];
% cam_eul2 = quat2eul(cam_pose_avg(5:8), 'ZYX')';   
exoter_eul = [quaternion2heading(exoter_pose_avg(5:8))
              quaternion2pitch(exoter_pose_avg(5:8))
              quaternion2roll(exoter_pose_avg(5:8))];       
% exoter_eul2 = quat2eul(exoter_pose_avg(5:8), 'ZYX')'; 

          
%% Create transform from world to exoter body 

% Create homogenous transformation of world->body: T_world_body
T_world_body = eul2tform(exoter_eul'); %W_body_camera(1:3,4) = W_body_camera_pos;

% Create position vector of body->camera in world-frame: w_body_camera_pos = [x y z]
w_body_camera_pos = cam_pose_avg(2:4) - exoter_pose_avg(2:4);
% Create orientation vector of body->camera: body_camera_orient = Euler ZYX
body_camera_orient = cam_eul - exoter_eul;

% apply world->body to W_body_camera_orient: b_body_camera
b_body_camera_pos = w_body_camera_pos*T_world_body(1:3,1:3);


% print final pos and orient
b_body_camera_pos
body_camere_orient_DEG = rad2deg(body_camera_orient)






%% stuff
% 
% % Create transformation of body->camera in World-frame: W_body_camera
% % W_body_camera_pos = [x y z]
% W_body_camera_pos = cam_pose_avg(2:4) - exoter_pose_avg(2:4);
% % W_body_camera_orient = Euler ZYX
% W_body_camera_orient = cam_eul - exoter_eul;
% % W_body_camera = Homogenous Transformation
% W_body_camera = eul2tform(W_body_camera_orient'); %W_body_camera(1:3,4) = W_body_camera_pos;