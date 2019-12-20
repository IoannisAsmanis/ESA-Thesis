% different velocities tests with the new vicon
path_ca = {
    'logs/20191122-1616/with_imu', % 
    'logs/20191122-1625/with_imu', % 
    'logs/20191122-1629/with_imu', % 
    'logs/20191122-1637/with_imu', % 
    'logs/20191122-1639/with_imu'}; % 
vicon_path_ca = {
    'logs/20191122-1521',
    'logs/20191122-1540', %
    'logs/20191122-1549', %
    'logs/20191122-1557', %
    'logs/20191122-1605'}; %

% % experiments at different exposure times
path_ca = {
    'logs/20191122-1637/with_imu', %
%     'logs/20191126-1729/with_imu', % 
    'logs/20191126-1731/with_imu', % 
    'logs/20191126-1735/with_imu', % 
    'logs/20191126-1737/with_imu', % 
    'logs/20191126-1739/with_imu', % 
    'logs/20191126-1743/with_imu', % 
    'logs/20191126-1746/with_imu'}; % 
%     'logs/20191126-1748/with_imu'}; % 
vicon_path_ca = {
    'logs/20191122-1557',
%     'logs/20191126-1623',
    'logs/20191126-1633',
    'logs/20191126-1638.1',
    'logs/20191126-1646',
    'logs/20191126-1651',
    'logs/20191126-1657',
    'logs/20191126-1702'};
%     'logs/20191126-1707'}; 

% % autoexp/exp300 at 0.07 and 0.02m/s
path_ca = {
    'logs/20191122-1637/with_imu', % auto 0.07
%     'logs/20191126-1729/with_imu', % 
    'logs/20191126-1735/with_imu', % 300 0.07
    'logs/20191128-1459/with_imu', % auto at 0.02
    'logs/20191128-1526/with_imu'}; % 300 at 0.02
%     'logs/20191126-1748/with_imu'}; % 
vicon_path_ca = {
    'logs/20191122-1557',
%     'logs/20191126-1623',
    'logs/20191126-1638.1',
    'logs/20191128-1349',
    'logs/20191128-1442'}; % 
%     'logs/20191126-1707'}; 

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
path_ca = {
    'logs/20191129-1504/with_imu', % auto 0.07
    'logs/20191129-1458/with_imu', % auto 0.07
    'logs/20191129-1447/with_imu'}; % 
vicon_path_ca = {
    'logs/20191129-1437',
    'logs/20191129-1421',
    'logs/20191129-1411'}; 
