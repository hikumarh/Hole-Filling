%% read the input image
close all,clear all;
I=im2double(imread('/host/Dropbox/Near_Far_database/test/t3b.jpg'));
%I = imresize(I,0.1);
%% get edge map
% Canny edge detector is used here. Other edge detectors can also be used
eth=0.07; % thershold for canny edge detector
edgeMap=edge(rgb2gray(I),'canny',eth,1);

%% estimate the defocus map
std=1.5;
lambda=0.001;
maxBlur=5;


%% separating color planes and edgemaps

R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

RedgeMap=edge(R,'canny',eth,1);
GedgeMap=edge(G,'canny',eth,1);
BedgeMap=edge(B,'canny',eth,1);

edges = (RedgeMap & GedgeMap & BedgeMap);

%% separating out planes (near focus and far focus)
[RsDMap, fDmap] = defocusEstimation(R,edges,std,lambda,maxBlur);
[GsDMap, fDmap] = defocusEstimation(G,edges,std,lambda,maxBlur);
[BsDMap, fDmap] = defocusEstimation(B,edges,std,lambda,maxBlur);

I1 = rgb2gray(I);
a1 = I(:,:,1);
a(:,1)  = a1(:);
a1 = I(:,:,2);
a(:,2)  = a1(:);
a1 = I(:,:,3);
a(:,3)  = a1(:);
[coff, scor, latent] = pca(a);
J = wiener2(I1,[4 4], latent(3,1));

[sDMap, fDmap] = defocusEstimation(J,edgeMap,std,lambda,maxBlur);


RDR = (RsDMap > BsDMap);
BDR = (BsDMap > RsDMap);
GDR = ((GsDMap > BsDMap) & (GsDMap > RsDMap));



figure; imshow(RDR);
figure; imshow(GDR);
figure; imshow(BDR);

%RDR = bwareaopen(RDR, 5);
%BDR = bwareaopen(BDR, 5);
%% Correct the blur

Fmask = (sDMap < 1).*edges;
RDR = RDR & (~Fmask).*edges;
BDR = BDR & (~Fmask).*edges;

%%
%bwareaopen
[RDR, BDR] = mask_updation(BDR, RDR, GDR, Fmask);
sigma_max = max(max(RDR.*sDMap));
sDMapC = abs(sDMap - sigma_max*RDR.*edgeMap);
sDMapC = sDMapC + sigma_max*BDR.*edgeMap; % + sigma_max*Fmask;

%figure; imshow(sDMap);
%% create full map
%return
[ fDmap ] = Createfullmap( I, sDMapC, lambda );
figure; imagesc(fDmap);

[ fDmap ] = Createfullmap( I, sDMap, lambda );
figure; imagesc(fDmap);

