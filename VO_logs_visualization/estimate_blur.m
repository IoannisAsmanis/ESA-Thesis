%% COMPUTE BLURRINESS OF AN IMAGE AS MAX OF A LAPLACIAN FILTER

addpath('../mdb')

% img=rgb2gray(imread('200exp_moving.png'));
% kernel = [0 1 0; 1 -4 1; 0 1 0];
% blurredImage = imfilter(img, kernel);
% blurriness_200 = max(max(blurredImage))

img=rgb2gray(imread('300exp_moving.png'));
kernel = [0 1 0; 1 -4 1; 0 1 0];
blurredImage = imfilter(img, kernel);
blurriness_300 = max(max(blurredImage))

% img=rgb2gray(imread('400exp_moving.png'));
% kernel = [0 1 0; 1 -4 1; 0 1 0];
% blurredImage = imfilter(img, kernel);
% blurriness_400 = max(max(blurredImage))
% 
% img=rgb2gray(imread('500exp_moving.png'));
% kernel = [0 1 0; 1 -4 1; 0 1 0];
% blurredImage = imfilter(img, kernel);
% blurriness_500 = max(max(blurredImage))
% 
% img=rgb2gray(imread('600exp_moving.png'));
% kernel = [0 1 0; 1 -4 1; 0 1 0];
% blurredImage = imfilter(img, kernel);
% blurriness_600 = max(max(blurredImage))

img=rgb2gray(imread('700exp_moving.png'));
kernel = [0 1 0; 1 -4 1; 0 1 0];
blurredImage = imfilter(img, kernel);
blurriness_700 = max(max(blurredImage))

img=rgb2gray(imread('autoexp_moving.png'));
kernel = [0 1 0; 1 -4 1; 0 1 0];
blurredImage = imfilter(img, kernel);
blurriness_auto = max(max(blurredImage))
