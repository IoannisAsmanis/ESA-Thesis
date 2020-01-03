%% COMPARE MULTIPLE EXPERIMENTS
% IMPORTANT: for reasons beyond magic, sometimes odom_world.txt contains an
% extra header line. either delete it manually, or change the headerlines
% param in textread from 2 to 3
% In general it is a good idea to quickly check that all the *.txt files have
% only 2 header lines, otherwise errors of dimentions mismatch may occur

% IMPORTANT: another fun thing that very rarely but indeed does happen is 
% that in the middle of the vicon.txt file there will be random lines of text instead of data, like:
% pocolog.rb[INFO]: loading file info from ./vicon.0.idx... 
% /vicon.pose_samples.time.microseconds /vicon.pose_samples.sourceFrame /vicon.pose_samples.targetFrame /vicon.pose_samples.position.data[0] /vicon.pose_samples.position.data[1] /vicon.pose_samples.position.data[2] /vicon.pose_samples.cov_position.data[0] /vicon.pose_samples.cov_position.data[1] /vicon.pose_samples.cov_position.data[2] /vicon.pose_samples.cov_position.data[3] /vicon.pose_samples.cov_position.data[4] /vicon.pose_samples.cov_position.data[5] /vicon.pose_samples.cov_position.data[6] /vicon.pose_samples.cov_position.data[7] /vicon.pose_samples.cov_position.data[8] /vicon.pose_samples.orientation.im[0] /vicon.pose_samples.orientation.im[1] /vicon.pose_samples.orientation.im[2] /vicon.pose_samples.orientation.re /vicon.pose_samples.cov_orientation.data[0] /vicon.pose_samples.cov_orientation.data[1] /vicon.pose_samples.cov_orientation.data[2] /vicon.pose_samples.cov_orientation.data[3] /vicon.pose_samples.cov_orientation.data[4] /vicon.pose_samples.cov_orientation.data[5] /vicon.pose_samples.cov_orientation.data[6] /vicon.pose_samples.cov_orientation.data[7] /vicon.pose_samples.cov_orientation.data[8] /vicon.pose_samples.velocity.data[0] /vicon.pose_samples.velocity.data[1] /vicon.pose_samples.velocity.data[2] /vicon.pose_samples.cov_velocity.data[0] /vicon.pose_samples.cov_velocity.data[1] /vicon.pose_samples.cov_velocity.data[2] /vicon.pose_samples.cov_velocity.data[3] /vicon.pose_samples.cov_velocity.data[4] /vicon.pose_samples.cov_velocity.data[5] /vicon.pose_samples.cov_velocity.data[6] /vicon.pose_samples.cov_velocity.data[7] /vicon.pose_samples.cov_velocity.data[8] /vicon.pose_samples.angular_velocity.data[0] /vicon.pose_samples.angular_velocity.data[1] /vicon.pose_samples.angular_velocity.data[2] /vicon.pose_samples.cov_angular_velocity.data[0] /vicon.pose_samples.cov_angular_velocity.data[1] /vicon.pose_samples.cov_angular_velocity.data[2] /vicon.pose_samples.cov_angular_velocity.data[3] /vicon.pose_samples.cov_angular_velocity.data[4] /vicon.pose_samples.cov_angular_velocity.data[5] /vicon.pose_samples.cov_angular_velocity.data[6] /vicon.pose_samples.cov_angular_velocity.data[7] /vicon.pose_samples.cov_angular_velocity.data[8]
% You will see an error like this: 
% Trouble reading unsigned integer from file (row 6724, field 1) ==>
% Go to the line (6754 in this case) and manually delete the rows


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
% path_ca = {'logs/20191115-1403/no_imu'};

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

% % investigating orientation problems on Spartan
% path_ca = {
%     'logs/20191118-1422/with_imu', % 
%     'logs/20191118-1427/with_imu'}; % 
% vicon_path_ca = 'logs/20191115-1335';

% % investigating orientation problems on Spartan
% path_ca = {
%     'logs/20191118-1422/with_imu', % 
%     'logs/20191119-1311/with_imu'}; % 
% vicon_path_ca = 'logs/20191115-1335';

% % comparing transforms AGAIN on 15-1335 after fixing orientation
% path_ca = {
%     'logs/20191118-1454/with_imu', % 
%     'logs/20191118-1457/with_imu', % 
%     'logs/20191118-1500/with_imu', % 
%     'logs/20191118-1504/with_imu', % 
%     'logs/20191118-1508/with_imu', % 
%     'logs/20191118-1512/with_imu', % 
%     'logs/20191118-1515/with_imu', % 
%     'logs/20191118-1603/with_imu', % 
%     'logs/20191118-1606/with_imu', % 
%     'logs/20191118-1609/with_imu'}; % 
% vicon_path = 'logs/20191115-1335'; %'logs/20191115-1124';

% validate the transform for 2019118-1335 on 20191118-1124
% path_ca = {
%     'logs/20191119-0955/with_imu', %120
%     'logs/20191119-0957/with_imu', %122
%     'logs/20191119-0947/with_imu'}; %121
% vicon_path = 'logs/20191115-1124';

% % fine tune 120:0.1:122 transforms on 15-1335 after fixing orientation
% path_ca = {
%     'logs/20191119-1027/with_imu', % 
%     'logs/20191119-1028/with_imu', % 
%     'logs/20191119-1032/with_imu', % 
%     'logs/20191119-1034/with_imu', % 
%     'logs/20191119-1036/with_imu', % 
%     'logs/20191119-1038/with_imu', % 
%     'logs/20191119-1041/with_imu', % 
%     'logs/20191119-1042/with_imu', % 
%     'logs/20191119-1044/with_imu'}; % 
% vicon_path = 'logs/20191115-1335'; %'logs/20191115-1124';

% % % single test
% path_ca = {'logs/20191119-1104/with_imu'};
% vicon_path = 'logs/20191119-1054'; %'logs/20191115-1124';

% % % single test
% path_ca = {'logs/20191115-1706/with_imu'};
% vicon_path_ca = 'logs/20191115-1335'; %'logs/20191115-1124';

% % % compare w/ or w/o imu on SpartanVO
% path_ca = {
%     'logs/20191119-1104/no_imu', % 
%     'logs/20191119-1104/with_imu'}; % 
% vicon_path = 'logs/20191119-1054'; %'logs/20191115-1124';

% % compare w/ or w/o imu on SpartanVO
% path_ca = {
%     'logs/20191119-1311/no_imu', % 
%     'logs/20191119-1311/with_imu'}; % 
% vicon_path = 'logs/20191115-1335'; %'logs/20191115-1124';

% % best transform wrt previous 119
% path_ca = {
%     'logs/20191119-1034/with_imu', % 
%     'logs/20191118-1512/with_imu'}; % 
% vicon_path_ca = {'logs/20191115-1335', 'logs/20191115-1335'}; %'logs/20191115-1124';

% % single test showing best transform
% path_ca = {'logs/20191119-1034/with_imu'};
% vicon_path = 'logs/20191115-1335'; %'logs/20191115-1124';

% % compare w/ or w/o imu on best transform
% path_ca = {
%     'logs/20191119-1034/no_imu', % 
%     'logs/20191119-1034/with_imu'}; % 
% vicon_path = 'logs/20191115-1335'; %'logs/20191115-1124';

% % compare w/ or w/o imu on SpartanVO on manual trajectory
% path_ca = {
%     'logs/20191119-1403/no_imu'}; % 
% %     'logs/20191119-1403/with_imu'}; % 
% vicon_path = 'logs/20191119-1359'; %'logs/20191115-1124';

% % % single test with spartan orientation to viso2_with_imu
% path_ca = {
%     'logs/20191119-1520/no_imu', % 
%     'logs/20191119-1520/with_imu'}; % 
% vicon_path = 'logs/20191115-1335'; %'logs/20191115-1124';

% % investigating IMU flipped problem
% path_ca = {
%     'logs/20191121-0928/with_imu'}; % 
% vicon_path = 'logs/20191120-1356'; %'logs/20191115-1124';

% % investigating IMU flipped problem
% path_ca = {
%     'logs/20191121-1624/no_imu'}; % 
% vicon_path = 'logs/20191121-1619'; %'logs/20191115-1124';

% % compare w/ or w/o imu on SpartanVO on 3m at 0.06m/s with new vicon
% path_ca = {
%     'logs/20191121-1718/no_imu', % 
%     'logs/20191121-1718/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715'}; %'logs/20191115-1124';

