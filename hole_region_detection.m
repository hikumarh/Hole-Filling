function mask = hole_region_detection(I, fDmap)
	
	[h, w, ~] = size(I);
    I1 = rgb2gray(I);
    sky_mask = sky_detect(I1);
    mn = min(min(sky_mask));
    ind = ((I1>(50.0/255))& (I1<(253.0/255))); 
    
    mask1 = (sky_mask < 1*10^-8);
    i = 0;
    if (sum(sum(mask1))< 4000)
        mask1 = (sky_mask < 5*10^-8);
        if (sum(sum(mask1))< 4000)
            for i=1:12
                ths = i*10^-7;
                mask1 = (sky_mask < ths);
                if sum(sum(mask1))> 4000
                    break;
                end;
            end;
        end;
    end;
    if ((i== 12)&& (sum(sum(mask1)) < 4000))
        mask1 = 0*mask1;
    end;

%----------------------------------------------    
% sky region detection    
    mask_s = (sky_mask < 10^-10);
    ind_1 = (I(:,:,1) == I(:,:,2));
    ind_2 = (I(:,:,1) == I(:,:,3));

    ind_c = ind_1 & ind_2;
    indf = ind_c & mask_s;

   
    %figure; imshow(ind);
    ind(ind_c) = 0;
    ind(indf)  = 1;
%---------------------------------------------------
    
% saturation region stats
%     ind1 = ((I1>(50.0/255)) & (I1<(253.0/255))); 
% 
%     %ind1 = mask_s & ind1;
%     ind = ind1 & ind;
%------------------------------  
    % saturation region mask
    ind1 = (I1==1); 
    CC=bwconncomp(ind1);
    nObject=CC.NumObjects;
    num = round(h*w/22);
    for n=1: nObject
        if(length(CC.PixelIdxList{n}) < num)
            ind1(CC.PixelIdxList{n}) = 0;
        end;
    end;
    ind = ind1 | ind;
%---------------------------------------------------------      
    mask1 = mask1 & ind;
    
    m1 = min(min(fDmap));
    m2 = max(max(fDmap));

    m  = m1 + (m2-m1)*3/4;
    mask2 = (fDmap < m);
    %figure; imshow(mask2);

    se = strel('disk',5);
    %mask = mask1 & mask2;
    mask = imdilate(mask1, se);

    se = strel('disk', 7);      
    mask = imerode(mask,se);
    
    se = strel('disk', 3);      
    mask = imdilate(mask,se);
    
    gmode = mode(double(uint8(100*I1(mask)))/100);
    
    mask(abs(I1-gmode)>.2)=0;
end