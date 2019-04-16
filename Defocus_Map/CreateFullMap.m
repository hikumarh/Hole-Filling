function [ fullDMap ] = CreateFullMap( I, sparseDMap,lambda )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[h,w,c]=size(I);
sizeI=w*h;
constsMap=sparseDMap>0.0001;
L=getLaplacian(I,1);
D=spdiags(constsMap(:),0,sizeI,sizeI);

% try pcg if you get out of memory error using the \ solver
% x=pcg(L+lambda*D,lambda*D*sparseDMap(:),1e-6,1000); 
x=(L+lambda*D)\(lambda*D*sparseDMap(:));
fullDMap=reshape(x,h,w);

end