% % comparing transforms AGAIN on 21-1715 after fixing orientation
% path_ca = {
%     'logs/20191122-1115/with_imu', % 
%     'logs/20191122-1117/with_imu', % 
%     'logs/20191122-1119/with_imu', % 
% %     'logs/20191122-1121/with_imu', % 
%     'logs/20191122-1127/with_imu', % 
%     'logs/20191122-1129/with_imu', % 
%     'logs/20191122-1249/with_imu', % 
%     'logs/20191122-1250/with_imu'}; % 
% vicon_path = 'logs/20191121-1715'; %

% % comparing transforms AGAIN on 22-1319 after fixing orientation
% path_ca = {
%     'logs/20191122-1413/with_imu', % 
%     'logs/20191122-1415/with_imu', % 
%     'logs/20191122-1416/with_imu'}; % 
% vicon_path = 'logs/20191122-1319'; %

% % different velocities tests with the new vicon
% path_ca = {
%     'logs/20191122-1616/with_imu', % 
%     'logs/20191122-1625/with_imu', % 
%     'logs/20191122-1629/with_imu', % 
%     'logs/20191122-1637/with_imu', % 
%     'logs/20191122-1639/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191122-1521',
%     'logs/20191122-1540', %
%     'logs/20191122-1549', %
%     'logs/20191122-1557', %
%     'logs/20191122-1605'}; %

% % single test with best transform (120.8), before 0.1deg refining
% path_ca = {
%     'logs/20191122-1249/no_imu',
%     'logs/20191122-1249/with_imu'}; % 
% vicon_path_ca = 'logs/20191121-1715'; %'logs/20191115-1124';

% % single test with best transform (120.8), before 0.1deg refining
% path_ca = {
%     'logs/20191122-1629/no_imu',
%     'logs/20191122-1629/with_imu'}; % 
% vicon_path = 'logs/20191121-1549'; %'logs/20191115-1124';

% % finetuning transform pitch 120:0.2:122
% path_ca = {
% %     'logs/20191122-1641/with_imu', % 
% %     'logs/20191122-1704/with_imu', % 
% %     'logs/20191122-1706/with_imu', % 
% %     'logs/20191122-1709/with_imu', % 
% %     'logs/20191122-1713/with_imu', % 
%     'logs/20191122-1718/with_imu', % 
% %     'logs/20191122-1752/with_imu', % 
% %     'logs/20191122-1757/with_imu', % 
% %     'logs/20191122-1759/with_imu', % 
% %     'logs/20191122-1800/with_imu', % 
%     'logs/20191122-1801/with_imu', % 
% %     'logs/20191122-1804/with_imu', % 
% %     'logs/20191122-1808/with_imu', % 
%     'logs/20191122-1818/with_imu', % 
% %     'logs/20191122-1821/with_imu', % 
%     'logs/20191122-1824/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715'}; 

% % investigating yaw
% path_ca = {
%     'logs/20191125-1742/with_imu', % 
%     'logs/20191125-1737/with_imu', % 
%     'logs/20191126-1323/with_imu', % 
%     'logs/20191125-1739/with_imu', % 
%     'logs/20191125-1740/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715'}; 

% % investigating yaw
% path_ca = {
%     'logs/20191125-1737/with_imu', % 
%     'logs/20191126-1351/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715'}; 

% % % investigating roll
% path_ca = {
%     'logs/20191125-1749/with_imu', % 
%     'logs/20191126-1323/with_imu', % 
%     'logs/20191125-1750/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715'}; 
% 
% % % investigating x
% path_ca = {
%     'logs/20191125-1755/with_imu', % 
%     'logs/20191126-1323/with_imu', % 
%     'logs/20191125-1756/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715'}; 
% 
% % % investigating z
% path_ca = {
%     'logs/20191125-1758/with_imu', % 
%     'logs/20191126-1323/with_imu', % 
%     'logs/20191125-1800/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715'}; 

% % comparing pitch refinement
% path_ca = {
%     'logs/20191122-1713/with_imu', % old pitch (1641=120deg)
%     'logs/20191126-1323/with_imu'}; % new pitch
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715'};

% % % comparing old and new transform
% path_ca = {
%     'logs/20191108-1757', % old pitch (1641=120deg)
%     'logs/20191108-1806'}; % new pitch
% vicon_path_ca = {
%     'logs/20191108-1757',
%     'logs/20191108-1806'};

% % comparing old and new transform
% path_ca = {
%     'logs/20191126-1419/with_imu', % old
%     'logs/20191126-1323/with_imu', % new pitch
%     'logs/20191126-1358/with_imu'}; % new pitch, new yaw
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715'};

% % comparing old and new transform
% path_ca = {
%     'logs/20191126-1419/with_imu', % old
%     'logs/20191126-1515/with_imu'}; % new pitch, new yaw
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715'};

% % investigating pitch again
% path_ca = {
%     'logs/20191126-1419/with_imu', % 
%     'logs/20191126-1450/with_imu', % 
%     'logs/20191126-1452/with_imu', % 
%     'logs/20191126-1453/with_imu', % 
%     'logs/20191126-1455/with_imu', % 
%     'logs/20191126-1358/with_imu'}; % also .2deg on yaw
% vicon_path_ca = {
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715',
%     'logs/20191121-1715'}; 

% % experiments at different exposure times
% path_ca = {
%     'logs/20191122-1637/with_imu', %
% %     'logs/20191126-1729/with_imu', % 
%     'logs/20191126-1731/with_imu', % 
%     'logs/20191126-1735/with_imu', % 
%     'logs/20191126-1737/with_imu', % 
%     'logs/20191126-1739/with_imu', % 
%     'logs/20191126-1743/with_imu', % 
%     'logs/20191126-1746/with_imu'}; % 
% %     'logs/20191126-1748/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191122-1557',
% %     'logs/20191126-1623',
%     'logs/20191126-1633',
%     'logs/20191126-1638.1',
%     'logs/20191126-1646',
%     'logs/20191126-1651',
%     'logs/20191126-1657',
%     'logs/20191126-1702'};
% %     'logs/20191126-1707'}; 

% % autoexp/exp300 at 0.07 and 0.02m/s
% path_ca = {
%     'logs/20191122-1637/with_imu', % auto 0.07
% %     'logs/20191126-1729/with_imu', % 
%     'logs/20191126-1735/with_imu', % 300 0.07
%     'logs/20191128-1459/with_imu', % auto at 0.02
%     'logs/20191128-1526/with_imu'}; % 300 at 0.02
% %     'logs/20191126-1748/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191122-1557',
% %     'logs/20191126-1623',
%     'logs/20191126-1638.1',
%     'logs/20191128-1349',
%     'logs/20191128-1442'}; % 
% %     'logs/20191126-1707'}; 

% % look at vo computation time
% path_ca = {
%     'logs/20191127-1252/with_imu'}; %1629 %1055
% vicon_path_ca = {
%     'logs/20191127-1053'}; %1549


% % autoexp/exp300 at 0.07 and dark (1st on,2nd off)
% path_ca = {
%     'logs/20191128-1906.1/with_imu', % auto 0.07
%     'logs/20191128-1908/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191128-1809',
%     'logs/20191128-1801'}; 

% % autoexp/exp600 at 0.07 and dark (1st on,2nd off)
% path_ca = {
%     'logs/20191128-1906.1/with_imu', % auto 0.07
%     'logs/20191129-1042/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191128-1809',
%     'logs/20191129-1036'}; 

% % autoexp/exp300/exp600 at 0.02 and dark (1st on,2nd off)
% path_ca = {
%     'logs/20191129-1504/with_imu', % auto 0.07
%     'logs/20191129-1458/with_imu', % auto 0.07
%     'logs/20191129-1447/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191129-1437',
%     'logs/20191129-1421',
%     'logs/20191129-1411'}; 

% % 0.07m/s, 5m, fps=7.5-3.75
% path_ca = {
%     'logs/20191203-1254/with_imu', % 
%     'logs/20191203-1626/with_imu', % 
%     'logs/20191203-1640/with_imu'}; % 
% vicon_path_ca = {
%     'logs/20191203-1123',
%     'logs/20191203-1123',
%     'logs/20191203-1123'}; 

