#!/bin/bash    
pocolog unit_visual_odometry.0.log -s /viso2_evaluation.odometry_in_world_pose >> odom_world.txt
pocolog unit_visual_odometry.0.log -s /viso2_evaluation.diff_pose >> diff_pose.txt 
pocolog unit_visual_odometry.0.log -s /viso2_evaluation.odometry_heading >> odometry_heading.txt
pocolog unit_visual_odometry.0.log -s /viso2_evaluation.ground_truth_heading >> gt_heading.txt
pocolog unit_visual_odometry.0.log -s /viso2_evaluation.ground_truth_pose >> gt_pose.txt  
pocolog unit_visual_odometry.0.log -s /viso2_evaluation.perc_error >> perc_error.txt  
pocolog unit_visual_odometry.0.log -s /viso2_evaluation.travelled_distance >> travelled_distance.txt  
pocolog unit_visual_odometry.0.log -s /viso2_evaluation.odometry_heading >> odom_heading.txt  
pocolog unit_visual_odometry.0.log -s /viso2_evaluation.odometry_pitch >> odom_pitch.txt  
pocolog unit_visual_odometry.0.log -s /viso2_evaluation.odometry_roll >> odom_yaw.txt  
