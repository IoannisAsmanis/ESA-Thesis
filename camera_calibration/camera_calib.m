%% CAMERA CALIBRATION

% Read camera pose file
path = 'logs/20190925-1610';
[t, x, y, z, a, b, c, d]=textread(horzcat(path,'/camera_vicon_pose.txt'), ...
    '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
cam_pose = [t, x, y, z, a, b, c, d];

% Read exoter pose file
path = 'logs/20190925-1617';
[t, x, y, z, a, b, c, d]=textread(horzcat(path,'/exoter_vicon_pose.txt'), ...
    '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
exoter_pose = [t, x, y, z, a, b, c, d];


%%








