close all; clc

addpath('../Defocus_Map/');

name= '../desktop/test_images/33.jpg';  

I=im2double(imread(name)); 	
[h, w, c] = size(I);

eth=0.1; 
edgeMap=edge(rgb2gray(I),'canny',eth,1);

std = 1.5;
maxBlur = 15 ;
lambda  = 0.001;

sDMap = defocusEstimation(I,edgeMap,std,maxBlur);

Hf = h/640.0;
Wf = w/480.0;

if Hf>1.2
	h1 = 640;
else
	h1 = h;
end;

if Wf>1.2
	w1 = 480;
else
	w1 = w;
end;

sDMap = imresize(sDMap, [h1, w1], 'nearest');
I = imresize(I, [h1, w1], 'nearest');

fDmap = CreateFullMap(I, sDMap, lambda);
figure; imagesc(fDmap);


mask = hole_region_detection(I, fDmap);


sDMap(mask) = max(max(fDmap)) + 0.3;
fDmap1 = CreateFullMap(I, sDMap, lambda);
figure; imagesc(fDmap1);


