% % testing camera downsampling
% path_ca = {
%     'logs/20191204-1310/with_imu',
%     'logs/20191204-1420/with_imu',
%     'logs/20191204-1424/with_imu',
%     'logs/20191204-1348.1/with_imu'}; %
% vicon_path_ca = {
%     'logs/20191203-1123',
%     'logs/20191203-1123',
%     'logs/20191203-1123',
%     'logs/20191203-1123'}; 

% % different vo frequences at 0.07m/s
% path_ca = {
%     'logs/20191204-1626/with_imu',
%     'logs/20191204-1631/with_imu',
% %     'logs/20191204-1636/with_imu',
%     'logs/20191204-1640/with_imu',
% %     'logs/20191204-1748/with_imu',
%     'logs/20191204-1750/with_imu',
% %     'logs/20191204-1752/with_imu',
%     'logs/20191205-0951/with_imu',
% %     'logs/20191205-0954/with_imu',
%     'logs/20191205-0956/with_imu'}; %
% vicon_path_ca = {
%     'logs/20191204-1620',
%     'logs/20191204-1620',
%     'logs/20191204-1620',
%     'logs/20191204-1620',
%     'logs/20191204-1620',
%     'logs/20191204-1620',
%     'logs/20191204-1620',
%     'logs/20191204-1620',
%     'logs/20191204-1620',
%     'logs/20191204-1620'}; 

% % new stream aligner for vo_with_imu
path_ca = {
    'logs/20191205-1249/with_imu',
    'logs/20191205-1242/with_imu'}; %
vicon_path_ca = {
    'logs/20191204-1620',
    'logs/20191204-1620'}; 
legend_names_verbose = {
    'without stream aligner',
    'with stream aligner'};

% % new stream aligner for vo_evaluation
% path_ca = {
%     'logs/20191203-1254/with_imu',
%     'logs/20191205-1558/with_imu'}; %
% vicon_path_ca = {
%     'logs/20191203-1123',
%     'logs/20191203-1123'};
% legend_names_verbose = {
%     'without stream aligner',
%     'with stream aligner'};



% % different vo freq at 0.02m/s
% path_ca = {
%     'logs/20191206-1640/with_imu',
%     'logs/20191206-1650/with_imu',
%     'logs/20191206-1658/with_imu',
%     'logs/20191206-1704/with_imu',
%     'logs/20191206-1710/with_imu',
%     'logs/20191206-1717/with_imu'}; %
% vicon_path_ca = {
%     'logs/20191206-1045',
%     'logs/20191206-1045',
%     'logs/20191206-1045',
%     'logs/20191206-1045',
%     'logs/20191206-1045',
%     'logs/20191206-1045'}; 
% legend_names_verbose = {
%     'IFD = 0.03',
%     'IFD = 0.07',
%     'IFD = 0.14',
%     'IFD = 0.21',
%     'IFD = 0.28',
%     'IFD = 0.35'};

% % compare fast and slow with same period
% path_ca = {
%     'logs/20191206-1640/with_imu', % 0.02 at 0.4s
%     'logs/20191206-1650/with_imu', % 0.02 at 1s
%     'logs/20191204-1626/with_imu',% 0.07 at 0.4s
%     'logs/20191204-1631/with_imu'}; % 0.07 at 1s
% vicon_path_ca = {
%     'logs/20191206-1045',
%     'logs/20191206-1045',
%     'logs/20191204-1620',
%     'logs/20191204-1620'}; 

% % eval stream aligner
% path_ca = {
%     'logs/20191209-1428/with_imu', 
%     'logs/20191209-1446/with_imu'}; 
% vicon_path_ca = {
%     'logs/20191204-1620',
%     'logs/20191204-1620'}; 
% legend_names_verbose = {
%     'without stream aligner',
%     'with stream aligner'};


% % compare fast and slow with same ifd
% path_ca = {
%     'logs/20191209-1347', % 0.02 at IFD=0.03m
%     'logs/20191209-1409', % 0.07 at IFD=0.03m
% %     'logs/20191209-1353', % 0.02 at IFD=0.06m
% %     'logs/20191209-1412', % 0.07 at IFD=0.06m
%     'logs/20191209-1358', % 0.02 at IFD=0.1m
%     'logs/20191209-1418', % 0.07 at IFD=0.1m
%     'logs/20191209-1402', % 0.02 at IFD=0.2m
%     'logs/20191209-1424'}; % 0.07 at IFD=0.2m
% vicon_path_ca = {
%     'logs/20191206-1045',
%     'logs/20191204-1620',
% %     'logs/20191206-1045',
% %     'logs/20191204-1620',
%     'logs/20191206-1045',
%     'logs/20191204-1620',
%     'logs/20191206-1045',
%     'logs/20191204-1620'}; 
% legend_names_verbose = {
%     'fast with IFD=0.03',
%     'slow with IFD=0.03',
% %     'fast with IFD=0.06',
% %     'slow with IFD=0.06',
%     'fast with IFD=0.1',
%     'slow with IFD=0.1',
%     'fast with IFD=0.2',
%     'slow with IFD=0.2'};

% % compare fast and slow with same ifd
% path_ca = {
%     'logs/20191211-1524', % 0.02 at IFD=0.03m
%     'logs/20191210-1854', % 0.07 at IFD=0.03m
%     'logs/20191211-1803', % 0.02 at IFD=0.1m
%     'logs/20191210-1858', % 0.07 at IFD=0.1m
%     'logs/20191211-1809', % 0.02 at IFD=0.2m
%     'logs/20191210-1900'}; % 0.07 at IFD=0.2m
% vicon_path_ca = {
%     'logs/20191210-1806',
%     'logs/20191210-1827',
%     'logs/20191210-1806',
%     'logs/20191210-1827',
%     'logs/20191210-1806',
%     'logs/20191210-1827'}; 
% legend_names_verbose = {
%     'slow with IFD=0.03',
%     'fast with IFD=0.03',
% %     'fast with IFD=0.06',
% %     'slow with IFD=0.06',
%     'slow with IFD=0.1',
%     'fast with IFD=0.1',
%     'slow with IFD=0.2',
%     'fast with IFD=0.2'};

% % slow with varying ifd
% path_ca = {
% %     'logs/20191212-1051', 
%     'logs/20191211-1524', 
%     'logs/20191211-1758', 
%     'logs/20191211-1803', 
%     'logs/20191211-1809'};
% %     'logs/20191212-1043'};
% %     'logs/20191212-1100'}; 
% %     'logs/20191212-1106'}; 
% vicon_path_ca = {
%     'logs/20191210-1806',
%     'logs/20191210-1806',
% %     'logs/20191210-1806',
%     'logs/20191210-1806',
%     'logs/20191210-1806',
%     'logs/20191210-1806',
%     'logs/20191210-1806'}; 
% legend_names_verbose = {
% %     'IFD=0.01',
%     'IFD=0.03',
%     'IFD=0.06',
%     'IFD=0.1',
%     'IFD=0.2'};
% %     'IFD=0.3'};
% %     'IFD=0.5'};
% %     'IFD=0.75'};

% % fast with varying ifd
% path_ca = {
%     'logs/20191209-1409', 
%     'logs/20191212-1128', 
%     'logs/20191212-1130', 
%     'logs/20191212-1610'}; 
% %     'logs/20191212-1239', 
% %     'logs/20191212-1243'}; 
% %     'logs/20191212-1245'}; 
% %     'logs/20191212-1251'}; 
% vicon_path_ca = {
%     'logs/20191204-1620',
%     'logs/20191210-1827',
%     'logs/20191210-1827',
%     'logs/20191210-1827',
%     'logs/20191210-1827',
%     'logs/20191210-1827',
%     'logs/20191210-1827',
%     'logs/20191210-1827'}; 
% legend_names_verbose = {
%     'IFD=0.03',
%     'IFD=0.06',
%     'IFD=0.1',
%     'IFD=0.2'};
% %     'IFD=0.3',
% %     'IFD=0.5'};
% %     'IFD=0.75'};
% %     'IFD=0.1'};

% % ifd=0.03 fast vs slow
% path_ca = {
%     'logs/20191211-1524/', 
%     'logs/20191209-1409/'}; 
% vicon_path_ca = {
%     'logs/20191210-1806',
%     'logs/20191204-1620'}; 
% legend_names_verbose = {
%     'speed = 0.02 m/s',
%     'speed = 0.07 m/s'};

