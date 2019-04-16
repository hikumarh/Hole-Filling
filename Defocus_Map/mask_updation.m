function [RDR1, BDR1] = mask_updation(BDR, RDR, GDR, Fmask)

[m, n] = size(BDR);

bsize = 4;
m = m - bsize;
n = n - bsize;

for i=1:bsize:m
	for j=1:bsize:n
		bn = sum(sum(BDR(i:i+bsize,j:j+bsize)));
		rn = sum(sum(RDR(i:i+bsize,j:j+bsize)));
		gn = sum(sum(GDR(i:i+bsize,j:j+bsize)));
		
		if(gn > rn )&&(gn > bn)
			BDR(i:i+bsize,j:j+bsize) = 0;
			RDR(i:i+bsize,j:j+bsize) = 0;
		end;

	end;
end;

bsize = 16;
m = m - bsize;
n = n - bsize;
RDR1 = zeros(size(RDR));
BDR1 = zeros(size(RDR));
for i=1:bsize:m
	for j=1:bsize:n

        bn = sum(sum(BDR(i:i+bsize,j:j+bsize)));
		rn = sum(sum(RDR(i:i+bsize,j:j+bsize)));
		fn = sum(sum(Fmask(i:i+bsize,j:j+bsize)));
		
		if((fn > rn) & (fn > bn))
			BDR1(i:i+bsize,j:j+bsize) = 1;
			RDR1(i:i+bsize,j:j+bsize) = 0;			
        elseif((rn > bn))
			RDR1(i:i+bsize,j:j+bsize) = 1;
			BDR1(i:i+bsize,j:j+bsize) = 0;
        elseif (bn > rn)
			BDR1(i:i+bsize,j:j+bsize) = 1;
			RDR1(i:i+bsize,j:j+bsize) = 0;
		end;

	end;
end;


