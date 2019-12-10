#!/bin/bash

pocolog viso2_evaluation.0.log -s /viso2_evaluation.odometry_heading >> no_imu/odom_heading.txt  
pocolog viso2_evaluation.0.log -s /viso2_evaluation.odometry_pitch >> no_imu/odom_pitch.txt  
pocolog viso2_evaluation.0.log -s /viso2_evaluation.odometry_roll >> no_imu/odom_roll.txt  

pocolog viso2_evaluation_imu.0.log -s /viso2_evaluation_imu.odometry_heading >> with_imu/odom_heading.txt  
pocolog viso2_evaluation_imu.0.log -s /viso2_evaluation_imu.odometry_pitch >> with_imu/odom_pitch.txt  
pocolog viso2_evaluation_imu.0.log -s /viso2_evaluation_imu.odometry_roll >> with_imu/odom_roll.txt  