% % ifd=0.06 fast vs slow
% path_ca = {
%     'logs/20191211-1758/', 
%     'logs/20191212-1128/'}; 
% vicon_path_ca = {
%     'logs/20191210-1806',
%     'logs/20191210-1827'}; 
% legend_names_verbose = {
%     'speed = 0.02 m/s',
%     'speed = 0.07 m/s'};

% % ifd=0.1 fast vs slow
% path_ca = {
%     'logs/20191211-1803/', 
%     'logs/20191212-1130/'}; 
% vicon_path_ca = {
%     'logs/20191210-1806',
%     'logs/20191210-1827'}; 
% legend_names_verbose = {
%     'speed = 0.02 m/s',
%     'speed = 0.07 m/s'};

% % ifd=0.3 fast vs slow
% path_ca = {
%     'logs/20191212-1043/', 
%     'logs/20191212-1239/'}; 
% vicon_path_ca = {
%     'logs/20191210-1806',
%     'logs/20191210-1827'}; 
% legend_names_verbose = {
%     'speed = 0.02 m/s',
%     'speed = 0.07 m/s'};

% % % ifd=0.5 fast vs slow
% path_ca = {
%     'logs/20191212-1100/', 
%     'logs/20191212-1243/'}; 
% vicon_path_ca = {
%     'logs/20191210-1806',
%     'logs/20191210-1827'}; 
% legend_names_verbose = {
%     'speed = 0.02 m/s',
%     'speed = 0.07 m/s'};

% % ifd=0.75 fast vs slow
% path_ca = {
%     'logs/20191212-1106/', 
%     'logs/20191212-1245/'}; 
% vicon_path_ca = {
%     'logs/20191210-1806',
%     'logs/20191210-1827'}; 
% legend_names_verbose = {
%     'speed = 0.02 m/s',
%     'speed = 0.07 m/s'};

% % ifd=1 fast vs slow
% path_ca = {
%     'logs/20191212-1114/', 
%     'logs/20191212-1251/'}; 
% vicon_path_ca = {
%     'logs/20191210-1806',
%     'logs/20191210-1827'}; 
% legend_names_verbose = {
%     'speed = 0.02 m/s',
%     'speed = 0.07 m/s'};

% % test navcam fake
% path_ca = {
% %     'logs/20191212-1114/', 
%     'logs/20191212-1445/'}; 
% vicon_path_ca = {
% %     'logs/20191210-1806',
%     'logs/20191210-1806'}; 
% legend_names_verbose = {
% %     'speed = 0.02 m/s',
%     'speed = 0.07 m/s'};

% % test on the small rocks
% path_ca = {
% %     'logs/20191212-1114/', 
%     'logs/20191212-1644/'}; 
% vicon_path_ca = {
% %     'logs/20191210-1806',
%     'logs/20191212-1601'}; 
% legend_names_verbose = {
% %     'speed = 0.02 m/s',
%     'speed = 0.07 m/s'};

% % test accum distance fix
% path_ca = {
% %     'logs/20191212-1114/', 
%     'logs/20191213-1300/'}; 
% vicon_path_ca = {
% %     'logs/20191210-1806',
%     'logs/20191210-1827'}; 
% legend_names_verbose = {
% %     'speed = 0.02 m/s',
%     'speed = 0.07 m/s'};

% % test vo on the ptu
% path_ca = {
%     'logs/20191216-1403/'}; 
% vicon_path_ca = {
%     'logs/20191216-1051'}; 
% legend_names_verbose = {
%     'speed = 0.07 m/s'};

% % test vo on the ptu finally MAAAAYBE working
% path_ca = {
%     'logs/20191217-1656',
%     'logs/20191217-1740'}; 
% vicon_path_ca = {
%     'logs/20191217-1442',
%     'logs/20191217-1729'}; 
% legend_names_verbose = {
%     'speed = 0.07 m/s, pitch = 30 deg',
%     'speed = 0.07 m/s, pitch = 30 deg'}; % new transfor with 88 yaw and new sequence with camera stop

% % refining ptu transform - yaw
% path_ca = {
%     'logs/20191218-1011',
%     'logs/20191218-1004',
%     'logs/20191218-1014',
%     'logs/20191218-1006',
%     'logs/20191218-1012',
%     'logs/20191218-1008',
%     'logs/20191218-1010'}; 
% vicon_path_ca = {
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729'}; 
% legend_names_verbose = {
%     '-86',
%     '-88',
%     '-89',
%     '-90',
%     '-91',
%     '-92',
%     '-94'};

% % refining ptu transform - pitch
% path_ca = {
%     'logs/20191218-1255',
%     'logs/20191218-1258',
%     'logs/20191218-1302',
%     'logs/20191218-1306',
%     'logs/20191218-1012',
%     'logs/20191218-1309',
%     'logs/20191218-1310',
%     'logs/20191218-1311',
%     'logs/20191218-1315'}; 
% vicon_path_ca = {
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729'}; 
% legend_names_verbose = {
%     '-116',
%     '-118',
%     '-119',
%     '-120',
%     '-120.4',
%     '-121',
%     '-122',
%     '-123',
%     '-125'};

% % refining ptu transform - z
% path_ca = {
%     'logs/20191218-1414',
%     'logs/20191218-1416',
%     'logs/20191218-1012',
%     'logs/20191218-1420',
%     'logs/20191218-1423', 
%     'logs/20191218-1428'}; 
% vicon_path_ca = {
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729'}; 
% legend_names_verbose = {
%     '0.5',
%     '0.6',
%     '0.63',
%     '0.65',
%     '0.75',
%     '0.85'};

% % refining ptu transform - x
% path_ca = {
%     'logs/20191218-1336',
%     'logs/20191218-1351',
%     'logs/20191218-1012',
%     'logs/20191218-1409',
%     'logs/20191218-1411'}; 
% vicon_path_ca = {
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729',
%     'logs/20191217-1729'}; 
% legend_names_verbose = {
%     '0.1',
%     '0.11',
%     '0.1124',
%     '0.115',
%     '0.125'};

% % navcam vo initial vs refined transform 
% path_ca = {
%     'logs/20191218-1006',
%     'logs/20191218-1012'}; 
% vicon_path_ca = {
%     'logs/20191217-1729',
%     'logs/20191217-1729'}; 
% legend_names_verbose = {
%     'initial',
%     'refined'}; % new transfor with 88 yaw and new sequence with camera stop

% % direct comparison navcam loccam, IDF=0.11, IOP=86%
% path_ca = {
%     'logs/20191212-1130',
%     'logs/20191219-1354'}; 
% vicon_path_ca = {
%     'logs/20191210-1827',
%     'logs/20191218-1542'}; 
% legend_names_verbose = {
%     'loccam',
%     'navcam'}; % new transfor with 88 yaw and new sequence with camera stop

% % direct comparison navcam loccam, IDF=0.3, IOP=71%
% path_ca = {
%     'logs/20191212-1239',
%     'logs/20191219-1344'}; 
% vicon_path_ca = {
%     'logs/20191210-1827',
%     'logs/20191219-1252'}; 
% legend_names_verbose = {
%     'loccam',
%     'navcam'}; % new transfor with 88 yaw and new sequence with camera stop

% % refining ptu transform 1536 - pitch
% path_ca = {
%     'logs/20191218-1732',
%     'logs/20191218-1735',
% %     'logs/20191218-1701',
%     'logs/20191218-1738',
%     'logs/20191218-1742'}; 
% vicon_path_ca = {
%     'logs/20191218-1536',
%     'logs/20191218-1536',
% %     'logs/20191218-1536',
%     'logs/20191218-1536',
%     'logs/20191218-1536'}; 
% legend_names_verbose = {
%     '-128',
%     '-127',
% %     '-126.4',
%     '-126',
%     '-125'};

% % refining ptu transform 1542 - pitch
% path_ca = {
%     'logs/20191218-1901',
%     'logs/20191218-1903',
%     'logs/20191218-1905',
%     'logs/20191218-1907',
%     'logs/20191218-1908'}; 
% vicon_path_ca = {
%     'logs/20191218-1542',
%     'logs/20191218-1542',
%     'logs/20191218-1542',
%     'logs/20191218-1542',
%     'logs/20191218-1542'}; 
% legend_names_verbose = {
%     '-126',
%     '-127',
%     '-127.7',
%     '-128.5',
%     '-129.5'};

% % refining ptu transform 1542 - yaw
% path_ca = {
%     'logs/20191218-1915',
%     'logs/20191218-1917',
%     'logs/20191218-1907',
%     'logs/20191218-1919',
%     'logs/20191218-1921'}; 
% vicon_path_ca = {
%     'logs/20191218-1542',
%     'logs/20191218-1542',
%     'logs/20191218-1542',
%     'logs/20191218-1542',
%     'logs/20191218-1542'}; 
% legend_names_verbose = {
%     '-88',
%     '-90',
%     '-91',
%     '-92',
%     '-94'};

% % direct comparison navcam loccam but different IOP
% path_ca = {
%     'logs/20191218-1820',
%     'logs/20191218-1012'}; 
% vicon_path_ca = {
%     'logs/20191218-1816',
%     'logs/20191217-1729'}; 
% legend_names_verbose = {
%     'loccam',
%     'navcam'}; 

% % refining ptu transform 1524 - yaw
% path_ca = {
%     'logs/20191219-1010',
%     'logs/20191219-1012',
%     'logs/20191219-1005',
%     'logs/20191219-1022',
%     'logs/20191219-1024'}; 
% vicon_path_ca = {
%     'logs/20191218-1524',
%     'logs/20191218-1524',
%     'logs/20191218-1524',
%     'logs/20191218-1524',
%     'logs/20191218-1524'}; 
% legend_names_verbose = {
%     '-88',
%     '-90',
%     '-91',
%     '-92',
%     '-94'};

% % refining ptu transform 1524 - yaw
% path_ca = {
%     'logs/20191219-1047',
%     'logs/20191219-1059',
%     'logs/20191219-1101',
%     'logs/20191219-1005',
%     'logs/20191219-1104',
%     'logs/20191219-1106',
%     'logs/20191219-1109'}; 
% vicon_path_ca = {
%     'logs/20191218-1524',
%     'logs/20191218-1524',
%     'logs/20191218-1524',
%     'logs/20191218-1524',
%     'logs/20191218-1524',
%     'logs/20191218-1524',
%     'logs/20191218-1524'}; 
% legend_names_verbose = {
%     '-118',
%     '-119',
%     '-120',
%     '-120.4',
%     '-121',
%     '-122',
%     '-123'};

% % tests at different pitches, period=0s
% path_ca = {
%     'logs/20191219-1441',
%     'logs/20191219-1443',
%     'logs/20191204-1626/with_imu',
%     'logs/20191219-1446',
%     'logs/20191219-1448'};
% %     'logs/20191219-1450'}; 
% vicon_path_ca = {
%     'logs/20191218-1531',
%     'logs/20191218-1524',
%     'logs/20191204-1620',
%     'logs/20191218-1548',
%     'logs/20191218-1554'};
% %     'logs/20191218-1559'}; 
% legend_names_verbose = {
%     'navcam 20',
%     'navcam 30',
%     'loccam 30',
%     'navcam 40',
%     'navcam 50'};
% %     'navcam 60'};

