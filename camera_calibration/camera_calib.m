%% CAMERA CALIBRATION
clear all
close all 
clc

% add quaternion functions
addpath 'C:\Users\Matteo de Benedetti\Documents\ESA-Thesis\functions'


%% Read Files

% Read camera pose file
path = 'logs/20190925-1610';
[t, x, y, z, a, b, c, d]=textread(horzcat(path,'/camera_vicon_pose.txt'), ...
    '%d%*f%*f%*f%*f%*f%*f%*f%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
cam_pose = [t, x, y, z, a, b, c, d];

% Read exoter pose file
path = 'logs/20190925-1617';
[t, x, y, z, a, b, c, d]=textread(horzcat(path,'/exoter_vicon_pose.txt'), ...
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
% % print quat
% cam_pose_avg(5:8)
% exoter_pose_avg(5:8)

% convert quaternion to rpy
cam_rpy = [quaternion2roll(cam_pose_avg(5:8))
           quaternion2pitch(cam_pose_avg(5:8))
           quaternion2heading(cam_pose_avg(5:8))];
exoter_rpy = [quaternion2roll(exoter_pose_avg(5:8))
              quaternion2pitch(exoter_pose_avg(5:8))
              quaternion2heading(exoter_pose_avg(5:8))];       
      
% create transform from exoter body to camera
% pos = [x y z]
% orient = [z y x]
pos = cam_pose_avg(2:4) - exoter_pose_avg(2:4);
orient = cam_rpy - exoter_rpy;
