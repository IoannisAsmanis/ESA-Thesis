# -*- coding: utf-8 -*-
"""
Created on Tue Oct 29 13:57:34 2019

@author: Matteo De Benedetti

Usage: python overlap_calculator.py --first frames/left_001.png \ --second frames/left002.png
"""

import argparse
import numpy as np
import cv2
import os
import imageio


def applySIFT(image): 
    # detect keypoints in the image
    #detector = cv2.FeatureDetector_create("SIFT")
    #keypts = detector.detect(image)
    # extract features from the image
    #extractor = cv2.DescriptorExtractor_create("SIFT")
    #(keypts, descr) = extractor.compute(image, keypts)

    sift = cv2.xfeatures2d.SIFT_create()
    (keypts, descr) = sift.detectAndCompute(image, None)
    
    # convert the keypoints from KeyPoint objects to NumPy arrays
    keypts = np.float32([kp.pt for kp in keypts])
    
    # return a tuple of keypoints and descriptor
    return (keypts, descr)
    

def matchFeatures(keyptsA, keyptsB, descrA, descrB, ratio, reprojThresh): 
    # compute the raw matches and initialize the list of actual matches
    matcher = cv2.DescriptorMatcher_create("BruteForce")
    rawMatches = matcher.knnMatch(descrA, descrB, 2)
    matches = []
 
    # loop over the raw matches
    for m in rawMatches:
        # ensure the distance is within a certain ratio of each other 
        # (i.e. Lowe's ratio test)
        if len(m) == 2 and m[0].distance < m[1].distance * ratio:
            matches.append((m[0].trainIdx, m[0].queryIdx))
    
    # computing a homography requires at least 4 matches
    if len(matches) > 4:
        # construct the two sets of points
        ptsA = np.float32([keyptsA[i] for (_, i) in matches])
        ptsB = np.float32([keyptsB[i] for (i, _) in matches])

        # compute the homography between the two sets of points
        (H, status) = cv2.findHomography(ptsA, ptsB, cv2.RANSAC,
            reprojThresh)

        # return the matches along with the homograpy matrix and status of 
        # each matched point
        return (matches, H, status)

    # otherwise, no homograpy could be computed
    return None
    

def applyTransform(lb_A, rt_A, T):
    # Apply transformation
    lb_B = T*lb_A;
    rt_B = T*rt_A;
    
    # return the corners of the second image
    return (lb_B, rt_B)


def computeOverlapPercentage(lb_A, rt_A, lb_B, rt_B, imgW, imgH):
    # compute the overlap area corners
    lb_ov = [max(lb_A[0], lb_B[0]), max(lb_A[1], lb_B[1])];
    rt_ov = [min(rt_A[0], rt_B[0]), min(rt_A[1], rt_B[1])];
    
    # compute overlap area and image area
    ov_area = abs(max(0, rt_ov[0] - lb_ov[0])*max(0, rt_ov[1] - lb_ov[1]));
    img_area = imgW*imgH;
    
    # compute the overlap percentage
    ov_perc = ov_area/img_area;
    
    # return the overlap percentage
    return ov_perc


# Parsing arguments
#ap = argparse.ArgumentParser()
#ap.add_argument("-f", "--imgA", required=True,
#    help="path to the first image")
#ap.add_argument("-s", "--imgB", required=True,
#    help="path to the second image")
#ap.add_argument("-s", "--imgW", required=True,
#    help="image width in pixels")
#ap.add_argument("-s", "--imgH", required=True,
#    help="image height in pixels")
#args = vars(ap.parse_args())
#
#imageA = cv2.imread(args["first"])
#imageB = cv2.imread(args["second"])
#imgW = args["imgW"]
#imgH = args["imgH"]


imageA = cv2.imread('frames/left318.png',cv2.IMREAD_GRAYSCALE)
imageB = cv2.imread('frames/left338.png',cv2.IMREAD_GRAYSCALE)
imgW = 1024
imgH = 768

# Initialize imageA corners
lb_A = np.array([[0], [0], [1]]);
rt_A = np.array([[imgW], [imgH], [1]]);

# show the images
cv2.imshow("Image A", imageA)
cv2.imshow("Image B", imageB)

# detect features and descriptors
(keyptsA, descrA) = applySIFT(imageA);
(keyptsB, descrB) = applySIFT(imageB);

# find transformation
(matches, T, status) = matchFeatures(keyptsA, keyptsB, descrA, descrB, 0.75, 4.0);

# Apply transform to imageA bounding box corners (LeftBottom, RightTop)
(lb_B, rt_B) = applyTransform(lb_A, rt_A, T); 

# Compute the overlap percentage
ov_perc = computeOverlapPercentage(lb_A, rt_A, lb_B, rt_B, imgW, imgH);









# TODO show the stitched images and the overlapping area

# close script
cv2.waitKey(0)
cv2.destroyAllWindows()