% % tests at different pitches, period=1s
% path_ca = {
%     'logs/20191219-1547',
%     'logs/20191219-1549',
%     'logs/20191204-1631/with_imu',
%     'logs/20191219-1556',
%     'logs/20191219-1559'};
% %     'logs/20191219-1622'}; 
% vicon_path_ca = {
%     'logs/20191218-1531',
%     'logs/20191218-1524',
%     'logs/20191204-1620',
%     'logs/20191218-1548',
%     'logs/20191218-1554'};
% %     'logs/20191218-1559'}; 
% legend_names_verbose = {
%     'navcam 20',
%     'navcam 30',
%     'loccam 30',
%     'navcam 40',
%     'navcam 50'};
% %     'navcam 60'};

% % direct comparison navcam loccam, IDF=0.1, IOP=93%
% path_ca = {
%     'logs/20191212-1130',
%     'logs/20191220-1344'}; 
% vicon_path_ca = {
%     'logs/20191210-1827',
%     'logs/20191218-1542'}; 
% legend_names_verbose = {
%     'loccam',
%     'navcam'}; % new transfor with 88 yaw and new sequence with camera stop

% % direct comparison navcam loccam, IDF=0.3, IOP=85%
% path_ca = {
%     'logs/20191212-1239',
%     'logs/20191220-1342'}; 
% vicon_path_ca = {
%     'logs/20191210-1827',
%     'logs/20191218-1542'}; 
% legend_names_verbose = {
%     'loccam',
%     'navcam'}; % new transfor with 88 yaw and new sequence with camera stop


% % direct comparison navcam loccam, IOP=85%
% path_ca = {
%     'logs/20191212-1239',
%     'logs/20191220-1658'}; 
% vicon_path_ca = {
%     'logs/20191210-1827',
%     'logs/20191218-1524'}; 
% legend_names_verbose = {
%     'loccam',
%     'navcam'}; 

% % direct comparison navcam loccam, IOP=95%
% path_ca = {
%     'logs/20191212-1130',
%     'logs/20191220-1656'}; 
% vicon_path_ca = {
%     'logs/20191210-1827',
%     'logs/20191218-1524'}; 
% legend_names_verbose = {
%     'loccam',
%     'navcam'}; 

% % tests at different pitches, period=1s
% path_ca = {
%     'logs/20191220-1700.1',
%     'logs/20191220-1706',
%     'logs/20191204-1631/with_imu',
%     'logs/20191220-1709',
%     'logs/20191220-1711'};
% vicon_path_ca = {
%     'logs/20191218-1531',
%     'logs/20191218-1524',
%     'logs/20191204-1620',
%     'logs/20191218-1548',
%     'logs/20191218-1554'};
% legend_names_verbose = {
%     'navcam 20',
%     'navcam 30',
%     'loccam 30',
%     'navcam 40',
%     'navcam 50'};

% % good sequence 0.07 m/s
% path_ca = {
%     'logs/20191212-1128'}; 
% vicon_path_ca = {
%     'logs/20191210-1827'}; 
% legend_names_verbose = {
%     'VO estimate'}; 

