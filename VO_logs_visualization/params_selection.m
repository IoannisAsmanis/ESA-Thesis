%% COMPARE MULTIPLE EXPERIMENTS
clear all
close all
% clc


%% OPEN FILES AND PROCESS DATA

path_ca = {
    'logs/20191017-1608', 
    'logs/20191017-1603', 
    'logs/20191017-1611', 
    'logs/20191017-1613',
    'logs/20191017-1624', 
    'logs/20191017-1629',     
    'logs/20191017-1621', 
    'logs/20191017-1618', 
    'logs/20191017-1642', 
    'logs/20191017-1632', 
    'logs/20191017-1645', 
    'logs/20191017-1648', 
    'logs/20191017-1658', 
    'logs/20191017-1636', 
    'logs/20191017-1654', 
    'logs/20191017-1651', 
    'logs/20191017-1704', 
    'logs/20191017-1707', 
    'logs/20191017-1713', 
    'logs/20191017-1710', 
    'logs/20191017-1718', 
    'logs/20191017-1720', 
    'logs/20191017-1715', 
    'logs/20191017-1724'}; 


%% READ AND PROCESS FILES

n_logs = size(path_ca,1);

legend_names = cell(1,n_logs);
for i = 1:n_logs
    legend_names{i} = horzcat('test ', num2str(i));
end

diff_pose_ca = cell(1,n_logs); 
for i=1:n_logs 
    % Read difference odometry/vicon file
    [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/diff_pose.txt'), ...
        '%d%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
    diff_pose = [t, x, y, z, a, b, c, d];

    % save result array
    results(i,:) = [i, norm([diff_pose(end,2) diff_pose(end,3)])];
    
    % save in cell array
    diff_pose_ca{i} = diff_pose; clear diff_pose;
end


%% DISPLAY RESULTS

results_sorted = sortrows(results,2);
disp(results_sorted(1,:));









