#!/bin/bash    
mkdir no_imu
pocolog viso2_evaluation.0.log -s /viso2_evaluation.odometry_in_world_pose >> no_imu/odom_world.txt
pocolog viso2_evaluation.0.log -s /viso2_evaluation.diff_pose >> no_imu/diff_pose.txt 
pocolog viso2_evaluation.0.log -s /viso2_evaluation.odometry_heading >> no_imu/odometry_heading.txt
pocolog viso2_evaluation.0.log -s /viso2_evaluation.ground_truth_heading >> no_imu/gt_heading.txt
pocolog viso2_evaluation.0.log -s /viso2_evaluation.ground_truth_pose >> no_imu/gt_pose.txt  
pocolog viso2_evaluation.0.log -s /viso2_evaluation.perc_error >> no_imu/perc_error.txt  
pocolog viso2_evaluation.0.log -s /viso2_evaluation.travelled_distance >> no_imu/travelled_distance.txt  

mkdir with_imu
pocolog viso2_evaluation_imu.0.log -s /viso2_evaluation_imu.odometry_in_world_pose >> with_imu/odom_world.txt
pocolog viso2_evaluation_imu.0.log -s /viso2_evaluation_imu.diff_pose >> with_imu/diff_pose.txt 
pocolog viso2_evaluation_imu.0.log -s /viso2_evaluation_imu.odometry_heading >> with_imu/odometry_heading.txt
pocolog viso2_evaluation_imu.0.log -s /viso2_evaluation_imu.ground_truth_heading >> with_imu/gt_heading.txt
pocolog viso2_evaluation_imu.0.log -s /viso2_evaluation_imu.ground_truth_pose >> with_imu/gt_pose.txt  
pocolog viso2_evaluation_imu.0.log -s /viso2_evaluation_imu.perc_error >> with_imu/perc_error.txt  
pocolog viso2_evaluation_imu.0.log -s /viso2_evaluation_imu.travelled_distance >> with_imu/travelled_distance.txt  