% set true if also other files are provided in the log folder
CONTROL_FILE = false; control_path = '';
IMU_FILE = false; imu_path = '';
ODOM_TIME = true; % set false if vicon and odom have no timestamp
VICON_FILE = true; 
VICON_FILE_RPY = true; %new vicon output with also hdg, roll, pitch
ODOM_FILE_RPY = true; %new odom fole with also hdg, roll, pitch
LEGEND_NAMES_VERBOSE = true; 


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
        [t, x, y, z, b, c, d, a]=textread(horzcat(vicon_path_ca{i},'/vicon.txt'), ... %path_ca{i},'/vicon.txt'), ...
            '%u%*f%*f%*f%*f%*f%*f%*f%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        vicon_pose = [t/10^6, x, y, z, a, b, c, d];
    else
        vicon_path_ca{i} = path_ca{i};
        % read gt pose file
        [t, x, y, z, b, c, d, a]=textread(horzcat(path_ca{i},'/gt_pose.txt'), ...
            '%u%*f%*f%*f%*f%*f%*f%*f%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        %         '%u%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f%*f%f%f%f%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        vicon_pose = [t/10^6, x, y, z, a, b, c, d];
        vicon_pose(:,9) = quaternion2heading(vicon_pose(:,5:8));
        vicon_pose(:,10) = quaternion2pitch(vicon_pose(:,5:8));
        vicon_pose(:,11) = quaternion2roll(vicon_pose(:,5:8));
    end
    
    if (ODOM_FILE_RPY)
        hdg =  textread(horzcat(path_ca{i},'/odom_heading.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        pitch =  textread(horzcat(path_ca{i},'/odom_pitch.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        roll =  textread(horzcat(path_ca{i},'/odom_roll.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        odom_pose(:,9:11) = [hdg, pitch, roll];
    end
    
    if (VICON_FILE_RPY)
        hdg =  textread(horzcat(vicon_path_ca{i},'/vicon_heading.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        pitch =  textread(horzcat(vicon_path_ca{i},'/vicon_pitch.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
        roll =  textread(horzcat(vicon_path_ca{i},'/vicon_roll.txt'), '%f%*[^\n]', 'headerlines', 2, 'delimiter', '\t');
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
%     dist_accum = zeros(size(gt_pose,1),1);
%     for j = 2:size(gt_pose,1)
%         dist = norm(gt_pose(j,2:4) - gt_pose(j-1,2:4));
%         dist_accum(j) = dist + dist_accum(j-1);     
%         %dist_accum(j) = norm(gt_pose(j,2:4) - gt_pose(1,2:4));
%     end
    dist_accum = zeros(size(vicon_pose,1),2);
    k=2;
    for j = 2:100:size(vicon_pose,1)
        dist = norm(vicon_pose(j,2:4) - vicon_pose(j-1,2:4));
        dist_accum(k,2) = dist + dist_accum(k-1,2); 
        dist_accum(k,1) = vicon_pose(j,1);
        k=k+1;
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

close all

legend_names_2pdt = cell(1,n_logs);
for i = 1:n_logs
    legend_names_2pdt{(i-1)+i} = horzcat('test ', num2str(i));
    legend_names_2pdt{(i-1)+i+1} = horzcat('test ', num2str(i), ', 2% distance traveled');
end

legend_names_gtvsodo = cell(1,n_logs);
for i = 1:n_logs
    legend_names_gtvsodo{(i-1)+i} = horzcat('test ', num2str(i), ' GT');
    legend_names_gtvsodo{(i-1)+i+1} = horzcat('test ', num2str(i), ' Odom');
end

legend_names_and2percent = cell(1,n_logs);
for i = 1:n_logs
    legend_names_and2percent{i} = horzcat('test ', num2str(i));
end
legend_names_and2percent{i+1} = '2% distance travelled';

if(LEGEND_NAMES_VERBOSE)
    legend_names_verbose_and2percent = legend_names_verbose;
    legend_names_verbose_and2percent{i+1} = '2% distance travelled';
    
    legend_names = legend_names_verbose;
    legend_names_and2percent = legend_names_verbose_and2percent;
end

% % remove by hand stuff over tot indexes
% tot=20;
% for i = 1:n_logs
%     dist_accum_ca{i} = dist_accum_ca{i}(1:tot);
%     diff_pose_ca{i} = diff_pose_ca{i}(1:tot,:);
%     diff_norm_xyz_ca{i} = diff_norm_xyz_ca{i}(1:tot);
% end

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


% % xyz error norm over distance travelled vs 2% error
% figure(109);
% hold on
% for i=1:n_logs
%     plot(dist_accum_ca{i}, diff_norm_xyz_ca{i});
%     grid on;
%     xlabel('distance travelled [m]'), ylabel('xyz error [m]')
% end
% plot(dist_accum_ca{i}, dist_accum_ca{i}*0.02, 'r--')
% title({'Visual Odometry Evaluation', 'xyz error norm over travelled distance'});
% legend_names_t = [legend_names(:)', {'2% distance traveled'}]; legend(legend_names_t)
% hold off


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


% % xyz error norm over time vs 2% error
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
figure(104);
hold on
for i=1:n_logs
    plot(gt_pose_ca{i}(:,2), gt_pose_ca{i}(:,3));
    xlabel('x [m]'), ylabel('y [m]')
end
title({'Visual Odometry Evaluation', 'ground truth trajectory'});
grid on, %axis equal; 
legend(legend_names);
hold off


% % ground truth trajectory vs VO estimate on xy plane
figure(122), close(122), figure(122);
hold on
for i=1:n_logs
    plot(vicon_pose_ca{i}(:,2), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,2), odom_pose_ca{i}(:,3), '-*');
    xlabel('x [m]'), ylabel('y [m]')
end
title({'Visual Odometry Evaluation', 'ground truth trajectory'});
grid on, %axis equal; 
legend('Ground Truth', 'VO estimate'); 
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


% % x y z error components over time
% figure(106); close(106); figure(106);
% comp = {'X', 'Y', 'Z', 'XY'};
% for j = 1:3
%     subplot(2,2,j);
%     hold on;
%     for i=1:n_logs
%         plot(diff_pose_ca{i}(:,1), diff_pose_ca{i}(:,j+1));
%     end
%     legend(legend_names);
%     grid on, xlabel('time [s]'), ylabel('error [m]'), title(horzcat('Visual Odometry Evaluation - ', comp{j}, ' error over Time'));
%     hold off;
% end
% subplot(2,2,4);
% hold on;
% for i=1:n_logs
%     plot(diff_pose_ca{i}(:,1), diff_norm_xy_ca{i});
% end
% legend(legend_names);
% grid on, xlabel('time [s]'), ylabel('error [m]'), title(horzcat('Visual Odometry Evaluation - XY error norm over Time'));
% hold off;


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


% % heading error over distance traveled
% figure(110);
% hold on;
% for i=1:n_logs
%     plot(dist_accum_ca{i}(:,1), abs(rad2deg(diff_pose_ca{i}(:,9))));
%     grid on; xlabel('distance traveled [m]'), ylabel('angle [deg]');
%     title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'heading error over distance traveled'});
% end
% legend(legend_names);
% hold off;


% heading, pitch, roll error of the IMU over time
% if (IMU_FILE)
%     figure(112);
%     hold on;
%     for i=1:n_logs
%         %interpolate gt_pose to fill all the idx of imu
%         gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,9),imu_ca{i}(:,1),'pchip');
%         hdg_err_imu = gt_pose_interp - imu_ca{i}(:,6);
%         
%         %interpolate gt_pose to fill all the idx of imu
%         gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,10),imu_ca{i}(:,1),'pchip');
%         pitch_err_imu = gt_pose_interp - imu_ca{i}(:,7);
%         
%         %interpolate gt_pose to fill all the idx of imu
%         gt_pose_interp = interp1(gt_pose_ca{i}(:,1),gt_pose_ca{i}(:,11),imu_ca{i}(:,1),'pchip');
%         roll_err_imu = gt_pose_interp - imu_ca{i}(:,8);
%         
%         plot(imu_ca{i}(:,1), abs(rad2deg(hdg_err_imu)), imu_ca{i}(:,1), abs(rad2deg(pitch_err_imu)), imu_ca{i}(:,1), abs(rad2deg(roll_err_imu)));
%         grid on; ylabel('Orientation error [deg]'), xlabel('time [s]');
%         title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'orientation error over time'});
%         legend('heading error', 'pitch error', 'roll error');
%     end
%     % legend(legend_names);
%     hold off;
% end

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

% % evaluation of the interpolated vicon to solve the initial/final error
% if (VICON_FILE)
%     figure(114), close(114), figure(114);
%     subplot(3,1,1)
%     hold on;
%     for i=1:n_logs
%         %interpolate gt_pose to fill all the idx of odo_pose
%         [unique_vicon_times{i}, unique_idx] = unique(vicon_pose_ca{i}(:,1));
%         vicon_pose_interp_ca{i} = interp1(unique_vicon_times{i}, vicon_pose_ca{i}(unique_idx,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         
%         plot(odom_pose_ca{i}(:,1), vicon_pose_interp_ca{i} - odom_pose_ca{i}(:,2), ...
%             diff_pose_ca{i}(:,1), diff_pose_ca{i}(:,2));
%         grid on; ylabel('X error [m]'), xlabel('time [s]');
%         title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'x error over time'});
%     end
%     legend('diff pose interp', 'diff pose original') %legend(legend_names);
%     hold off;
%     
%     subplot(3,1,2)
%     hold on;
%     for i=1:n_logs
%         plot(gt_pose_ca{i}(:,1), gt_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), vicon_pose_interp_ca{i})
%         title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'GT POSE vs GT POSE INTERP over time'});
%         ylabel('x [m]'), xlabel('time [s]'), grid on
%     end
%     legend('GT pose', 'GT pose interp')
%     hold off
%     
%     subplot(3,1,3)
%     hold on;
%     for i=1:n_logs
%         plot(odom_pose_ca{i}(:,1), odom_pose_ca{i}(:,2), '-*')
%         title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'odom pose over time'});
%         ylabel('x [m]'), xlabel('time [s]'), grid on
%     end
%     legend('odom pose')
%     hold off
% end


% new xyz error norm from vicon and odom interp and synchronized over time
if (VICON_FILE)
    figure(115), close(115), figure(115);
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
        [unique_vicon_times{i}, unique_idx] = unique(vicon_pose_ca{i}(:,1));
        vicon_pose_interp_ca{i}(:,2) = interp1(unique_vicon_times{i}, vicon_pose_ca{i}(unique_idx,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,3) = interp1(unique_vicon_times{i}, vicon_pose_ca{i}(unique_idx,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,4) = interp1(unique_vicon_times{i}, vicon_pose_ca{i}(unique_idx,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        for j = 1:size(odom_pose_ca{i}(:,1),1)
            xyz_norm{i}(j) = norm([vicon_pose_interp_ca{i}(j,2) - odom_pose_ca{i}(j,2), ...
                         vicon_pose_interp_ca{i}(j,3) - odom_pose_ca{i}(j,3), ...
                         vicon_pose_interp_ca{i}(j,4) - odom_pose_ca{i}(j,4)]);
        end
        plot(odom_pose_ca{i}(:,1), xyz_norm{i});
        grid on; ylabel('X error [m]'), xlabel('time [s]');
        title({'Visual Odometry Evaluation - ', 'xyz error norm over time'});
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
        [unique_vicon_times{i}, unique_idx] = unique(vicon_pose_ca{i}(:,1)); 
        vicon_pose_interp_ca{i}(:,2) = interp1(unique_vicon_times{i}, vicon_pose_ca{i}(unique_idx,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,3) = interp1(unique_vicon_times{i}, vicon_pose_ca{i}(unique_idx,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,4) = interp1(unique_vicon_times{i}, vicon_pose_ca{i}(unique_idx,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        for j = 1:size(odom_pose_ca{i}(:,1),1)
            xyz_norm{i}(j,1) = norm([vicon_pose_interp_ca{i}(j,2) - odom_pose_ca{i}(j,2), ...
                         vicon_pose_interp_ca{i}(j,3) - odom_pose_ca{i}(j,3), ... 
                         vicon_pose_interp_ca{i}(j,4) - odom_pose_ca{i}(j,4)]);
        end
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        dist_accum_ca{i}(1) = norm(vicon_pose_interp_ca{i}(1,2:4) - vicon_pose_ca{i}(1,2:4));
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        
        %dist_accum_interp_ca{i}(:,1) = odom_pose_ca{i}(:,1);
        %dist_accum_interp_ca{i}(:,2) = interp1(unique_vicon_times{i}, dist_accum_ca{i}(unique_idx,2), odom_pose_ca{i}(:,1), 'pchip');
        
        plot([0.23; dist_accum_ca{i}(:,1)], [0.02; xyz_norm{i}(:,1)], '-*');
        grid on; ylabel('XYZ error norm [m]'), xlabel('Distance traveled [m]');
        title({'Visual Odometry Evaluation - ', 'xyz error norm over distance'});
    end
    plot([0; dist_accum_ca{i}(:,1)], [0; 0.02*dist_accum_ca{i}(:,1)], 'r--')
    %legend(legend_names_2pdt);
    legend(legend_names_and2percent)
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
%         [unique_vicon_times{i}, unique_idx] = unique(vicon_pose_ca{i}(:,1));
%         vicon_pose_interp_ca{i}(:,2) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,3) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,4) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
        dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
        dist_accum_ca{i}(1) = norm(vicon_pose_interp_ca{i}(1,2:4) - vicon_pose_ca{i}(1,2:4));
        for j = 2:size(odom_pose_ca{i}(:,1),1)
            dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
            dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
        end
        
        plot(dist_accum_ca{i}(:,1), vicon_pose_interp_ca{i}(:,2) - odom_pose_ca{i}(:,2), '-*');
        grid on; ylabel('X error [m]'), xlabel('Distance traveled [m]');
        title({'Visual Odometry Evaluation - ', 'x error component over distance'});
    end
    plot(dist_accum_ca{1}(:,1), 0.02*dist_accum_ca{1}(:,1), 'r--')
    legend(legend_names_and2percent);
    hold off;
    
    subplot(2,2,2)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
%         vicon_pose_interp_ca{i}(:,2) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,3) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,4) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
%         % distance travelled from start at each t step
%         dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
%         for j = 2:size(odom_pose_ca{i}(:,1),1)
%             dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
%             dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
%         end
        
        plot(dist_accum_ca{i}(:,1), vicon_pose_interp_ca{i}(:,3) - odom_pose_ca{i}(:,3), '-*');
        grid on; ylabel('Y error [m]'), xlabel('Distance traveled [m]');
        title({'Visual Odometry Evaluation - ', 'y error component over distance'});
    end
    plot(dist_accum_ca{1}(:,1), 0.02*dist_accum_ca{1}(:,1), 'r--')
    legend(legend_names_and2percent);
    hold off;
    
    subplot(2,2,3)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
%         vicon_pose_interp_ca{i}(:,2) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,3) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,4) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
%         dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
%         for j = 2:size(odom_pose_ca{i}(:,1),1)
%             dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
%             dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
%         end
        
        plot(dist_accum_ca{i}(:,1), vicon_pose_interp_ca{i}(:,4) - odom_pose_ca{i}(:,4), '-*');
        grid on; ylabel('Z error [m]'), xlabel('Distance traveled [m]');
        title({'Visual Odometry Evaluation - ', 'z error component over distance'});
    end
    plot(dist_accum_ca{1}(:,1), 0.02*dist_accum_ca{1}(:,1), 'r--')
    legend(legend_names_and2percent);    hold off;
    
    subplot(2,2,4)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
%         vicon_pose_interp_ca{i}(:,2) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,2), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,3) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,3), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,4) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,4), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        for j = 1:size(odom_pose_ca{i}(:,1),1)
            xyz_norm{i}(j,1) = norm([vicon_pose_interp_ca{i}(j,2) - odom_pose_ca{i}(j,2), ...
                         vicon_pose_interp_ca{i}(j,3) - odom_pose_ca{i}(j,3), ... 
                         vicon_pose_interp_ca{i}(j,4) - odom_pose_ca{i}(j,4)]);
        end
        
        % distance travelled from start at each t step
%         dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
%         for j = 2:size(odom_pose_ca{i}(:,1),1)
%             dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
%             dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
%         end
        
        plot(dist_accum_ca{i}(:,1), xyz_norm{i}(:,1), '-*');
        grid on; ylabel('XYZ error norm [m]'), xlabel('Distance traveled [m]');
        title({'Visual Odometry Evaluation - ', 'xyz error norm over distance'});
    end
    plot(dist_accum_ca{1}(:,1), 0.02*dist_accum_ca{1}(:,1), 'r--')
    legend(legend_names_and2percent);
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
        [unique_vicon_times{i}, unique_idx] = unique(vicon_pose_ca{i}(:,1));
        vicon_pose_interp_ca{i}(:,9) = interp1(unique_vicon_times{i}, vicon_pose_ca{i}(unique_idx,9), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,10) = interp1(unique_vicon_times{i}, vicon_pose_ca{i}(unique_idx,10), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        vicon_pose_interp_ca{i}(:,11) = interp1(unique_vicon_times{i}, vicon_pose_ca{i}(unique_idx,11), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
%         dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
%         for j = 2:size(odom_pose_ca{i}(:,1),1)
%             dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
%             dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
%         end
        
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,9) - odom_pose_ca{i}(:,9)), '-*');
        grid on; ylabel('heading error [deg]'), xlabel('Distance traveled [m]');
        title({'Visual Odometry Evaluation - ', 'heading error component over distance'});
    end
    legend(legend_names);
    hold off;
    
    subplot(2,2,2)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
%         vicon_pose_interp_ca{i}(:,9) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,9), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,10) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,10), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,11) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,11), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
%         dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
%         for j = 2:size(odom_pose_ca{i}(:,1),1)
%             dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
%             dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
%         end
        
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,10) - odom_pose_ca{i}(:,10)), '-*');
        grid on; ylabel('pitch error [deg]'), xlabel('Distance traveled [m]');
        title({'Visual Odometry Evaluation - ', 'pitch error component over distance'});
    end
    legend(legend_names);
    hold off;
    
    subplot(2,2,3)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
%         vicon_pose_interp_ca{i}(:,9) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,9), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,10) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,10), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,11) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,11), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % distance travelled from start at each t step
%         dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
%         for j = 2:size(odom_pose_ca{i}(:,1),1)
%             dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
%             dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
%         end
        
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,11) - odom_pose_ca{i}(:,11)), '-*');
        grid on; ylabel('roll error [deg]'), xlabel('Distance traveled [m]');
        title({'Visual Odometry Evaluation - ', 'roll error component over distance'});
    end
    legend(legend_names);
    hold off;
    
    subplot(2,2,4)
    hold on;
    for i=1:n_logs
        %interpolate gt_pose to fill all the idx of odo_pose
%         vicon_pose_interp_ca{i}(:,9) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,9), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,10) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,10), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
%         vicon_pose_interp_ca{i}(:,11) = interp1(vicon_pose_ca{i}(:,1), vicon_pose_ca{i}(:,11), odom_pose_ca{i}(:,1), 'pchip'); %'pchip');
        
        % compute norm of rpy error
        for j = 1:size(odom_pose_ca{i}(:,1),1)
            rpy_norm{i}(j,1) = norm([vicon_pose_interp_ca{i}(j,9) - odom_pose_ca{i}(j,9), ...
                         vicon_pose_interp_ca{i}(j,10) - odom_pose_ca{i}(j,10), ... 
                         vicon_pose_interp_ca{i}(j,11) - odom_pose_ca{i}(j,11)]);
        end
        
        % distance travelled from start at each t step
%         dist_accum_ca{i} = zeros(size(odom_pose_ca{i}(:,1),1),1);
%         for j = 2:size(odom_pose_ca{i}(:,1),1)
%             dist = norm(vicon_pose_interp_ca{i}(j,2:4) - vicon_pose_interp_ca{i}(j-1,2:4));
%             dist_accum_ca{i}(j,1) = dist + dist_accum_ca{i}(j-1,1);
%         end
        
        plot(dist_accum_ca{i}(:,1), rpy_norm{i}(:,1), '-*');
        grid on; ylabel('rpy error norm [deg]'), xlabel('Distance traveled [m]');
        title({'Visual Odometry Evaluation - ', 'rpy error norm over distance'});
    end
    legend(legend_names);
    hold off;
end


% RPY gt vs RPY odom estimate over distance
if(VICON_FILE)
    figure(119), close(119), figure(119)
    
    legend_names_2pdt = cell(1,n_logs);
    for i = 1:n_logs
        legend_names_2pdt{(i-1)+i} = horzcat('test ', num2str(i), ' GT');
        legend_names_2pdt{(i-1)+i+1} = horzcat('test ', num2str(i), ' Odom');
    end
    
    % START: sneacky tryck, comment it out
%     odom_pose_ca{i}(:,10) = odom_pose_ca{i}(:,10) + vicon_pose_interp_ca{i}(1,10);
%     odom_pose_ca{i}(:,11) = odom_pose_ca{i}(:,11) + vicon_pose_interp_ca{i}(1,11);
    % END: sneacky tryck, comment it out

    for i = 1:n_logs
        subplot(2,2,1)
        hold on
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,9)), dist_accum_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,9)), '-*')
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Heading GT vs Heading Odom over time'})
        legend(legend_names_2pdt), ylabel('angle [deg]'), xlabel('distance traveled [m]')
        hold off
        
        subplot(2,2,2)
        hold on
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,10)), dist_accum_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,10)), '-*')
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Pitch GT vs Pitch Odom over time'})
        legend(legend_names_2pdt), ylabel('angle [deg]'), xlabel('distance traveled [m]')
        hold off
        
        subplot(2,2,3)
        hold on
        plot(dist_accum_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,11)), dist_accum_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,11)), '-*')
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Roll GT vs Roll Odomover time'})
        legend(legend_names_2pdt), ylabel('angle [deg]'), xlabel('distance traveled [m]')
        hold off
    end
end


% RPY gt vs RPY odom estimate over time
if(VICON_FILE)
    figure(120), close(120), figure(120)
    
    legend_names_2pdt = cell(1,n_logs);
    for i = 1:n_logs
        legend_names_2pdt{(i-1)+i} = horzcat('test ', num2str(i), ' GT');
        legend_names_2pdt{(i-1)+i+1} = horzcat('test ', num2str(i), ' Odom');
    end
    
    % START: sneacky tryck, comment it out
%     odom_pose_ca{i}(:,10) = odom_pose_ca{i}(:,10) + vicon_pose_interp_ca{i}(1,10);
%     odom_pose_ca{i}(:,11) = odom_pose_ca{i}(:,11) + vicon_pose_interp_ca{i}(1,11);
    % END: sneacky tryck, comment it out

    for i = 1:n_logs
        subplot(2,2,1)
        hold on
        plot(odom_pose_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,9)), odom_pose_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,9)), '-*')
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Heading GT vs Heading Odom over time'})
        legend(legend_names_2pdt), ylabel('angle [deg]'), xlabel('time [s]')
        hold off
        
        subplot(2,2,2)
        hold on
        plot(odom_pose_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,10)), odom_pose_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,10)), '-*')
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Pitch GT vs Pitch Odom over time'})
        legend(legend_names_2pdt), ylabel('angle [deg]'), xlabel('time [s]')
        hold off
        
        subplot(2,2,3)
        hold on
        plot(odom_pose_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,11)), odom_pose_ca{i}(:,1), rad2deg(odom_pose_ca{i}(:,11)), '-*')
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Roll GT vs Roll Odomover time'})
        legend(legend_names_2pdt), ylabel('angle [deg]'), xlabel('time [s]')
        hold off
    end
end


% RPY error over time
if(VICON_FILE)
    figure(121), close(121), figure(121)
    
    for i = 1:n_logs
        subplot(2,2,1)
        hold on
        plot(odom_pose_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,9) - odom_pose_ca{i}(:,9)), '-*')
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Heading error over time'})
        legend(legend_names), ylabel('error [deg]'), xlabel('time [s]')
        hold off
        
        subplot(2,2,2)
        hold on
        plot(odom_pose_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,10) - odom_pose_ca{i}(:,10)), '-*')
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Pitch error over time'})
        legend(legend_names), ylabel('error [deg]'), xlabel('time [s]')
        hold off
        
        subplot(2,2,3)
        hold on
        plot(odom_pose_ca{i}(:,1), rad2deg(vicon_pose_interp_ca{i}(:,11) - odom_pose_ca{i}(:,11)), '-*')
        grid on, title({horzcat('Visual Odometry Evaluation - test ', num2str(i)), 'Roll error over time'})
        legend(legend_names), ylabel('error [deg]'), xlabel('time [s]')
        hold off
    end
end



% figs used: 122


%% STUFF

% % compute telta time in vo samples
% freq_ca = {'0.4 [s]','1 [s]','2 [s]', '3 [s]', '4 [s]', '5 [s]'};
% delta_time_vo = cell(1,n_logs);
% figure;
% for n=1:n_logs
% %     comp_time=textread(horzcat(path_ca{n},'/vo_comp_time.txt'), ...
% %         '%f%*[^\n]', 'headerlines', 3, 'delimiter', '\t');
%     % delta_time_vo(1) = odom_pose_ca{n}(1,1);
%     for i=2:size(odom_pose_ca{n},1)-1
%         delta_time_vo{n}(i-1) = odom_pose_ca{n}(i+1,1)-odom_pose_ca{n}(i,1);
%     end
%     mean(delta_time_vo{n})
%     std(delta_time_vo{n})
%     subplot(2,3,n), hold on, 
%     plot(delta_time_vo{n}, '-*');
% %     plot(comp_time, '-*'), 
%     hold off, title(horzcat('Desired period: ', freq_ca{n}));
%     xlabel('Samples'), ylabel('delta time [s]');
% end

% compute vector od VO time starting from 0
% time_vo = odom_pose_ca{n}(:,1) - odom_pose_ca{n}(1,1);

% read start time of vo computation
% start_time_vo = textread('logs/20191127-1252/vo_start_comp_time.txt', '%f64', 'headerlines', 2);
% start_time_vo = start_time_vo-odom_pose_ca{n}(1,1);

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


% % fit line to xyz norm
% p = zeros(n_logs,2);
% for i=1:n_logs
%     p(i,:) = polyfit(dist_accum_ca{i}, xyz_norm{i}(:,1), 1);
% end
% p(:,1)
% % % plot errorn norm and fitted line
% i=1;
% figure;
% plot(dist_accum_ca{i}(:,1), xyz_norm{i}(:,1), dist_accum_ca{i}(:,1), dist_accum_ca{i}(:,1)*p(i,1) + p(i,2))
% legend

% % fit line to xyz norm
% figure;
% for i=1:n_logs
%     p = zeros(n_logs,2);
%     p(i,:) = polyfit(dist_accum_ca{i}, xyz_norm{i}(:,1), 1);
%     subplot(2,3,i), plot(dist_accum_ca{i}(:,1), xyz_norm{i}(:,1), dist_accum_ca{i}(:,1), dist_accum_ca{i}(:,1)*p(i,1) + p(i,2))
%     legend('xyz error norm','fitted line')
% end
% p(:,1)